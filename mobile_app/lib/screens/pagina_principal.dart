import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

import 'pagina_catalogo.dart';
import 'pagina_dashboard.dart';
import 'pagina_notifications.dart';
import 'pagina_settings.dart';
import '../widgets/barra_navegacion.dart';

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
    PaginaCatalogo(),
    PaginaDashboard(),
    PaginaNotifications(),
    PaginaSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
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
      bottomNavigationBar: BarraNavegacion(
        index: _index,
        onIndexChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}
