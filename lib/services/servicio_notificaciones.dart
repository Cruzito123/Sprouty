import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ServicioNotificaciones {
  static final ServicioNotificaciones _instance =
      ServicioNotificaciones._internal();
  factory ServicioNotificaciones() => _instance;
  ServicioNotificaciones._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 1. Lista reactiva (la UI escuchará cambios aquí)
  final ValueNotifier<List<Map<String, dynamic>>> historial = ValueNotifier([]);

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> mostrarNotificacion({
    required int id,
    required String titulo,
    required String cuerpo,
  }) async {
    // 2. Mostrar en el sistema operativo
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'sprouty_alertas',
      'Alertas de Plantas',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      titulo,
      cuerpo,
      platformChannelSpecifics,
    );

    // 3. Agregar a la lista de la aplicación
    _agregarAlHistorial(titulo, cuerpo);
  }

  void _agregarAlHistorial(String titulo, String cuerpo) {
    final nuevaNotificacion = {
      'icon': Icons.notifications_active, // Icono por defecto para alertas
      'title': titulo,
      'message': cuerpo,
      'time': 'Ahora', // Podrías formatear DateTime.now() aquí
      'color': const Color(0xFFFFEBEE), // Color rojizo suave para alertas
    };

    // Creamos una nueva lista con el elemento nuevo al principio
    final listaActual = List<Map<String, dynamic>>.from(historial.value);
    listaActual.insert(0, nuevaNotificacion);

    // Notificamos a la UI
    historial.value = listaActual;
  }

  // Métodos para limpiar desde la UI
  void borrarTodas() {
    historial.value = [];
  }

  void borrarUna(int index) {
    final listaActual = List<Map<String, dynamic>>.from(historial.value);
    listaActual.removeAt(index);
    historial.value = listaActual;
  }
}
