import 'dart:async';
import 'package:flutter/material.dart';

import '../utils/colores_app.dart';
import '../widgets/bloque_lecturas.dart';
import '../widgets/tarjeta_consejo.dart';
import '../services/api.dart';

// Tolerancias para construir rangos a partir de los objetivos
const double kHumTolPct = 10;   // ±10%
const double kLuzTolPct = 30;   // ±30%
const double kTempTolC  = 2.0;  // ±2°C

class PaginaRecomendations extends StatefulWidget {
  final String species;

  const PaginaRecomendations({
    super.key,
    this.species = 'general',
  });

  @override
  State<PaginaRecomendations> createState() => _PaginaRecomendationsState();
}

class _PaginaRecomendationsState extends State<PaginaRecomendations> {
  // Id de maceta objetivo (ajústalo si pasas el id por argumentos)
  final int _macetaId = 1;

  double? _humedad;
  double? _temperatura;
  double? _luz;
  DateTime? _timestamp;
  ConfigMaceta? _cfg;

  bool _loading = true;
  String? _error;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    _fetchAndUpdate();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _fetchAndUpdate());
  }

  Future<void> _fetchAndUpdate() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 1) Última lectura
      final lec = await Api.getUltimaLectura(_macetaId);
      if (lec == null) {
        setState(() {
          _error = 'Sin lecturas para la maceta $_macetaId.';
        });
        return;
      }

      // 2) Configuración de maceta (última)
      final cfg = await Api.getConfigMaceta(_macetaId);
      if (cfg == null) {
        setState(() {
          _error = 'No hay configuración para la maceta $_macetaId.';
        });
        return;
      }

      setState(() {
        _humedad = lec.humedad;
        _temperatura = lec.temperatura;
        _luz = lec.luz;
        _timestamp = lec.fecha;
        _cfg = cfg;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar recomendaciones: $e';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';

  // Construye rangos a partir de objetivos y tolerancias
  ({double min, double max}) _rangoPct(double objetivo, double tolPct, {double? floor, double? ceil}) {
    final min = (objetivo * (1 - tolPct / 100)).clamp(floor ?? double.negativeInfinity, ceil ?? double.infinity);
    final max = (objetivo * (1 + tolPct / 100)).clamp(floor ?? double.negativeInfinity, ceil ?? double.infinity);
    return (min: min, max: max);
  }

  ({double min, double max}) _rangoTemp(double objetivo, double delta) {
    return (min: objetivo - delta, max: objetivo + delta);
  }

  @override
  Widget build(BuildContext context) {
    final fondo = kFondoCrema;

    final hasData = _humedad != null && _temperatura != null && _cfg != null;
    // Rango ideal desde configuración
    final humR = _cfg == null ? (min: 0.0, max: 0.0) : _rangoPct(_cfg!.humedadObjetivo, kHumTolPct, floor: 0, ceil: 100);
    final luzR = (_cfg?.luzObjetivo == null)
        ? (min: 0.0, max: double.infinity)
        : _rangoPct(_cfg!.luzObjetivo!, kLuzTolPct, floor: 0);
    final tempR = _cfg == null ? (min: 0.0, max: 0.0) : _rangoTemp(_cfg!.temperaturaObjetivo, kTempTolC);

    final humedadOk = hasData ? (_humedad! >= humR.min && _humedad! <= humR.max) : false;
    final tempOk = hasData ? (_temperatura! >= tempR.min && _temperatura! <= tempR.max) : false;
    final luzOk = (_luz == null || _cfg?.luzObjetivo == null)
        ? true
        : (_luz! >= luzR.min && _luz! <= luzR.max);
    final todoOk = humedadOk && tempOk && luzOk;

    return Scaffold(
      backgroundColor: fondo,
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
          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 12),
          ],

          const SizedBox(height: 6),
          const Text('Basado en lecturas recientes de tus sensores', style: TextStyle(color: Colors.black87)),
          const SizedBox(height: 12),

          BloqueLecturas(
            humedad: _humedad == null ? '—' : '${_humedad!.toStringAsFixed(0)}%',
            temperatura: _temperatura == null ? '—' : '${_temperatura!.toStringAsFixed(1)}°C',
            luz: _luz == null ? '—' : '${_luz!.toStringAsFixed(0)} lx',
            timestamp: _timestamp == null ? '—' : _fmt(_timestamp!),
          ),

          const SizedBox(height: 18),

          const Text('Consejos Personalizados', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          ..._consejosRapidos(humedadOk, tempOk, luzOk, todoOk, humR, tempR, luzR),

          const SizedBox(height: 18),

          // Recomendaciones detalladas basadas en desvíos respecto a los rangos de configuración
          ..._detalladas(humedadOk, tempOk, luzOk, humR, tempR, luzR),

          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  List<Widget> _consejosRapidos(
    bool humedadOk,
    bool tempOk,
    bool luzOk,
    bool todoOk,
    ({double min, double max}) humR,
    ({double min, double max}) tempR,
    ({double min, double max}) luzR,
  ) {
    final cards = <Widget>[
      TarjetaConsejo(
        icono: Icons.water_drop,
        titulo: humedadOk ? 'Humedad perfecta' : 'Humedad fuera de rango',
        subtitulo: _humedad == null
            ? '—'
            : humedadOk
                ? 'Ideal (${_humedad!.toStringAsFixed(0)}%). Objetivo ${humR.min.toStringAsFixed(0)}–${humR.max.toStringAsFixed(0)}%.'
                : 'Actual: ${_humedad!.toStringAsFixed(0)}%. Rango ideal: ${humR.min.toStringAsFixed(0)}–${humR.max.toStringAsFixed(0)}%.',
        bueno: humedadOk,
      ),
      TarjetaConsejo(
        icono: Icons.thermostat,
        titulo: tempOk ? 'Temperatura ideal' : 'Temperatura fuera de rango',
        subtitulo: _temperatura == null
            ? '—'
            : tempOk
                ? '${_temperatura!.toStringAsFixed(1)}°C dentro de ${tempR.min.toStringAsFixed(1)}–${tempR.max.toStringAsFixed(1)}°C.'
                : 'Actual: ${_temperatura!.toStringAsFixed(1)}°C. Ideal: ${tempR.min.toStringAsFixed(1)}–${tempR.max.toStringAsFixed(1)}°C.',
        bueno: tempOk,
      ),
      TarjetaConsejo(
        icono: Icons.wb_sunny,
        titulo: luzOk ? 'Iluminación óptima' : 'Ajustar iluminación',
        subtitulo: (_luz == null || _cfg?.luzObjetivo == null)
            ? 'Sin objetivo de luz configurado.'
            : luzOk
                ? '${_luz!.toStringAsFixed(0)} lux dentro de ${luzR.min.toStringAsFixed(0)}–${luzR.max.toStringAsFixed(0)}.'
                : 'Actual: ${_luz!.toStringAsFixed(0)} lux. Ideal: ${luzR.min.toStringAsFixed(0)}–${luzR.max.toStringAsFixed(0)}.',
        bueno: luzOk,
      ),
    ];

    if (todoOk) {
      cards.add(const TarjetaConsejo(
        icono: Icons.emoji_events,
        titulo: '¡Todo perfecto!',
        subtitulo: 'Todas las condiciones están dentro de lo ideal.',
        bueno: true,
      ));
    }

    return cards;
  }

  List<Widget> _detalladas(
    bool humedadOk,
    bool tempOk,
    bool luzOk,
    ({double min, double max}) humR,
    ({double min, double max}) tempR,
    ({double min, double max}) luzR,
  ) {
    final widgets = <Widget>[];

    if (_humedad != null && !humedadOk) {
      if (_humedad! < humR.min) {
        widgets.add(_detalle('Regar ahora', 'Humedad baja (${_humedad!.toStringAsFixed(0)}%). Aumenta riego moderadamente.'));
      } else {
        widgets.add(_detalle('Evitar riego', 'Humedad alta (${_humedad!.toStringAsFixed(0)}%). Permite secar el sustrato.'));
      }
    }

    if (_temperatura != null && !tempOk) {
      if (_temperatura! < tempR.min) {
        widgets.add(_detalle('Proteger del frío', 'Temperatura baja (${_temperatura!.toStringAsFixed(1)}°C). Reubica a un sitio más cálido.'));
      } else {
        widgets.add(_detalle('Reducir calor', 'Temperatura alta (${_temperatura!.toStringAsFixed(1)}°C). Ventila o proporciona sombra.'));
      }
    }

    if (_luz != null && _cfg?.luzObjetivo != null && !luzOk) {
      if (_luz! < luzR.min) {
        widgets.add(_detalle('Aumentar luz', 'Iluminación insuficiente (${_luz!.toStringAsFixed(0)} lux). Acerca a una ventana o usa luz artificial.'));
      } else {
        widgets.add(_detalle('Disminuir luz', 'Exceso de luz (${_luz!.toStringAsFixed(0)} lux). Mueve a luz indirecta o sombrea.'));
      }
    }

    return widgets;
  }

  Widget _detalle(String titulo, String subtitulo) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.info_outline),
      ),
    );
  }
}
