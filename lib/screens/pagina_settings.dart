// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../utils/colores_app.dart';
import '../utils/theme_controller.dart';

class PaginaSettings extends StatefulWidget {
  const PaginaSettings({super.key});

  @override
  State<PaginaSettings> createState() => _PaginaSettingsState();
}

class _PaginaSettingsState extends State<PaginaSettings> {
  bool _notifOn = true;

  OutlineInputBorder _b(Color c) =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c));

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // ---------- Perfil ----------
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Perfil de Usuario',
                        style: texto.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: kPrimario.withOpacity(0.15),
                          child: const Icon(Icons.person, color: kPrimario, size: 30),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Cambiar Foto'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Nombre', style: texto.labelLarge),
                    const SizedBox(height: 6),
                    TextField(
                      controller: TextEditingController(text: 'Usuario SPROUTY'),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: _b(Colors.grey.shade300),
                        enabledBorder: _b(Colors.grey.shade300),
                        focusedBorder: _b(kPrimario),
                        prefixIcon: const Icon(Icons.badge_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Correo Electrónico', style: texto.labelLarge),
                    const SizedBox(height: 6),
                    TextField(
                      controller: TextEditingController(text: 'usuario@sprouty.com'),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: _b(Colors.grey.shade300),
                        enabledBorder: _b(Colors.grey.shade300),
                        focusedBorder: _b(kPrimario),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: kPrimario,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Guardar Cambios'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------- Preferencias ----------
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Preferencias',
                        style: texto.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),

                    // Notificaciones
                    _prefTile(
                      context,
                      icon: Icons.notifications_outlined,
                      title: 'Notificaciones',
                      subtitle: 'Recibir alertas y recordatorios',
                      trailing: Switch(
                        value: _notifOn,
                        onChanged: (v) => setState(() => _notifOn = v),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tema Oscuro (Switch real de la app)
                    _prefTile(
                      context,
                      icon: Icons.dark_mode_outlined,
                      title: 'Tema Oscuro',
                      subtitle: 'Cambiar apariencia de la app',
                      trailing: Switch(
                        value: ThemeController.isDark,
                        onChanged: (v) {
                          ThemeController.set(v); // 👈 cambia el ThemeMode
                          setState(() {});        // refresca el switch local
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------- Cerrar sesión ----------
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _prefTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: kPrimario.withOpacity(0.15),
            child: Icon(icon, color: kPrimario, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
