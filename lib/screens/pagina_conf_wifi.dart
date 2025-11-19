// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../utils/colores_app.dart';


// estados de la pantalla
enum _Stage { scanning, list, password, connecting }

class PaginaConfigWifi extends StatefulWidget {
  const PaginaConfigWifi({super.key});

  @override
  State<PaginaConfigWifi> createState() => _PaginaConfigWifiState();
}

class _PaginaConfigWifiState extends State<PaginaConfigWifi> with WidgetsBindingObserver {
  _Stage _stage = _Stage.scanning;
  // Lista dinámica de resultados reales
  List<WiFiAccessPoint> _scanResults = [];
  String? _selected;
  double _progress = 0.0;
  Timer? _connectTimer;

  // controller para la contraseña en la vista "password"
  late final TextEditingController _pwController;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _pwController = TextEditingController()
      ..addListener(() {
        // actualiza para habilitar/deshabilitar botón
        if (mounted) setState(() {});
      });

    WidgetsBinding.instance.addObserver(this);
    _initScan();
  }

  @override
  void dispose() {
    _connectTimer?.cancel();
    _pwController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reintenta al volver a primer plano
      _initScan();
    }
  }

  Future<void> _initScan() async {
    setState(() {
      _stage = _Stage.scanning;
      _scanResults = [];
    });

    // 1. Checar soporte
    final can = await WiFiScan.instance.canStartScan(askPermissions: true);
    if (can != CanStartScan.yes) {
      // Intentar pedir permisos manualmente si es tema de permisos
      await _ensurePermissions();
    }

    // 2. Lanzar escaneo
    final ok = await WiFiScan.instance.startScan();
    if (!ok) {
      if (mounted) setState(() => _stage = _Stage.list); // mostrará vacío / mensaje
      return;
    }
    // 3. Esperar un momento y leer
    await Future.delayed(const Duration(seconds: 1));
    final results = await WiFiScan.instance.getScannedResults();
    if (!mounted) return;
    setState(() {
      _scanResults = results.where((ap) => (ap.ssid).trim().isNotEmpty).toList()
        ..sort((a, b) => b.level.compareTo(a.level));
      _stage = _Stage.list;
    });
  }

  Future<void> _ensurePermissions() async {
    // Android 13+: permiso NEARBY_WIFI_DEVICES se maneja internamente por wifi_scan.
    // Aquí nos enfocamos en ubicación para <=12 y runtime general.
    final statusLoc = await Permission.locationWhenInUse.status;
    if (!statusLoc.isGranted) {
      await Permission.locationWhenInUse.request();
    }
  }

  void _rescan() {
    _selected = null;
    _pwController.clear();
    _initScan();
  }

  void _goToPassword(String ssid) {
    setState(() {
      _selected = ssid;
      _stage = _Stage.password;
      _pwController.clear();
      _obscure = true;
    });
  }

// Reemplaza esta función para conectar de verdad
  void _startConnect(String network, {String? password, WiFiAccessPoint? ap}) async {
    setState(() {
      _selected = network;
      _stage = _Stage.connecting;
      _progress = 0.0;
    });

    // Animación de progreso (no cierra sola)
    _connectTimer?.cancel();
    _connectTimer = Timer.periodic(const Duration(milliseconds: 120), (t) {
      if (!mounted) return;
      setState(() {
        // sube hasta 90% mientras intentamos
        _progress = (_progress + 0.02).clamp(0.0, 0.9);
      });
    });

    final connected = await _connectToWifi(network, password: password, ap: ap);
    if (!mounted) return;

    if (connected) {
      final hasNet = await _hasInternet();
      _connectTimer?.cancel();
      setState(() => _progress = 1.0);

      if (hasNet) {
        await Future.delayed(const Duration(milliseconds: 250));
        Navigator.pop(context, true);
      } else {
        // Posible portal cautivo
        final open = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Conectado sin Internet'),
            content: const Text('Puede ser un portal cautivo. ¿Abrir el navegador para iniciar sesión?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(_, false), child: const Text('Cancelar')),
              TextButton(onPressed: () => Navigator.pop(_, true), child: const Text('Abrir')),
            ],
          ),
        );
        if (open == true) {
          await _openCaptivePortal();
        }
        setState(() => _stage = _Stage.list);
      }
    } else {
      _connectTimer?.cancel();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo conectar a la red')),
      );
      setState(() => _stage = _Stage.list);
    }
  }

