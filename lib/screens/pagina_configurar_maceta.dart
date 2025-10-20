import 'package:flutter/material.dart';
import '../utils/colores_app.dart';
import '../widgets/tarjeta_paso.dart';

class PaginaConfigurarMaceta extends StatefulWidget {
  const PaginaConfigurarMaceta({super.key});

  @override
  State<PaginaConfigurarMaceta> createState() => _PaginaConfigurarMacetaState();
}

class _PaginaConfigurarMacetaState extends State<PaginaConfigurarMaceta> {
  bool _wifiListo = false;
  bool _plantaLista = false;
  bool _sensoresListos = false;

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
              children: [
                // Logo
                Image.asset('assets/SPROUTY_SF.png', height: 108),
                const SizedBox(height: 16),
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                ),
                const SizedBox(height: 20),

                // Tarjetas de pasos
                TarjetaPaso(
                  icono: Icons.wifi_rounded,
                  titulo: 'Conectar Wi-Fi',
                  subtitulo: 'Vincularemos tu ESP32 a la red',
                  listo: _wifiListo,
                  onTap: () async {
                    // TODO: Navegar a flujo de conexión WiFi
                    // await Navigator.pushNamed(context, '/config_wifi');
                    setState(() => _wifiListo = true);
                  },
                ),
                const SizedBox(height: 12),
                TarjetaPaso(
                  icono: Icons.eco_rounded,
                  titulo: 'Elegir Planta',
                  subtitulo: 'Selecciona la especie que vas a cuidar',
                  listo: _plantaLista,
                  onTap: () async {
                    // TODO: Navegar a catálogo o selector
                    // await Navigator.pushNamed(context, '/elegir_planta');
                    setState(() => _plantaLista = true);
                  },
                ),
                const SizedBox(height: 12),
                TarjetaPaso(
                  icono: Icons.settings_input_component_rounded,
                  titulo: 'Configurar Sensores',
                  subtitulo: 'Ajusta los parámetros de monitoreo',
                  listo: _sensoresListos,
                  onTap: () async {
                    // TODO: Navegar a pantalla de parámetros por planta
                    // await Navigator.pushNamed(context, '/config_sensores');
                    setState(() => _sensoresListos = true);
                  },
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _todoListo
                        ? () {
                            // Cuando los 3 pasos estén listos, enviamos a la app principal
                            Navigator.pushReplacementNamed(context, '/principal');
                          }
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
