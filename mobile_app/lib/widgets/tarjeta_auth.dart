import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class TarjetaAuth extends StatelessWidget {
  final Widget child;

  const TarjetaAuth({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    const radioTarjeta = 18.0;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(radioTarjeta),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/SPROUTY_SF.png', height: 108),
                  const SizedBox(height: 30),
                  child, // Aquí se inyecta el contenido específico de Login o Registro
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
