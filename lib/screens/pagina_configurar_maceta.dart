// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../utils/colores_app.dart';
import '../utils/especie.dart';
import '../widgets/tarjeta_paso.dart';

import 'pagina_catalogo_tarjeta.dart';
import 'pagina_agregar_especie.dart';

class PaginaConfigurarMaceta extends StatefulWidget {
  const PaginaConfigurarMaceta({super.key});

  @override
  State<PaginaConfigurarMaceta> createState() => _PaginaConfigurarMacetaState();
}

class _PaginaConfigurarMacetaState extends State<PaginaConfigurarMaceta> {
  bool _wifiListo = false;
  bool _plantaLista = false;
  bool _sensoresListos = false;

  Especie? _plantaSeleccionada;
  String? _nombreMaceta;
  Map<String, dynamic>? _configSensores;

  bool get _todoListo => _wifiListo && _plantaLista && _sensoresListos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFondoCrema,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Image.asset(
                  'assets/SPROUTY_SF.png',
                  height: 108,
                  errorBuilder: (_, __, ___) =>
                      const SizedBox(height: 108, child: Icon(Icons.image)),
                ),
                const SizedBox(height: 16),

                // Títulos
                Text(
                  '¡Bienvenido a SPROUTY!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Configuremos tu maceta inteligente',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 20),

                // Paso 1: Wi-Fi
                TarjetaPaso(
                  icono: Icons.wifi_rounded,
                  titulo: 'Conectar Wi-Fi',
                  subtitulo: 'Vincularemos tu ESP32 a la red',
                  listo: _wifiListo,
                  onTap: () async {
                    final ok = await Navigator.pushNamed(
                      context,
                      '/config_wifi',
                    ) as bool?; 

                    if (!mounted) return;
                    if (ok == true) {
                      setState(() => _wifiListo = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wi-Fi conectado correctamente')),
                      );
                    }
                  },
                ),

                const SizedBox(height: 12),

                // Paso 2: Elegir planta (Catálogo -> Nombrar -> vuelve aquí)
                TarjetaPaso(
                  icono: Icons.eco_rounded,
                  titulo: 'Elegir Planta',
                  subtitulo: _plantaSeleccionada == null
                      ? 'Selecciona la especie que vas a cuidar'
                      : 'Seleccionada: ${_plantaSeleccionada!.nombre}'
                        '${_nombreMaceta == null ? '' : ' • "${_nombreMaceta!}"'}',
                  listo: _plantaLista,
                  onTap: () async {
                    final result = await Navigator.push<Map<String, dynamic>>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PaginaCatalogoTarjeta(),
                      ),
                    );
                    if (!mounted) return;

                    if (result != null && result['especie'] is Especie) {
                      setState(() {
                        _plantaSeleccionada = result['especie'] as Especie;
                        _nombreMaceta = result['nombre'] as String?;
                        _plantaLista = true;

                        // Si cambiaste de especie, resetea sensores
                        _configSensores = null;
                        _sensoresListos = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Planta: ${_plantaSeleccionada!.nombre}'
                            '${_nombreMaceta == null ? '' : ' • "${_nombreMaceta!}"'}',
                          ),
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 12),

                // Paso 3: Configurar sensores
                TarjetaPaso(
                  icono: Icons.settings_input_component_rounded,
                  titulo: 'Configurar Sensores',
                  subtitulo: _configSensores == null
                      ? 'Ajusta los parámetros de monitoreo'
                      : _resumenSensores(_configSensores!),
                  listo: _sensoresListos,
                  onTap: () async {
                    if (_plantaSeleccionada == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Primero selecciona una planta.'),
                        ),
                      );
                      return;
                    }

                    final res = await Navigator.push<Map<String, dynamic>>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaginaAgregarEspecie(
                          nombrePlanta: _plantaSeleccionada!.nombre,
                        ),
                      ),
                    );
                    if (!mounted) return;

                    if (res != null) {
                      setState(() {
                        _configSensores = res;
                        _sensoresListos = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Parámetros guardados correctamente'),
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Botón final
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _todoListo
                        ? () => Navigator.pushReplacementNamed(
                              context,
                              '/principal',
                            )
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimario,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Configurar mi Maceta'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Este proceso tomará solo unos minutos',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.black45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _resumenSensores(Map<String, dynamic> v) {
    // Formatea: H:50% · T:18–24°C · L:300–600 lux
    String h = (v['humedad'] as double).toInt().toString();
    String tMin = (v['tempMin'] as double).toInt().toString();
    String tMax = (v['tempMax'] as double).toInt().toString();
    String lMin = (v['luzMin'] as double).toInt().toString();
    String lMax = (v['luzMax'] as double).toInt().toString();
    return 'H:$h% · T:$tMin–$tMax°C · L:$lMin–$lMax lux';
  }
}
