import 'package:flutter/material.dart';
import '../utils/modelos_recomendaciones.dart';

class RecommendationService {
  // Base de datos de perfiles de plantas
  static const Map<String, SpeciesProfile> _profiles = {
    'ficus elastica': SpeciesProfile(
      moistureRange: RangeValues(40, 70), // Humedad ideal: 40-70%
      tempRange: RangeValues(18, 28), // Temp ideal: 18-28°C
      lightRange: RangeValues(1000, 5000), // Luz ideal
    ),
    'suculenta': SpeciesProfile(
      moistureRange: RangeValues(5, 20),
      tempRange: RangeValues(15, 30),
      lightRange: RangeValues(2000, 30000),
    ),
    'general': SpeciesProfile(
      moistureRange: RangeValues(30, 60),
      tempRange: RangeValues(15, 28),
      lightRange: RangeValues(500, 20000),
    ),
  };

  // Obtener perfil (si no existe la especie, usa general)
  static SpeciesProfile profileFor(String species) {
    final key = species.toLowerCase();
    return _profiles[key] ?? _profiles['general']!;
  }

  // Lógica principal: Compara sensores vs perfil
  static List<Recommendation> computeRecommendations(PlantCondition c) {
    final profile = profileFor(c.species);
    final recs = <Recommendation>[];

    // 1. ANÁLISIS DE HUMEDAD
    if (c.soilMoisture < profile.moistureRange.start) {
      final deficit = profile.moistureRange.start - c.soilMoisture;
      recs.add(Recommendation(
        title: 'Regar ahora',
        subtitle: 'Humedad crítica (${c.soilMoisture.toStringAsFixed(0)}%)',
        details: 'La humedad está muy baja. Riega inmediatamente.',
        score: 5.0, // Urgencia máxima
      ));
    } else if (c.soilMoisture > profile.moistureRange.end) {
      recs.add(const Recommendation(
        title: 'Exceso de agua',
        subtitle: 'Suelo encharcado',
        details: 'Suspende el riego y revisa el drenaje para evitar hongos.',
        score: 4.0,
      ));
    }

    // 2. ANÁLISIS DE TEMPERATURA
    if (c.temperature < profile.tempRange.start) {
      recs.add(Recommendation(
        title: 'Hace mucho frío',
        subtitle: 'Temp. baja (${c.temperature.toStringAsFixed(1)}°C)',
        details: 'Tu planta tiene frío. Muévela a un lugar más cálido.',
        score: 4.0,
      ));
    } else if (c.temperature > profile.tempRange.end) {
      recs.add(Recommendation(
        title: 'Calor extremo',
        subtitle: 'Temp. alta (${c.temperature.toStringAsFixed(1)}°C)',
        details: 'La planta se está sofocando. Busca un lugar más fresco.',
        score: 4.0,
      ));
    }

    // 3. ANÁLISIS DE LUZ (Si el sensor envía datos > 0)
    if (c.lightLux > 0) {
      if (c.lightLux < profile.lightRange.start) {
        recs.add(Recommendation(
          title: 'Falta luz',
          subtitle: 'Muy oscuro (${c.lightLux.toStringAsFixed(0)} lux)',
          details: 'Acerca la planta a una ventana o usa luz artificial.',
          score: 3.0,
        ));
      }
    }

    // Ordenar: Las más urgentes (score alto) primero
    recs.sort((a, b) => b.score.compareTo(a.score));

    return recs;
  }
}
