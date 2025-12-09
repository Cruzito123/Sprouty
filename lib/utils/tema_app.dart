import 'package:flutter/material.dart';
import 'colores_app.dart';

class AppTheme {
  // ☀️ TEMA CLARO (Único tema activo)
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: kFondoCrema,

    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimario,
      primary: kPrimario,
      surface: Colors.white,
      brightness: Brightness.light,
    ),

    // Barra de Navegación
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: kPrimario,
      unselectedItemColor: Colors.grey,
      elevation: 10,
    ),

    // Barra Superior
    appBarTheme: const AppBarTheme(
      backgroundColor: kFondoCrema,
      foregroundColor: Colors.black,
      elevation: 0,
    ),

    // Inputs
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF7F6F3),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: kPrimario, width: 1.5)),
    ),

    // Iconos
    iconTheme: const IconThemeData(color: Colors.black54),
  );
}
