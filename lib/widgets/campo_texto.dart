import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class CampoTexto extends StatelessWidget {
  final String etiqueta;
  final String? sugerencia;
  final IconData? iconoInicio;
  final bool oculto;
  final bool hayError;
  final Widget? iconoFinal;

  const CampoTexto({
    super.key,
    required this.etiqueta,
    this.sugerencia,
    this.iconoInicio,
    this.oculto = false,
    this.hayError = false,
    this.iconoFinal,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: oculto,
      keyboardType: oculto ? TextInputType.text : TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: etiqueta,
        hintText: sugerencia,
        prefixIcon: iconoInicio != null
            ? Icon(iconoInicio, color: Colors.black54)
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: hayError ? Colors.red : kDivisor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kPrimario),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        suffixIcon: iconoFinal,
      ),
    );
  }
}
