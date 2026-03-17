import 'package:flutter/material.dart';

class AppColors {
  // Colores Base Constantes
  static const Color primario = Color(0xFF5CAF6B);
  static const Color secundiario = Color(0xFFE7E3DA);

  // Colores claros específicos
  static const Color fondoClaro = Color(0xFFF3EEE4);
  static const Color tarjetaClaro = Colors.white;
  static const Color textoPrincipalClaro = Colors.black87;
  static const Color textoSecundarioClaro = Colors.black54;
  static const Color grisFondoClaro = Color(0xFFF5F7F6);

  // Colores oscuros específicos
  static const Color fondoOscuro = Color(0xFF121212);
  static const Color tarjetaOscuro = Color(0xFF1E1E1E);
  static const Color textoPrincipalOscuro = Colors.white;
  static const Color textoSecundarioOscuro = Colors.white70;
  static const Color grisFondoOscuro = Color(0xFF2C2C2C);
}

class AppTheme {
  // TEMA CLARO
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primario,
      scaffoldBackgroundColor: AppColors.fondoClaro,
      cardColor: AppColors.tarjetaClaro,
      dividerColor: AppColors.secundiario,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primario,
        surface: AppColors.tarjetaClaro,
        onSurface: AppColors.textoPrincipalClaro,
      ),
      iconTheme: const IconThemeData(color: AppColors.textoSecundarioClaro),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textoPrincipalClaro),
        bodyMedium: TextStyle(color: AppColors.textoPrincipalClaro),
        bodySmall: TextStyle(color: AppColors.textoSecundarioClaro),
        titleLarge: TextStyle(color: AppColors.textoPrincipalClaro, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: AppColors.textoPrincipalClaro, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: AppColors.textoPrincipalClaro, fontWeight: FontWeight.bold),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.primario,
        textColor: AppColors.textoPrincipalClaro,
      ),
    );
  }

  // TEMA OSCURO
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primario,
      scaffoldBackgroundColor: AppColors.fondoOscuro,
      cardColor: AppColors.tarjetaOscuro,
      dividerColor: Colors.white24,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primario,
        surface: AppColors.tarjetaOscuro,
        onSurface: AppColors.textoPrincipalOscuro,
      ),
      iconTheme: const IconThemeData(color: AppColors.textoSecundarioOscuro),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textoPrincipalOscuro),
        bodyMedium: TextStyle(color: AppColors.textoPrincipalOscuro),
        bodySmall: TextStyle(color: AppColors.textoSecundarioOscuro),
        titleLarge: TextStyle(color: AppColors.textoPrincipalOscuro, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: AppColors.textoPrincipalOscuro, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: AppColors.textoPrincipalOscuro, fontWeight: FontWeight.bold),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.primario,
        textColor: AppColors.textoPrincipalOscuro,
      ),
    );
  }
}
