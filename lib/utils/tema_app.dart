import 'package:flutter/material.dart';
import 'colores_app.dart';

ThemeData construirTemaApp() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimario,
      primary: kPrimario,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: kFondoCrema,
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF7F6F3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  );
}
