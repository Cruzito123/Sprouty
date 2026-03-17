import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

InputDecoration inputDecoAjustes(BuildContext context, String hint, IconData icon) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon, color: Theme.of(context).textTheme.bodySmall?.color),
    filled: true,
    fillColor: Theme.of(context).scaffoldBackgroundColor,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5)),
  );
}

class DialogoEditarPerfil extends StatefulWidget {
  final String titulo;
  final String campoBackend;
  final String valorActual;
  final IconData icono;
  final Function(String, String) onGuardar;

  const DialogoEditarPerfil({
    super.key,
    required this.titulo,
    required this.campoBackend,
    required this.valorActual,
    required this.icono,
    required this.onGuardar,
  });

  @override
  State<DialogoEditarPerfil> createState() => _DialogoEditarPerfilState();
}

class _DialogoEditarPerfilState extends State<DialogoEditarPerfil> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.valorActual);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle),
              child: Icon(widget.icono,
                  color: Theme.of(context).primaryColor, size: 28),
            ),
            const SizedBox(height: 16),
            Text('Editar ${widget.titulo}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color)),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(fontSize: 16),
              decoration: inputDecoAjustes(context, 'Escribe aquí...', Icons.edit_outlined),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: Text('Cancelar',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => widget.onGuardar(
                        widget.campoBackend, controller.text.trim()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Guardar',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DialogoPassword extends StatefulWidget {
  final Function(String, String) onGuardar;

  const DialogoPassword({super.key, required this.onGuardar});

  @override
  State<DialogoPassword> createState() => _DialogoPasswordState();
}

class _DialogoPasswordState extends State<DialogoPassword> {
  final passAntiguaCtrl = TextEditingController();
  final passNuevaCtrl = TextEditingController();
  bool oculto = true;

  @override
  void dispose() {
    passAntiguaCtrl.dispose();
    passNuevaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle),
              child: Icon(Icons.lock_reset_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 28),
            ),
            const SizedBox(height: 16),
            Text('Nueva Contraseña',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color)),
            const SizedBox(height: 24),
            TextField(
                controller: passAntiguaCtrl,
                obscureText: oculto,
                decoration: inputDecoAjustes(context, 'Contraseña actual', Icons.lock_outline)),
            const SizedBox(height: 12),
            TextField(
                controller: passNuevaCtrl,
                obscureText: oculto,
                decoration: inputDecoAjustes(context, 'Nueva contraseña', Icons.key)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => oculto = !oculto),
                child: Text(oculto ? 'Mostrar caracteres' : 'Ocultar caracteres',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => widget.onGuardar(
                    passAntiguaCtrl.text, passNuevaCtrl.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Guardar',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
            )
          ],
        ),
      ),
    );
  }
}
