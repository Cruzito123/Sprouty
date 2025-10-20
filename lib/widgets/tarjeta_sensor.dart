import 'package:flutter/material.dart';

class TarjetaSensor extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color colorEstado;
  final IconData icono;

  const TarjetaSensor({
    super.key,
    required this.titulo,
    required this.valor,
    required this.colorEstado,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: colorEstado,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icono, size: 16, color: Colors.black54),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                titulo,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Text(valor,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
