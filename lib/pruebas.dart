import 'package:flutter/material.dart';
import 'screens/pagina_notifications.dart';

void main() {
  runApp(const PruebaNotificaciones());
}

class PruebaNotificaciones extends StatelessWidget {
  const PruebaNotificaciones({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pantalla de Notificaciones',
      debugShowCheckedModeBanner: false,
      home: const PaginaNotifications(),
    );
  }
}
