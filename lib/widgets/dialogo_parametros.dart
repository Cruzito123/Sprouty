import 'package:flutter/material.dart';
import '../utils/colores_app.dart';
import '../utils/modelos.dart';

class DialogoParametros extends StatefulWidget {
  final ParametrosPlanta parametros;
  final ValueChanged<ParametrosPlanta> onGuardar;

  const DialogoParametros({
    super.key,
    required this.parametros,
    required this.onGuardar,
  });

  @override
  State<DialogoParametros> createState() => _DialogoParametrosState();
}

class _DialogoParametrosState extends State<DialogoParametros> {
  late final TextEditingController _minT;
  late final TextEditingController _maxT;
  late final TextEditingController _minH;
  late final TextEditingController _maxH;
  late final TextEditingController _minL;
  late final TextEditingController _maxL;

  @override
  void initState() {
    super.initState();
    final p = widget.parametros;
    _minT = TextEditingController(text: p.minTemp.toString());
    _maxT = TextEditingController(text: p.maxTemp.toString());
    _minH = TextEditingController(text: p.minHumedad.toString());
    _maxH = TextEditingController(text: p.maxHumedad.toString());
    _minL = TextEditingController(text: p.minLuz.toString());
    _maxL = TextEditingController(text: p.maxLuz.toString());
  }

  @override
  void dispose() {
    _minT.dispose(); _maxT.dispose();
    _minH.dispose(); _maxH.dispose();
    _minL.dispose(); _maxL.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFF5F5F0),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Modificar Parámetros',
                    style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ]),
              const SizedBox(height: 16),
              _seccion(
                icono: Icons.thermostat, titulo: 'Temperatura Ideal',
                minLabel: 'Mínima (°C)', maxLabel: 'Máxima (°C)',
                minCtrl: _minT, maxCtrl: _maxT,
              ),
              const SizedBox(height: 16),
              _seccion(
                icono: Icons.water_drop_outlined, titulo: 'Humedad Ideal',
                minLabel: 'Mínima (%)', maxLabel: 'Máxima (%)',
                minCtrl: _minH, maxCtrl: _maxH,
              ),
              const SizedBox(height: 16),
              _seccion(
                icono: Icons.wb_sunny_outlined, titulo: 'Luz Requerida',
                minLabel: 'Mínima (lux)', maxLabel: 'Máxima (lux)',
                minCtrl: _minL, maxCtrl: _maxL,
              ),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final p = ParametrosPlanta(
                        minTemp: double.tryParse(_minT.text) ?? 0,
                        maxTemp: double.tryParse(_maxT.text) ?? 0,
                        minHumedad: double.tryParse(_minH.text) ?? 0,
                        maxHumedad: double.tryParse(_maxH.text) ?? 0,
                        minLuz: double.tryParse(_minL.text) ?? 0,
                        maxLuz: double.tryParse(_maxL.text) ?? 0,
                      );
                      widget.onGuardar(p);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimario,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    child: const Text('Guardar Cambios'),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seccion({
    required IconData icono,
    required String titulo,
    required String minLabel,
    required String maxLabel,
    required TextEditingController minCtrl,
    required TextEditingController maxCtrl,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icono, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Text(titulo, style: Theme.of(context).textTheme.titleMedium),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _campo(minLabel, minCtrl)),
        const SizedBox(width: 16),
        Expanded(child: _campo(maxLabel, maxCtrl)),
      ]),
    ]);
  }

  Widget _campo(String etiqueta, TextEditingController ctrl) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(etiqueta, style: const TextStyle(color: Colors.black54, fontSize: 13)),
      const SizedBox(height: 4),
      TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true, fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kDivisor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kDivisor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kPrimario),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    ]);
  }
}
