import 'package:flutter/material.dart';

class Recommendation {
  final String title;
  final String subtitle;
  final String details;
  final double score;

  const Recommendation({
    required this.title,
    required this.subtitle,
    required this.details,
    required this.score,
  });
}

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

class SpeciesProfile {
  final RangeValues moistureRange;
  final RangeValues tempRange;
  final RangeValues lightRange;

  const SpeciesProfile({
    required this.moistureRange,
    required this.tempRange,
    required this.lightRange,
  });
}
