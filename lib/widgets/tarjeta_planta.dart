import 'package:flutter/material.dart';
import '../utils/colores_app.dart';
import 'tarjeta_sensor.dart';

/// Tarjeta para mostrar una planta con sus métricas actuales (Temp/Humedad/Luz),
/// un aviso de acción requerida y accesos a:
///  - Editar parámetros
///  - Ver recomendaciones detalladas
class TarjetaPlanta extends StatelessWidget {
  final String nombre;
  final String especie;

  final bool tempOk;
  final bool humedadOk;
  final bool luzOk;
  final bool requiereAccion;

  final String tempTexto;
  final String humedadTexto;
  final String luzTexto;

  final VoidCallback onEditarParametros;
  final VoidCallback onVerRecomendaciones;

  const TarjetaPlanta({
    super.key,
    required this.nombre,
    required this.especie,
    required this.tempOk,
    required this.humedadOk,
    required this.luzOk,
    required this.requiereAccion,
    required this.tempTexto,
    required this.humedadTexto,
    required this.luzTexto,
    required this.onEditarParametros,
    required this.onVerRecomendaciones,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Cabecera: nombre + especie + botón de parámetros
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TituloPlanta(
                  nombre: nombre,
                  especie: especie,
                  muestraIndicador: requiereAccion,
                ),
                TextButton.icon(
                  onPressed: onEditarParametros,
                  icon: const Icon(Icons.settings_outlined, color: kPrimario, size: 20),
                  label: const Text('Parámetros', style: TextStyle(color: kPrimario)),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Métricas
            Row(
              children: [
                Expanded(
                  child: TarjetaSensor(
                    titulo: 'Temperatura',
                    valor: tempTexto,
                    colorEstado: tempOk ? const Color(0xFFC8E6C9) : const Color(0xFFFFEBEE),
                    icono: Icons.thermostat,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TarjetaSensor(
                    titulo: 'Humedad',
                    valor: humedadTexto,
                    colorEstado: humedadOk ? const Color(0xFFC8E6C9) : const Color(0xFFFFEBEE),
                    icono: Icons.water_drop_outlined,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TarjetaSensor(
                    titulo: 'Luz',
                    valor: luzTexto,
                    colorEstado: luzOk ? const Color(0xFFC8E6C9) : const Color(0xFFFFEBEE),
                    icono: Icons.wb_sunny_outlined,
                  ),
                ),
              ],
            ),

            // Aviso si requiere acción
            if (requiereAccion) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Acción requerida',
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Botón para ver recomendaciones
            OutlinedButton.icon(
              onPressed: onVerRecomendaciones,
              icon: const Icon(Icons.notes),
              label: const Text('Ver Recomendaciones Detalladas'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                foregroundColor: kPrimario,
                side: const BorderSide(color: kDivisor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Subcomponente de cabecera: nombre + especie + indicador rojo opcional.
class _TituloPlanta extends StatelessWidget {
  final String nombre;
  final String especie;
  final bool muestraIndicador;

  const _TituloPlanta({
    required this.nombre,
    required this.especie,
    required this.muestraIndicador,
  });

  @override
  Widget build(BuildContext context) {
    final estiloNombre = Theme.of(context).textTheme.titleMedium;
    final estiloEspecie =
        Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(nombre, style: estiloNombre),
            const SizedBox(width: 8),
            if (muestraIndicador)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
          ],
        ),
        Text(especie, style: estiloEspecie),
      ],
    );
  }
}
