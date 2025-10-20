// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/colores_app.dart';


// estados de la pantalla
enum _Stage { scanning, list, password, connecting }

class PaginaConfigWifi extends StatefulWidget {
  const PaginaConfigWifi({super.key});

  @override
  State<PaginaConfigWifi> createState() => _PaginaConfigWifiState();
}

class _PaginaConfigWifiState extends State<PaginaConfigWifi> {
  _Stage _stage = _Stage.scanning;
  final List<String> _networks = const [
    'Mi Casa WiFi',
    'MOVISTAR_5G',
    'Oficina_2.4GHz',
    'TP-Link_Guest',
    'Vecino_WiFi',
    'Café_Libre'
  ];
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

    // Simula búsqueda inicial
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _stage = _Stage.list);
    });
  }

  @override
  void dispose() {
    _connectTimer?.cancel();
    _pwController.dispose();
    super.dispose();
  }

  void _rescan() {
    setState(() {
      _stage = _Stage.scanning;
      _selected = null;
      _pwController.clear();
    });
    Future.delayed(
  const Duration(milliseconds: 300),
  () => Navigator.pop(context, true),
);
  }

  void _goToPassword(String ssid) {
    setState(() {
      _selected = ssid;
      _stage = _Stage.password;
      _pwController.clear();
      _obscure = true;
    });
  }

  void _startConnect(String network, [String? password]) {
    setState(() {
      _stage = _Stage.connecting;
      _progress = 0.0;
    });

    _connectTimer?.cancel();
    _connectTimer = Timer.periodic(const Duration(milliseconds: 120), (t) {
      setState(() {
        _progress += 0.02;
        if (_progress >= 1.0) {
          _progress = 1.0;
          t.cancel();
          // Simula conexión exitosa y vuelve a la pantalla anterior con un resultado.
          Future.delayed(
              const Duration(milliseconds: 300), () => Navigator.pop(context, true));
        }
      });
    });
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
          Expanded(
            child: ListView.separated(
              itemCount: _networks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final name = _networks[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.signal_wifi_4_bar, color: kPrimario),
                    title: Text(name),
                    subtitle: const Text('Red segura • Excelente'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _goToPassword(name),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
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
                              ? () => _startConnect(ssid, _pwController.text)
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