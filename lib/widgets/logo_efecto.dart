import 'package:flutter/material.dart';
import '../utils/colores_app.dart'; // usa kPrimario

class LogoRedondo extends StatelessWidget {
  final double size;      // diámetro del círculo/imagen
  final String assetPath; // ruta del asset

  const LogoRedondo({
    super.key,
    required this.assetPath,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: kPrimario.withOpacity(0.30),
            blurRadius: 25,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Image.asset(assetPath, width: size, height: size),
    );
  }
}
