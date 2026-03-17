import 'package:flutter/material.dart';
import '../utils/modelos_recomendaciones.dart';
import '../services/servicio_recomendaciones.dart';

class DialogoSaludPlanta extends StatelessWidget {
  final double humedad;
  final double temperatura;
  final double luz;

  const DialogoSaludPlanta({
    super.key,
    required this.humedad,
    required this.temperatura,
    required this.luz,
  });

  @override
  Widget build(BuildContext context) {
    final condicion = PlantCondition(
      species: 'Monstera',
      soilMoisture: humedad,
      temperature: temperatura,
      lightLux: luz,
    );
    final lista = RecommendationService.computeRecommendations(condicion);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Diagnóstico de Salud",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (lista.isEmpty)
            ListTile(
              leading: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
              title: const Text("¡Todo excelente!"),
              subtitle: const Text("Tu planta está en condiciones ideales."),
            )
          else
            ...lista.map((rec) => ListTile(
                  leading: Icon(Icons.warning_amber_rounded,
                      color: Theme.of(context).colorScheme.error),
                  title: Text(rec.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(rec.details),
                )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
