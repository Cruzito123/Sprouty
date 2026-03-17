import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class ItemAjustePerfil extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final VoidCallback alEditar;

  const ItemAjustePerfil({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.alEditar,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: alEditar,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(etiqueta,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(valor,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyLarge?.color)),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle),
              child: Icon(Icons.edit_rounded,
                  size: 18, color: Theme.of(context).primaryColor),
            )
          ],
        ),
      ),
    );
  }
}
