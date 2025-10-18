import 'package:flutter/material.dart';
import 'package:sprouty_app/screens/pagina_settings.dart';
import '../utils/colores_app.dart';
import 'pagina_notifications.dart';
import 'pagina_dashBoard.dart';
import 'pagina_catalog.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _index = 2; // Empezamos en "Avisos" como ejemplo

  final List<String> _titulos = const [
    'Catálogo de Plantas',
    'Mis Plantas',
    'Notificaciones',
    'Ajustes',
  ];

  final List<Widget> _pantallas = const [
    PaginaCatalog(), // aquí iría tu "Catálogo"
    PaginaDashBoard(), // ejemplo para Dashboard
    PaginaNotifications(), // Avisos
    PaginaSettings(), // Ajustes (temporal)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFondoCrema,
      appBar: AppBar(
        backgroundColor: kFondoCrema,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            _titulos[_index],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: _pantallas[_index],
      bottomNavigationBar: NavigationBar(
        backgroundColor: kFondoCrema,
        selectedIndex: _index,
        onDestinationSelected: (int i) {
          setState(() {
            _index = i;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Catálogo'),
          NavigationDestination(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(
              icon: Icon(Icons.notifications), label: 'Avisos'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}
