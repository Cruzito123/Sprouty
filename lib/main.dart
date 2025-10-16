import 'package:flutter/material.dart';
import 'utils/tema_app.dart';
import 'screens/pagina_login.dart';

void main() => runApp(const SproutyApp());

class SproutyApp extends StatelessWidget {
  const SproutyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPROUTY',
      theme: construirTemaApp(),
      home: const PaginaLogin(),
    );
  }
}