// Determina seguridad a partir de capabilities
  NetworkSecurity _securityFor(WiFiAccessPoint ap) {
    final caps = ap.capabilities.toUpperCase();
    if (caps.contains('WEP')) return NetworkSecurity.WEP;
    if (caps.contains('WPA3')) return NetworkSecurity.WPA; // fallback
    if (caps.contains('WPA')) return NetworkSecurity.WPA;
    return NetworkSecurity.NONE;
  }

  WiFiAccessPoint? _apBySsid(String ssid) {
    try {
      return _scanResults.firstWhere((a) => a.ssid == ssid);
    } catch (_) {
      return null;
    }
  }

  Future<bool> _connectToWifi(String ssid, {String? password, WiFiAccessPoint? ap}) async {
    try {
      final apObj = ap ?? _apBySsid(ssid);
      final sec = apObj != null ? _securityFor(apObj) : (password == null ? NetworkSecurity.NONE : NetworkSecurity.WPA);

      // Android 10+: el sistema puede mostrar diálogo (WifiNetworkSpecifier/Suggestion)
      final ok = await WiFiForIoTPlugin.connect(
        ssid,
        password: sec == NetworkSecurity.NONE ? null : password,
        security: sec,
        joinOnce: true,       // no guardar permanente
        withInternet: true,   // preferir redes con internet
        isHidden: false,
      );
      return ok == true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _hasInternet() async {
    try {
      final uri = Uri.parse('http://connectivitycheck.gstatic.com/generate_204');
      final r = await http.get(uri).timeout(const Duration(seconds: 5));
      return r.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  Future<void> _openCaptivePortal() async {
    final uri = Uri.parse('http://example.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFondoCrema,
      appBar: AppBar(
        title: const Text('Configuración WiFi'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPrimario),
        titleTextStyle: const TextStyle(
          color: kPrimario,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            if (_stage == _Stage.scanning) _buildScanningCard(),
            if (_stage == _Stage.list) _buildListView(),
            if (_stage == _Stage.password) _buildPasswordCard(),
            if (_stage == _Stage.connecting) _buildConnectingCard(),
          ],
        ),
      ),
    );
  }

  // ---------- UI: Buscando ----------
  Widget _buildScanningCard() {
    return Expanded(
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi, color: kPrimario, size: 40),
                const SizedBox(height: 12),
                const Text('Buscando Redes WiFi',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text('Detectando redes disponibles para tu dispositivo',
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 18),
                IconButton(
                  onPressed: _rescan,
                  icon: const Icon(Icons.refresh, color: kPrimario),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- UI: Lista de redes ----------
  Widget _buildListView() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.wifi, color: Colors.green),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Selecciona tu Red WiFi',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  IconButton(
                    onPressed: _rescan,
                    icon: const Icon(Icons.refresh, color: kPrimario),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_scanResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: Colors.grey, size: 40),
            const SizedBox(height: 8),
            const Text('No se encontraron redes', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              'Activa Wi‑Fi o revisa permisos de ubicación',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _rescan,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            )
          ],
        ),
      );
    }
    return ListView.separated(
      itemCount: _scanResults.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final ap = _scanResults[i];
        final name = ap.ssid.isEmpty ? '(SSID oculto)' : ap.ssid;
        final level = ap.level;
        final quality = _signalQuality(level);
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(_wifiIcon(level), color: kPrimario),
            title: Text(name),
            subtitle: Text("Señal: $quality • ${_isOpen(ap) ? 'Abierta' : 'Segura'}"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              if (_isOpen(ap)) {
                setState(() => _selected = name);
                _startConnect(name, ap: ap); // conecta directo si es abierta
              } else {
                _goToPassword(name);
              }
            },
          ),
        );
      },
    );
  }

  String _signalQuality(int level) {
    if (level >= -55) return 'Excelente';
    if (level >= -65) return 'Muy buena';
    if (level >= -75) return 'Buena';
    if (level >= -85) return 'Regular';
    return 'Débil';
  }

  IconData _wifiIcon(int level) {
    if (level >= -55) return Icons.signal_wifi_4_bar;
    if (level >= -65) return Icons.signal_wifi_4_bar; // fallback icon (no 3_bar symbol)
    if (level >= -75) return Icons.network_wifi_3_bar; // alternative icons
    if (level >= -85) return Icons.network_wifi_2_bar;
    return Icons.network_wifi_1_bar;
  }

  // Determina si la red es abierta (sin WEP/WPA)
  bool _isOpen(WiFiAccessPoint ap) {
    final caps = ap.capabilities.toUpperCase();
    return !(caps.contains('WEP') || caps.contains('WPA'));
  }

  // ---------- UI: Ingresar contraseña (estilo Figma) ----------
  Widget _buildPasswordCard() {
    final ssid = _selected ?? '';
    final canConnect = _pwController.text.isNotEmpty;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chip "Volver a redes"
          GestureDetector(
            onTap: () => setState(() => _stage = _Stage.list),
            child: Container(
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: kPrimario.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.only(bottom: 12),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, size: 16, color: kPrimario),
                  SizedBox(width: 6),
                  Text('Volver a redes',
                      style: TextStyle(
                        color: kPrimario,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          // Card con formulario
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.signal_wifi_4_bar, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            ssid,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Ingresa la contraseña para conectarte a esta red',
                        style: TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Contraseña WiFi',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _pwController,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: 'Ingresa la contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            // ignore: deprecated_member_use
                            borderSide: BorderSide(color: kPrimario.withOpacity(0.25), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: kPrimario, width: 2),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F0E5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lightbulb_outline, color: Color(0xFFFFB300)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Asegúrate de que tu ESP32 esté encendido y cerca del router',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: canConnect
                              ? () => _startConnect(ssid, password: _pwController.text, ap: _apBySsid(ssid))
                              : null,
                          style: ButtonStyle(
                            minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            foregroundColor: const WidgetStatePropertyAll(Colors.white),
                            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                              (states) => states.contains(WidgetState.disabled)
                                  ? Colors.green.shade200
                                  : kPrimario,
                            ),
                          ),
                          child: const Text('Conectar Dispositivo'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- UI: Conectando ----------
  Widget _buildConnectingCard() {
    return Expanded(
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi, color: kPrimario, size: 38),
                const SizedBox(height: 12),
                Text(
                  'Conectando...\nVinculando ${_selected ?? ''}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 260,
                  child: LinearProgressIndicator(
                    value: _progress,
                    color: kPrimario,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(_progress * 100).clamp(0, 100).toInt()}% completado',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: () {
                    _connectTimer?.cancel();
                    setState(() => _stage = _Stage.list);
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}