import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class CampoTexto extends StatelessWidget {
  final String etiqueta;
  final String? sugerencia;
  final IconData? iconoInicio;
  final bool oculto;
  final bool hayError;
  final Widget? iconoFinal;

  // 🔹 CONTROLADOR NECESARIO
  final TextEditingController? controller;

  const CampoTexto({
    super.key,
    required this.etiqueta,
    this.sugerencia,
    this.iconoInicio,
    this.oculto = false,
    this.hayError = false,
    this.iconoFinal,
    this.controller, // <— AÑADIDO
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // <— AÑADIDO
      obscureText: oculto,
      keyboardType: oculto ? TextInputType.text : TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: etiqueta,
        hintText: sugerencia,
        prefixIcon: iconoInicio != null
            ? Icon(iconoInicio, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54))
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: hayError ? Theme.of(context).colorScheme.error : Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
        ),
        suffixIcon: iconoFinal,
      ),
    );
  }
}
