import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class BotonGoogle extends StatelessWidget {
  final VoidCallback onPressed;
  const BotonGoogle({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.login, size: 18, color: Colors.black87),
      label: const Text('Continuar con Google',
          style: TextStyle(color: Colors.black87)),
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFFF7F6F3),
        side: const BorderSide(color: kDivisor),
        minimumSize: const Size(double.infinity, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
