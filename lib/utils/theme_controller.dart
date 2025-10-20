import 'package:flutter/material.dart';

class ThemeController {
  // Estado global del tema: claro u oscuro
  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static bool get isDark => mode.value == ThemeMode.dark;

  static void set(bool dark) {
    mode.value = dark ? ThemeMode.dark : ThemeMode.light;
  }

  static void toggle() {
    set(!isDark);
  }
}
