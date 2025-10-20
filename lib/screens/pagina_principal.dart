import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

import 'pagina_catalog.dart';
import 'pagina_dashboard.dart';
import 'pagina_notifications.dart';
import 'pagina_settings.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _index = 0;

  final List<String> _titulos = const [
    'Catálogo de Plantas',
    'Mis Plantas',
    'Notificaciones',
    'Ajustes',
  ];

  final List<Widget> _pantallas = const [
    PaginaCatalog(),
    PaginaDashboard(),
    PaginaNotifications(),
    PaginaSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFondoCrema,
      appBar: AppBar(
        backgroundColor: kFondoCrema,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                'assets/SPROUTY_SF.png',
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _titulos[_index],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),

      // Conserva el estado de cada pestaña
      body: IndexedStack(
        index: _index,
        children: _pantallas,
      ),

      // Barra inferior con divisor superior y sin "pill"
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: kFondoCrema,
          border: Border(
            top: BorderSide(color: kDivisor, width: 1), // línea separadora
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors
                .transparent, // quita la pastilla de selección (pill)
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
              (states) {
                final bool selected = states.contains(WidgetState.selected);
                return TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? kPrimario : Colors.black54,
                );
              },
            ),
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            height: 72,
            selectedIndex: _index,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.list,
                  color: _index == 0 ? kPrimario : Colors.black54,
                ),
                label: 'Catálogo',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.dashboard,
                  color: _index == 1 ? kPrimario : Colors.black54,
                ),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.notifications,
                  color: _index == 2 ? kPrimario : Colors.black54,
                ),
                label: 'Avisos',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.settings,
                  color: _index == 3 ? kPrimario : Colors.black54,
                ),
                label: 'Ajustes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
