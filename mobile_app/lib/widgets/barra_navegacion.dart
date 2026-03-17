import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class BarraNavegacion extends StatelessWidget {
  final int index;
  final ValueChanged<int> onIndexChanged;

  const BarraNavegacion({
    super.key,
    required this.index,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1), // línea separadora
        ),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent, // quita la pastilla de selección (pill)
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
            (states) {
              final bool selected = states.contains(WidgetState.selected);
              return TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
              );
            },
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 72,
          selectedIndex: index,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: onIndexChanged,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.list,
                color: index == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
              ),
              label: 'Catálogo',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.dashboard,
                color: index == 1 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
              ),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.notifications,
                color: index == 2 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
              ),
              label: 'Avisos',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings,
                color: index == 3 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
              ),
              label: 'Ajustes',
            ),
          ],
        ),
      ),
    );
  }
}
