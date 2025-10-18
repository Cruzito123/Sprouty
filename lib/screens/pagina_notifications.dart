import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class PaginaNotifications extends StatelessWidget {
  const PaginaNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFondoCrema,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kFondoCrema,
        elevation: 0,
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
            const Text('2 notificaciones nuevas'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
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
            Expanded(
              child: ListView(
                children: const [
                  NotificacionCard(
                    icon: Icons.water_drop_outlined,
                    title: 'Recordatorio de Riego',
                    message:
                        'Es hora de regar tu Suculenta. La humedad del suelo está por debajo del 40%.',
                    time: 'Hace 2 horas',
                  ),
                  NotificacionCard(
                    icon: Icons.wb_sunny_outlined,
                    title: 'Nivel de Luz Bajo',
                    message:
                        'Tu Helecho necesita más luz solar. Considera moverlo cerca de una ventana.',
                    time: 'Hace 5 horas',
                  ),
                  NotificacionCard(
                    icon: Icons.sensors,
                    title: 'Actualización de Sensor',
                    message:
                        'Sensor ESP32-001 conectado exitosamente. Temperatura: 22°C, Humedad: 65%',
                    time: 'Ayer',
                    colorFondo: Colors.white,
                  ),
                  NotificacionCard(
                    icon: Icons.settings_outlined,
                    title: 'Configuración Actualizada',
                    message:
                        'Los parámetros de riego para Monstera han sido ajustados según tus preferencias.',
                    time: 'Ayer',
                    colorFondo: Colors.white,
                  ),
                ],
              ),
            ),
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

  const NotificacionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    this.colorFondo = const Color(0xFFDFF5E1), // verde claro por defecto
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
                  onPressed: () {},
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
