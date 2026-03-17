import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class BotonPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final bool cargando;

  const BotonPrimario({
    super.key,
    required this.texto,
    this.onPressed,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: cargando ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.surface,
        minimumSize: const Size(double.infinity, 46),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
      ),
      child: cargando
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.surface,
                strokeWidth: 2.5,
              ),
            )
          : Text(
              texto,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
    );
  }
}
