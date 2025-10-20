import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class BloqueLecturas extends StatelessWidget {
  final String humedad;
  final String temperatura;
  final String luz;
  final String timestamp;

  const BloqueLecturas({
    super.key,
    required this.humedad,
    required this.temperatura,
    required this.luz,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _readingColumn(Icons.water_drop_outlined, 'Humedad', humedad),
                _readingColumn(Icons.thermostat, 'Temperatura', temperatura),
                _readingColumn(Icons.wb_sunny_outlined, 'Luz', luz),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Última lectura: $timestamp',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _readingColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: kPrimario),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
