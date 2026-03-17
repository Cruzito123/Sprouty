import 'dart:async';
import 'package:flutter/material.dart';

// Utils
import '../utils/colores_app.dart';
import '../utils/modelos.dart';
import '../utils/modelos_recomendaciones.dart';

// Widgets
import '../widgets/dialogo_parametros.dart';
import '../widgets/dialogo_salud_planta.dart';
import '../widgets/tarjeta_planta.dart';

// Services
import '../services/api.dart';
import '../services/servicio_recomendaciones.dart';
import '../services/servicio_notificaciones.dart'; // <--- IMPORTANTE

class PaginaDashboard extends StatefulWidget {
  const PaginaDashboard({super.key});

  @override
  State<PaginaDashboard> createState() => _PaginaDashboardState();
}

class _PaginaDashboardState extends State<PaginaDashboard> {
  final int macetaId = 1;

  double? tempActual;
  double? humedadActual;
  double? luzActual;
  DateTime? _ultimaActualizacion;

  Recommendation? _alertaPrincipal;
  DateTime? _ultimaNotificacionEnviada; // Para no spammear notificaciones

  bool _cargando = true;
  String? _error;
  Timer? _timer;

  ParametrosPlanta _param = ParametrosPlanta(
    minTemp: 18,
    maxTemp: 24,
    minHumedad: 50,
    maxHumedad: 70,
    minLuz: 300,
    maxLuz: 700,
  );

  @override
  void initState() {
    super.initState();
    _cargar();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _cargar());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _cargar() async {
    try {
      if (tempActual == null) setState(() => _cargando = true);

      // 1. Obtener datos
      final lec = await Api.getUltimaLectura(macetaId);

      if (lec == null) {
        if (mounted)
          setState(() {
            _error = 'Sin datos';
            _cargando = false;
          });
        return;
      }

      // 2. Analizar salud de la planta
      final condicion = PlantCondition(
        species: 'Monstera',
        soilMoisture: lec.humedad,
        temperature: lec.temperatura,
        lightLux: lec.luz ?? 0.0,
      );

      final recomendaciones =
          RecommendationService.computeRecommendations(condicion);
      final topRec = recomendaciones.isNotEmpty ? recomendaciones.first : null;

      // 3. ENVIAR NOTIFICACIÓN (Si es urgente y no hemos notificado en 1 minuto)
      if (topRec != null && topRec.score >= 4.0) {
        _enviarNotificacionSiEsNecesario(topRec);
      }

      if (mounted) {
        setState(() {
          tempActual = lec.temperatura;
          humedadActual = lec.humedad;
          luzActual = lec.luz;
          _ultimaActualizacion = lec.fecha;
          _alertaPrincipal = topRec; // Actualiza el banner amarillo
          _cargando = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted)
        setState(() {
          _error = 'Conectando...';
          _cargando = false;
        });
      print("Error Dashboard: $e");
    }
  }

  void _enviarNotificacionSiEsNecesario(Recommendation rec) {
    final ahora = DateTime.now();
    // Si nunca enviamos o pasaron más de 60 segundos desde la última
    if (_ultimaNotificacionEnviada == null ||
        ahora.difference(_ultimaNotificacionEnviada!).inSeconds > 60) {
      ServicioNotificaciones().mostrarNotificacion(
          id: 1, titulo: "⚠️ ${rec.title}", cuerpo: rec.details);
      _ultimaNotificacionEnviada = ahora;
    }
  }

  void _abrirDialogoParametros() {
    showDialog(
      context: context,
      builder: (_) => DialogoParametros(
        parametros: _param.copia(),
        onGuardar: (nuevo) => setState(() => _param = nuevo),
      ),
    );
  }

  void _verDetallesRecomendaciones() {
    if (tempActual == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DialogoSaludPlanta(
        humedad: humedadActual!,
        temperatura: tempActual!,
        luz: luzActual ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Semáforos visuales
    final tempOk = tempActual != null &&
        tempActual! >= _param.minTemp &&
        tempActual! <= _param.maxTemp;
    final humOk = humedadActual != null &&
        humedadActual! >= _param.minHumedad &&
        humedadActual! <= _param.maxHumedad;
    final luzOk = luzActual == null
        ? true
        : (luzActual! >= _param.minLuz && luzActual! <= _param.maxLuz);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Panel Principal',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('1 planta activa',
                style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 16)),
            const SizedBox(height: 30),

            // Título sin botón agregar
            Text('Tus Plantas',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color)),
            const SizedBox(height: 16),

            if (_cargando && tempActual == null)
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(32),
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
              ))
            else if (_error != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(_error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error)),
              )
            else
              TarjetaPlanta(
                nombre: 'Betunia',
                especie: 'Monstera',
                tempTexto: tempActual == null
                    ? '--'
                    : '${tempActual!.toStringAsFixed(1)}°C',
                humedadTexto: humedadActual == null
                    ? '--'
                    : '${humedadActual!.toStringAsFixed(1)}%',
                luzTexto: luzActual == null
                    ? '—'
                    : '${luzActual!.toStringAsFixed(0)} lux',

                tempOk: tempOk,
                humedadOk: humOk,
                luzOk: luzOk,

                // Pasamos el título de la recomendación al banner amarillo
                mensajeAlerta: _alertaPrincipal?.title,

                onEditarParametros: _abrirDialogoParametros,
                onVerRecomendaciones: _verDetallesRecomendaciones,
              ),

            const SizedBox(height: 12),
            if (_ultimaActualizacion != null)
              Center(
                  child: Text(
                      'Actualizado: ${_ultimaActualizacion!.toLocal().toString().substring(0, 19)}',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 12))),

            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                        'Los datos se actualizan automáticamente cada 5 segundos.',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
