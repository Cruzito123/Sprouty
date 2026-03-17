import 'package:flutter/material.dart';
import '../utils/colores_app.dart';
import '../widgets/tarjeta_notificacion.dart';
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).colorScheme.surface,
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
                      ? Center(
                          child: Text(
                            'No tienes notificaciones pendientes 🎉',
                            style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
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
                              colorFondo: notif['color'] ?? Theme.of(context).cardColor,
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
