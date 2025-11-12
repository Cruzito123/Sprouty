// ignore_for_file: file_names, unnecessary_brace_in_string_interps
import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/colores_app.dart';
import '../utils/modelos.dart';
import '../widgets/dialogo_parametros.dart';
import '../widgets/tarjeta_planta.dart';
import '../services/api.dart'; // <-- NUEVO

class PaginaDashboard extends StatefulWidget {
  const PaginaDashboard({super.key});

  @override
  State<PaginaDashboard> createState() => _PaginaDashboardState();
}

class _PaginaDashboardState extends State<PaginaDashboard> {
  // Id de la maceta a mostrar
  final int macetaId = 1;

  // Lecturas actuales (inicialmente nulas)
  double? tempActual;
  double? humedadActual;
  double? luzActual;
  DateTime? _ultimaActualizacion;

  bool _cargando = true;
  String? _error;
  Timer? _timer;

  // Parámetros ideales (editables)
  ParametrosPlanta _param = ParametrosPlanta(
    minTemp: 18,
    maxTemp: 24,
    minHumedad: 50,
    maxHumedad: 70,
    minLuz: 300,
    maxLuz: 700,
  );

  void _abrirDialogoParametros() {
    showDialog(
      context: context,
      builder: (_) => DialogoParametros(
        parametros: _param.copia(),
        onGuardar: (nuevo) => setState(() => _param = nuevo),
      ),
    );
  }

  Future<void> _cargar() async {
    try {
      setState(() {
        _cargando = tempActual == null;
        _error = null;
      });

      // Usa UNO de los dos métodos:
      final lec = await Api.getUltimaLectura(macetaId);
      // final lec = await Api.getUltimaDesdeLista(macetaId);

      if (lec == null) {
        setState(() {
          _error = 'Sin lecturas aún para la maceta $macetaId.';
        });
        return;
      }

      setState(() {
        tempActual = lec.temperatura;
        humedadActual = lec.humedad;
        luzActual = lec.luz;
        _ultimaActualizacion = lec.fecha;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar: $e';
      });
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cargar();
    // refresco automático cada 5 s
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _cargar());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final temp = tempActual ?? 0;
    final hum = humedadActual ?? 0;
    final luz = luzActual ?? 0;

    final tempOk =
        tempActual != null && temp >= _param.minTemp && temp <= _param.maxTemp;
    final humOk = humedadActual != null &&
        hum >= _param.minHumedad &&
        hum <= _param.maxHumedad;
    // Si “luz” la dejaste opcional, solo evalúa si no es null
    final luzOk = luzActual == null
        ? true
        : (luz >= _param.minLuz && luz <= _param.maxLuz);

    final requiereAccion = !(tempOk && humOk && luzOk);

    return Scaffold(
      backgroundColor: kFondoCrema,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Panel Principal',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('1 planta activa',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.grey.shade600)),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Tus Plantas', style: Theme.of(context).textTheme.titleLarge),
            FilledButton.tonalIcon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Agregar'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          if (_cargando && tempActual == null)
            const Center(
                child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ))
          else if (_error != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12)),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          else
            TarjetaPlanta(
              nombre: 'Árbol del caucho',
              especie: 'Ficus Elastica',
              tempOk: tempOk,
              humedadOk: humOk,
              luzOk: luzOk,
              requiereAccion: requiereAccion,
              tempTexto: tempActual == null
                  ? '--'
                  : '${tempActual!.toStringAsFixed(1)}°C',
              humedadTexto: humedadActual == null
                  ? '--'
                  : '${humedadActual!.toStringAsFixed(1)}%',
              luzTexto: luzActual == null
                  ? '—'
                  : '${luzActual!.toStringAsFixed(0)} lux',
              onEditarParametros: _abrirDialogoParametros,
              onVerRecomendaciones: () {
                Navigator.pushNamed(context, '/recomendaciones');
              },
            ),
          const SizedBox(height: 12),
          if (_ultimaActualizacion != null)
            Text('Actualizado: ${_ultimaActualizacion!.toLocal()}',
                style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline,
                    color: Colors.orangeAccent, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Los datos se actualizan automáticamente cada 5 segundos. '
                    'Modifica los parámetros ideales para cada planta según sus necesidades.',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
