import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../utils/colores_app.dart';
import '../utils/modelos_recomendaciones.dart';
import '../services/servicio_recomendaciones.dart';
import '../widgets/bloque_lecturas.dart';
import '../widgets/tarjeta_consejo.dart';

typedef ConditionFetcher = Future<PlantCondition> Function();

class PaginaRecomendations extends StatefulWidget {
  final String species;
  final ConditionFetcher? fetcher;
  final Duration pollInterval;

  const PaginaRecomendations({
    super.key,
    this.species = 'general',
    this.fetcher,
    this.pollInterval = const Duration(seconds: 10),
  });

  @override
  State<PaginaRecomendations> createState() => _PaginaRecomendationsState();
}

class _PaginaRecomendationsState extends State<PaginaRecomendations> {
  late PlantCondition _condition;
  List<Recommendation> _recs = const [];
  Timer? _timer;
  bool _loading = true;
  bool _busy = false; // evita superponer fetches

  @override
  void initState() {
    super.initState();
    // Estado inicial de respaldo (se actualizará en el primer fetch)
    _condition = PlantCondition(
      species: widget.species,
      soilMoisture: 50,
      temperature: 22,
      lightLux: 5000,
    );
    _startPolling();
  }

  void _startPolling() {
    _fetchAndUpdate();
    _timer?.cancel();
    _timer = Timer.periodic(widget.pollInterval, (_) => _fetchAndUpdate());
  }

  Future<void> _fetchAndUpdate() async {
    if (!mounted || _busy) return;
    _busy = true;
    setState(() => _loading = true);

    try {
      final fetcher = widget.fetcher ?? _mockFetcher(widget.species);
      final cond = await fetcher();
      if (!mounted) return;

      final recs = RecommendationService.computeRecommendations(cond);
      setState(() {
        _condition = cond;
        _recs = recs;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    } finally {
      _busy = false;
    }
  }

  // Simulador (reemplaza por tu fetch real de sensores)
  ConditionFetcher _mockFetcher(String species) {
    final rng = Random();
    return () async {
      await Future.delayed(const Duration(milliseconds: 300));
      return PlantCondition(
        species: species,
        soilMoisture: 20 + rng.nextDouble() * 60,
        temperature: 12 + rng.nextDouble() * 20,
        lightLux: 200 + rng.nextDouble() * 25000,
        timestamp: DateTime.now(),
      );
    };
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final profile = RecommendationService.profileFor(_condition.species);
    final humedadOk = _condition.soilMoisture >= profile.moistureRange.start &&
        _condition.soilMoisture <= profile.moistureRange.end;
    final tempOk = _condition.temperature >= profile.tempRange.start &&
        _condition.temperature <= profile.tempRange.end;
    final luzOk = _condition.lightLux >= profile.lightRange.start &&
        _condition.lightLux <= profile.lightRange.end;
    final todoOk = humedadOk && tempOk && luzOk;

    return Scaffold(
      backgroundColor: kFondoCrema,
      appBar: AppBar(
        title: const Text('Recomendaciones'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: kPrimario),
                ),
              ),
            )
          else
            IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchAndUpdate),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 6),
          const Text(
            'Basado en las lecturas actuales de tus sensores',
            style: TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 12),

          // Lecturas + timestamp
          BloqueLecturas(
            humedad: '${_condition.soilMoisture.toStringAsFixed(0)}%',
            temperatura: '${_condition.temperature.toStringAsFixed(1)}°C',
            luz: '${_condition.lightLux.toStringAsFixed(0)} lx',
            timestamp: _fmt(_condition.timestamp),
          ),

          const SizedBox(height: 18),

          const Text('Consejos Personalizados',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          // Consejos rápidos (semaforización)
          ..._consejosRapidos(humedadOk, tempOk, luzOk, todoOk),

          const SizedBox(height: 18),

          if (_recs.isNotEmpty) ...[
            const Text('Recomendaciones detalladas',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Column(
              children: _recs.map((r) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(r.subtitle),
                    trailing: Text(r.score.toStringAsFixed(1)),
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(r.title),
                        content: Text(r.details),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _fetchAndUpdate,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualizar Recomendaciones'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimario,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '💡 Las recomendaciones se actualizan cada vez que cambian las lecturas de los sensores. Puedes refrescar manualmente en cualquier momento.',
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  List<Widget> _consejosRapidos(bool humedadOk, bool tempOk, bool luzOk, bool todoOk) {
    final cards = <Widget>[
      TarjetaConsejo(
        icono: Icons.water_drop,
        titulo: humedadOk ? 'Humedad perfecta' : 'Humedad insuficiente',
        subtitulo: humedadOk
            ? 'La humedad es ideal (${_condition.soilMoisture.toStringAsFixed(0)}%). Mantén esta rutina.'
            : 'Humedad ${_condition.soilMoisture.toStringAsFixed(0)}%. Ajusta el riego.',
        bueno: humedadOk,
      ),
      TarjetaConsejo(
        icono: Icons.thermostat,
        titulo: tempOk ? 'Temperatura ideal' : 'Temperatura fuera de rango',
        subtitulo: tempOk
            ? '${_condition.temperature.toStringAsFixed(1)}°C es adecuada.'
            : 'Actual: ${_condition.temperature.toStringAsFixed(1)}°C. Protege o ventila según sea necesario.',
        bueno: tempOk,
      ),
      TarjetaConsejo(
        icono: Icons.wb_sunny,
        titulo: luzOk ? 'Iluminación óptima' : 'Ajustar iluminación',
        subtitulo: luzOk
            ? '${_condition.lightLux.toStringAsFixed(0)} lux favorece un crecimiento saludable.'
            : 'Iluminación: ${_condition.lightLux.toStringAsFixed(0)} lux. Mueve la planta o añade luz.',
        bueno: luzOk,
      ),
    ];

    if (todoOk) {
      cards.add(const TarjetaConsejo(
        icono: Icons.emoji_events,
        titulo: '¡Todo perfecto!',
        subtitulo: 'Todas las condiciones son ideales. Tu planta está feliz.',
        bueno: true,
      ));
    }

    return cards;
  }
}
