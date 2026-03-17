import 'package:flutter/material.dart';

/// Define una recomendación individual (ej. "Regar ahora")
class Recommendation {
  final String title;
  final String subtitle;
  final String details;
  final double score; // 5.0 es urgente, 1.0 es informativo

  const Recommendation({
    required this.title,
    required this.subtitle,
    required this.details,
    required this.score,
  });
}

/// Representa el estado actual de la planta basado en sensores
class PlantCondition {
  final String species;
  final double soilMoisture;
  final double temperature;
  final double lightLux;
  final DateTime timestamp;

  PlantCondition({
    required this.species,
    required this.soilMoisture,
    required this.temperature,
    required this.lightLux,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Método útil para actualizar valores sin perder los demás (inmutable)
  PlantCondition copyWith({
    String? species,
    double? soilMoisture,
    double? temperature,
    double? lightLux,
    DateTime? timestamp,
  }) {
    return PlantCondition(
      species: species ?? this.species,
      soilMoisture: soilMoisture ?? this.soilMoisture,
      temperature: temperature ?? this.temperature,
      lightLux: lightLux ?? this.lightLux,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// Define los rangos ideales para una especie de planta
class SpeciesProfile {
  final RangeValues moistureRange; // Ej: 40.0 - 70.0 %
  final RangeValues tempRange; // Ej: 18.0 - 28.0 °C
  final RangeValues lightRange; // Ej: 1000 - 5000 Lux

  const SpeciesProfile({
    required this.moistureRange,
    required this.tempRange,
    required this.lightRange,
  });
}
