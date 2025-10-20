// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../utils/colores_app.dart';
import '../widgets/encabezado_verde.dart';
import '../utils/especie.dart';

class PaginaNombrar extends StatefulWidget {
  /// Especie seleccionada en el catálogo
  final Especie especie;

  /// Ruta del asset de imagen (opcional) para mostrar la planta
  final String? assetPath;

  const PaginaNombrar({
    super.key,
    required this.especie,
    this.assetPath,
  });

  @override
  State<PaginaNombrar> createState() => _PaginaNombrarState();
}

class _PaginaNombrarState extends State<PaginaNombrar> {
  final TextEditingController _nombreCtrl =
      TextEditingController(text: 'Maceta del Jardín');
  final TextEditingController _descripcionCtrl = TextEditingController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  OutlineInputBorder _inputBorder([Color? c]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c ?? kDivisor),
      );

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const EncabezadoVerde(titulo: 'Nombrar Maceta'),
      backgroundColor: kFondoCrema,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            children: [
              // Nombre de la especie en grande (sin prefijo)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  widget.especie.nombre,
                  textAlign: TextAlign.center,
                  style: texto.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
              ),

              // Tarjeta principal
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Imagen de la especie (o icono de hoja si no hay asset)
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 92,
                            height: 92,
                            child: (widget.assetPath != null)
                                ? Image.asset(
                                    widget.assetPath!,
                                    fit: BoxFit.cover,
                                    cacheWidth: 300, // baja uso de RAM en emulador
                                    filterQuality: FilterQuality.low,
                                    errorBuilder: (_, __, ___) => _fallbackLeaf(),
                                  )
                                : _fallbackLeaf(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Título y subtítulo
                      Text(
                        'Dale un Nombre a tu Maceta',
                        textAlign: TextAlign.center,
                        style: texto.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E2E2E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Identifica fácilmente tu dispositivo en el dashboard',
                        textAlign: TextAlign.center,
                        style: texto.bodyMedium?.copyWith(
                          color: Colors.black.withOpacity(0.60),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Campo: Nombre
                      Text(
                        'Nombre de la Maceta',
                        style: texto.labelLarge?.copyWith(
                          color: Colors.black.withOpacity(0.80),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nombreCtrl,
                        decoration: InputDecoration(
                          hintText: 'Ej: Maceta del Jardín',
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          prefixIcon: const Icon(Icons.local_florist_outlined),
                          border: _inputBorder(),
                          enabledBorder: _inputBorder(),
                          focusedBorder: _inputBorder(kPrimario),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Campo: Descripción
                      Text(
                        'Descripción (opcional)',
                        style: texto.labelLarge?.copyWith(
                          color: Colors.black.withOpacity(0.80),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _descripcionCtrl,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Ubicación, notas o cualquier detalle',
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 60.0),
                            child: Icon(Icons.description_outlined),
                          ),
                          border: _inputBorder(),
                          enabledBorder: _inputBorder(),
                          focusedBorder: _inputBorder(kPrimario),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Info del dispositivo
                      Container(
                        decoration: BoxDecoration(
                          color: kDivisor.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: kDivisor),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 18, color: Colors.black.withOpacity(0.7)),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Información del Dispositivo',
                                    style: texto.labelMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const _InfoLine(texto: '• Modelo: ESP32 DevKit'),
                            const _InfoLine(texto: '• Sensores: Humedad, Temperatura, Luz'),
                            const _InfoLine(texto: '• Estado: Conectado y listo'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Botón: regresar a ConfigurarMaceta con datos
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            final nombre = _nombreCtrl.text.trim();
                            if (nombre.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Por favor, ingresa un nombre.'),
                                ),
                              );
                              return;
                            }
                            Navigator.pop(context, {
                              'especie': widget.especie,
                              'nombre': nombre,
                              'descripcion': _descripcionCtrl.text.trim(),
                              'assetPath': widget.assetPath,
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimario,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Continuar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallbackLeaf() => Container(
        color: kPrimario.withOpacity(0.08),
        child: const Center(
          child: Icon(Icons.eco_outlined, color: kPrimario, size: 36),
        ),
      );
}

class _InfoLine extends StatelessWidget {
  final String texto;
  const _InfoLine({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        texto,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black.withOpacity(0.75),
            ),
      ),
    );
  }
}
