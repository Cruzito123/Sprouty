import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class NotificacionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final Color? colorFondo; // Hacemos colorFondo opcional
  final VoidCallback onDelete;

  const NotificacionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.onDelete,
    this.colorFondo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorFondo ?? Theme.of(context).primaryColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(message),
            const SizedBox(height: 8),
            Text(
              time,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
