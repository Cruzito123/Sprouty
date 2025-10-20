import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/colores_app.dart'; // si usas kDivisor

class BotonGoogle extends StatelessWidget {
  final VoidCallback onPressed;
  const BotonGoogle({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        'assets/google.svg',
        width: 20,
        height: 20,
      ),
      label: const Text(
        'Continuar con Google',
        style: TextStyle(color: Colors.black87, fontSize: 15),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFFF7F6F3),
        side: const BorderSide(color: kDivisor),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
