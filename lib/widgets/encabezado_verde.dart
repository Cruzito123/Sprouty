import 'package:flutter/material.dart';
import '../utils/colores_app.dart'; // usa tus constantes kPrimario

class EncabezadoVerde extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final bool mostrarFlecha; // para volver atrás

  const EncabezadoVerde({
    super.key,
    required this.titulo,
    this.mostrarFlecha = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimario,
      elevation: 0,
      centerTitle: false,
      foregroundColor: Colors.white,
      leading: mostrarFlecha
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(
        titulo,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
    );
  }

  // Requisito para AppBar personalizado
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
