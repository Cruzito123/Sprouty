import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  // Notificador que avisa a toda la app cuando cambia el tema
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);

  // Getter simple para saber si es oscuro
  static bool get isDark => mode.value == ThemeMode.dark;

  // 1. Cargar preferencia al iniciar la app
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDark') ?? false; // Por defecto claro
    mode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  // 2. Cambiar tema y guardar
  static Future<void> set(bool isDark) async {
    mode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }

  // Alternar (Toogle)
  static void toggle() {
    set(!isDark);
  }
}
