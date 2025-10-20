import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class TarjetaConsejo extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final bool bueno;

  const TarjetaConsejo({
    super.key,
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.bueno,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: bueno ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(icono, color: kPrimario),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(
                  subtitulo,
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
