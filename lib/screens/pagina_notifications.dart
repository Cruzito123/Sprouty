import 'package:flutter/material.dart';
import '../utils/colores_app.dart';
import '../services/servicio_notificaciones.dart'; // <--- IMPORTANTE

class PaginaNotifications extends StatelessWidget {
  // Ya no necesita ser StatefulWidget
  const PaginaNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos ValueListenableBuilder para reconstruir la pantalla cuando cambie la lista
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: ServicioNotificaciones().historial,
      builder: (context, notificaciones, child) {
        return Scaffold(
          backgroundColor: kFondoCrema,
          appBar: AppBar(
            backgroundColor: kFondoCrema,
            elevation: 0,
            toolbarHeight: 20,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tus Avisos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('${notificaciones.length} notificaciones'),
                const SizedBox(height: 12),
                if (notificaciones.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      ServicioNotificaciones().borrarTodas();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimario,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Borrar todas'),
                  ),
                const SizedBox(height: 16),
                Expanded(
                  // Usamos Expanded para que la lista ocupe el resto del espacio
                  child: notificaciones.isEmpty
                      ? const Center(
                          child: Text(
                            'No tienes notificaciones pendientes 🎉',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          // ListView.builder es más eficiente
                          itemCount: notificaciones.length,
                          itemBuilder: (context, index) {
                            final notif = notificaciones[index];
                            return NotificacionCard(
                              icon: notif['icon'],
                              title: notif['title'],
                              message: notif['message'],
                              time: notif['time'],
                              colorFondo: notif['color'] ?? Colors.white,
                              onDelete: () {
                                ServicioNotificaciones().borrarUna(index);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ... Tu clase NotificacionCard se queda igual ...
class NotificacionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final Color colorFondo;
  final VoidCallback onDelete;

  const NotificacionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.onDelete,
    this.colorFondo = const Color(0xFFDFF5E1),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorFondo,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: kPrimario),
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
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
