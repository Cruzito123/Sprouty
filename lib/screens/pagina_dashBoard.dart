// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../utils/colores_app.dart';
import '../utils/modelos.dart';
import '../widgets/dialogo_parametros.dart';
import '../widgets/tarjeta_planta.dart';

class PaginaDashboard extends StatefulWidget {
  const PaginaDashboard({super.key});

  @override
  State<PaginaDashboard> createState() => _PaginaDashboardState();
}

class _PaginaDashboardState extends State<PaginaDashboard> {
  // Lecturas actuales (simuladas)
  double tempActual = 15.6;
  double humedadActual = 35.5;
  double luzActual = 388;

  // Parámetros ideales (editables)
  ParametrosPlanta _param = ParametrosPlanta(
    minTemp: 18, maxTemp: 24,
    minHumedad: 50, maxHumedad: 70,
    minLuz: 300, maxLuz: 700,
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

  @override
  Widget build(BuildContext context) {
    final tempOk = tempActual >= _param.minTemp && tempActual <= _param.maxTemp;
    final humOk  = humedadActual >= _param.minHumedad && humedadActual <= _param.maxHumedad;
    final luzOk  = luzActual >= _param.minLuz && luzActual <= _param.maxLuz;
    final requiereAccion = !(tempOk && humOk && luzOk);

    return Scaffold(
      backgroundColor: kFondoCrema,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Panel Principal', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('1 planta activa',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600)),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Tus Plantas', style: Theme.of(context).textTheme.titleLarge),
            FilledButton.tonalIcon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Agregar'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          TarjetaPlanta(
            nombre: 'ksdfkdsfsf',
            especie: 'Ficus Elastica',
            tempOk: tempOk,
            humedadOk: humOk,
            luzOk: luzOk,
            requiereAccion: requiereAccion,
            // ignore: unnecessary_brace_in_string_interps
            tempTexto: '${tempActual}°C',
            // ignore: unnecessary_brace_in_string_interps
            humedadTexto: '${humedadActual}%',
            // ignore: unnecessary_brace_in_string_interps
            luzTexto: '${luzActual} lux',
            onEditarParametros: _abrirDialogoParametros,
            onVerRecomendaciones: () {
              // TODO: Navegar a recomendaciones si lo deseas
              // Navigator.pushNamed(context, '/recomendaciones');
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.orangeAccent, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Los datos se actualizan automáticamente cada 3 segundos. Modifica los parámetros ideales para cada planta según sus necesidades específicas.',
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
