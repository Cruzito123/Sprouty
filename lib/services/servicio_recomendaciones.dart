import 'package:flutter/material.dart';
import '../utils/modelos_recomendaciones.dart';

class RecommendationService {
  static const Map<String, SpeciesProfile> _profiles = {
    'suculenta': SpeciesProfile(
      moistureRange: RangeValues(5, 20),
      tempRange: RangeValues(15, 30),
      lightRange: RangeValues(1000, 30000),
    ),
    'tomate': SpeciesProfile(
      moistureRange: RangeValues(40, 70),
      tempRange: RangeValues(18, 30),
      lightRange: RangeValues(2000, 20000),
    ),
    'general': SpeciesProfile(
      moistureRange: RangeValues(30, 60),
      tempRange: RangeValues(15, 28),
      lightRange: RangeValues(500, 20000),
    ),
  };

  static SpeciesProfile profileFor(String species) {
    final key = species.toLowerCase();
    return _profiles[key] ?? _profiles['general']!;
  }

  static List<Recommendation> computeRecommendations(PlantCondition c) {
    final profile = profileFor(c.species);
    final recs = <Recommendation>[];

    // Humedad
    if (c.soilMoisture < profile.moistureRange.start) {
      final deficit = profile.moistureRange.start - c.soilMoisture;
      recs.add(Recommendation(
        title: 'Regar ahora',
        subtitle: 'Humedad baja (${c.soilMoisture.toStringAsFixed(0)}%)',
        details:
            'La humedad está ${deficit.toStringAsFixed(0)} pts por debajo del mínimo para ${c.species}. Riega moderadamente.',
        score: 5.0,
      ));
    } else if (c.soilMoisture > profile.moistureRange.end) {
      recs.add(const Recommendation(
        title: 'Evitar riego',
        subtitle: 'Humedad alta',
        details: 'Evita regar y revisa drenaje para prevenir pudrición de raíces.',
        score: 4.0,
      ));
    } else {
      recs.add(Recommendation(
        title: 'Humedad adecuada',
        subtitle: '${c.soilMoisture.toStringAsFixed(0)}% — dentro del rango',
        details: 'Mantén la rutina de riego actual.',
        score: 2.5,
      ));
    }

    // Temperatura
    if (c.temperature < profile.tempRange.start) {
      recs.add(Recommendation(
        title: 'Proteger del frío',
        subtitle: 'Temperatura baja (${c.temperature.toStringAsFixed(1)}°C)',
        details: 'Mover a lugar más cálido o cubrir durante la noche.',
        score: 4.0,
      ));
    } else if (c.temperature > profile.tempRange.end) {
      recs.add(Recommendation(
        title: 'Reducir estrés térmico',
        subtitle: 'Temperatura alta (${c.temperature.toStringAsFixed(1)}°C)',
        details: 'Proporciona sombra parcial y aumenta ventilación.',
        score: 4.0,
      ));
    }

    // Luz
    if (c.lightLux < profile.lightRange.start) {
      recs.add(Recommendation(
        title: 'Aumentar luz',
        subtitle: 'Poca iluminación (${c.lightLux.toStringAsFixed(0)} lux)',
        details: 'Traslada a un lugar más iluminado o añade luz artificial.',
        score: 3.5,
      ));
    } else if (c.lightLux > profile.lightRange.end) {
      recs.add(Recommendation(
        title: 'Proteger del exceso de luz',
        subtitle: 'Iluminación alta (${c.lightLux.toStringAsFixed(0)} lux)',
        details: 'Proporciona sombra parcial para evitar quemaduras en hojas.',
        score: 3.5,
      ));
    }

    recs.sort((a, b) => b.score.compareTo(a.score));
    return recs;
  }
}
