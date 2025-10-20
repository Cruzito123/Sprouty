import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class PaginaNotifications extends StatefulWidget {
  const PaginaNotifications({super.key});

  @override
  State<PaginaNotifications> createState() => _PaginaNotificationsState();
}

class _PaginaNotificationsState extends State<PaginaNotifications> {
  List<Map<String, dynamic>> notificaciones = [
    {
      'icon': Icons.water_drop_outlined,
      'title': 'Recordatorio de Riego',
      'message':
          'Es hora de regar tu Suculenta. La humedad del suelo está por debajo del 40%.',
      'time': 'Hace 2 horas',
      'color': const Color(0xFFDFF5E1),
    },
    {
      'icon': Icons.wb_sunny_outlined,
      'title': 'Nivel de Luz Bajo',
      'message':
          'Tu Helecho necesita más luz solar. Considera moverlo cerca de una ventana.',
      'time': 'Hace 5 horas',
      'color': const Color(0xFFDFF5E1),
    },
    {
      'icon': Icons.sensors,
      'title': 'Actualización de Sensor',
      'message':
          'Sensor ESP32-001 conectado exitosamente. Temperatura: 22°C, Humedad: 65%',
      'time': 'Ayer',
      'color': Colors.white,
    },
    {
      'icon': Icons.settings_outlined,
      'title': 'Configuración Actualizada',
      'message':
          'Los parámetros de riego para Monstera han sido ajustados según tus preferencias.',
      'time': 'Ayer',
      'color': Colors.white,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFondoCrema,
      appBar: AppBar(
        backgroundColor: kFondoCrema,
        elevation: 0,
        toolbarHeight: 20,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Tus Avisos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('${notificaciones.length} notificaciones nuevas'),
            const SizedBox(height: 12),
            if (notificaciones.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    notificaciones.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimario,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Marcar todas leídas'),
              ),
            const SizedBox(height: 16),
            if (notificaciones.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    'No tienes notificaciones pendientes 🎉',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else
              ...notificaciones.asMap().entries.map((entry) {
                final index = entry.key;
                final notif = entry.value;
                return NotificacionCard(
                  icon: notif['icon'],
                  title: notif['title'],
                  message: notif['message'],
                  time: notif['time'],
                  colorFondo: notif['color'],
                  onDelete: () {
                    setState(() {
                      notificaciones.removeAt(index);
                    });
                  },
                );
              }),
          ],
        ),
      ),
    );
  }
}

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
