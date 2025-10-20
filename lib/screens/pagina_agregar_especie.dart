import 'package:flutter/material.dart';

class PaginaAgregarEspecie extends StatefulWidget {
  final String nombrePlanta; // 👈 Recibe el nombre de la planta seleccionada

  const PaginaAgregarEspecie({super.key, required this.nombrePlanta});

  @override
  State<PaginaAgregarEspecie> createState() => _PaginaAgregarEspecieState();
}

class _PaginaAgregarEspecieState extends State<PaginaAgregarEspecie> {
  final _formKey = GlobalKey<FormState>();

  // Valores de sliders
  double _humedad = 50;
  RangeValues _temp = const RangeValues(18, 24);
  RangeValues _luz = const RangeValues(300, 600);

  static const Color kGreen = Color(0xFF62AE6C);
  static const Color kBeige = Color(0xFFF3EFE6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBeige,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        title: Text('Configurar ${widget.nombrePlanta}'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              // Encabezado visual
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.settings_input_component_rounded,
                        color: kGreen, size: 50),
                    const SizedBox(height: 6),
                    Text(
                      widget.nombrePlanta,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ajusta los valores ideales para el monitoreo',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // HUMEDAD
              _buildLabelRow('Humedad Ideal (%)', '${_humedad.toInt()}%'),
              _sliderContainer(
                Slider(
                  value: _humedad,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  activeColor: kGreen,
                  onChanged: (v) => setState(() => _humedad = v),
                ),
              ),
              _minMaxLabels('0%', '100%'),
              const SizedBox(height: 20),

              // TEMPERATURA
              _buildLabelRow('Temperatura (°C)',
                  '${_temp.start.toInt()}°C - ${_temp.end.toInt()}°C'),
              _sliderContainer(
                RangeSlider(
                  values: _temp,
                  min: 10,
                  max: 35,
                  divisions: 25,
                  activeColor: kGreen,
                  onChanged: (v) => setState(() => _temp = v),
                ),
              ),
              _minMaxLabels('10°C', '35°C'),
              const SizedBox(height: 20),

              // LUZ
              _buildLabelRow('Rango de Luz (lux)',
                  '${_luz.start.toInt()} - ${_luz.end.toInt()} lux'),
              _sliderContainer(
                RangeSlider(
                  values: _luz,
                  min: 100,
                  max: 1000,
                  divisions: 18,
                  activeColor: kGreen,
                  onChanged: (v) => setState(() => _luz = v),
                ),
              ),
              _minMaxLabels('100 lux', '1000 lux'),
              const SizedBox(height: 24),

              // Info box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F5EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline,
                        color: Colors.amber, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Estos valores se usarán para monitorear las condiciones de tu ${widget.nombrePlanta}.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // BOTÓN GUARDAR
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: kGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, {
                      'planta': widget.nombrePlanta,
                      'humedad': _humedad,
                      'tempMin': _temp.start,
                      'tempMax': _temp.end,
                      'luzMin': _luz.start,
                      'luzMax': _luz.end,
                    });
                  },
                  child: const Text(
                    'Guardar Especie',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Helpers de UI ----------
  Widget _buildLabelRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        Text(value,
            style: const TextStyle(
                color: Colors.brown, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _sliderContainer(Widget slider) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF2EBE0),
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: slider,
      );

  Widget _minMaxLabels(String min, String max) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(min, style: const TextStyle(color: Colors.brown)),
          Text(max, style: const TextStyle(color: Colors.brown)),
        ],
      ),
    );
  }
}
