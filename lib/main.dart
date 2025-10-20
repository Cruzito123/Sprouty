import 'package:flutter/material.dart';
import 'package:sprouty_app/screens/pagina_bienvenida.dart';
import 'package:sprouty_app/screens/pagina_configurar_maceta.dart';
import 'package:sprouty_app/screens/pagina_dashboard.dart';
import 'utils/tema_app.dart';
import 'screens/pagina_Recomendations.dart';
import 'screens/pagina_login.dart';
import 'screens/pagina_registro.dart';
import 'screens/pagina_notifications.dart';
import 'screens/pagina_principal.dart';

void main() => runApp(const SproutyApp());

class SproutyApp extends StatelessWidget {
  const SproutyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPROUTY',
      theme: construirTemaApp(),
      initialRoute: '/bienvenida',
      routes: {
        '/bienvenida': (_) => const PaginaBienvenida(),
        '/login': (_) => const PaginaLogin(),
        '/configurar': (_) => const PaginaConfigurarMaceta(),
        '/registro': (_) => const PaginaRegistro(),
        '/notifications': (_) => const PaginaNotifications(),
        '/principal': (_) => const PaginaPrincipal(),
        '/dashboard': (_) => const PaginaDashboard(),
        '/recomendaciones': (c) => const PaginaRecomendations(species: 'general'),      
        },
    );
  }
}
