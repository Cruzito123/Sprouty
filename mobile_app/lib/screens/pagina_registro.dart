import 'package:flutter/material.dart';
import '../utils/colores_app.dart';
import '../widgets/boton_google.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_url.dart';
import '../widgets/tarjeta_auth.dart';
import '../widgets/boton_primario.dart';

class PaginaRegistro extends StatefulWidget {
  const PaginaRegistro({super.key});

  @override
  State<PaginaRegistro> createState() => _PaginaRegistroEstado();
}

class _PaginaRegistroEstado extends State<PaginaRegistro> {
  final _formKey = GlobalKey<FormState>();

  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  bool _cargando = false;

  Future<void> iniciarConGoogle() async {
    try {
      // 🔥 IMPORTANTE: Cerrar sesión para forzar seleccionar cuenta
      await _googleSignIn.signOut();

      final usuarioGoogle = await _googleSignIn.signIn();
      if (usuarioGoogle == null) return;

      final nombre = usuarioGoogle.displayName ?? "";
      final correo = usuarioGoogle.email;

      setState(() {
        _nombreCtrl.text = nombre;
        _emailCtrl.text = correo;
      });

      print("Google -> nombre=$nombre correo=$correo");
    } catch (e) {
      print("ERROR al iniciar con Google: $e");
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  InputDecoration _dec(String etiqueta, String hint, IconData icono) {
    return InputDecoration(
      labelText: etiqueta,
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      prefixIcon: Icon(icono, color: Theme.of(context).textTheme.bodySmall?.color),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
    );
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      final baseUrl = await ApiUrl.getBaseUrl();

      final url = Uri.parse("$baseUrl/api/registro/");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": _nombreCtrl.text.trim(),
          "email": _emailCtrl.text.trim(),
          "password": _passCtrl.text.trim(),
        }),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        if (mounted) Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${data['error']}")),
        );
      }
    } catch (e) {
      print("ERROR FLUTTER: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error de conexión")),
      );
    }

    if (mounted) setState(() => _cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: TarjetaAuth(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Crear Cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                'Únete a SPROUTY y cuida tus plantas',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
              ),
              const SizedBox(height: 24),

              // 🔵 BOTÓN GOOGLE
              BotonGoogle(onPressed: iniciarConGoogle),
              const SizedBox(height: 16),

              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('o'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              // CAMPOS ✏️
              TextFormField(
                controller: _nombreCtrl,
                decoration: _dec('Nombre Completo', 'Tu nombre',
                    Icons.person_outline),
                validator: (v) => (v == null || v.trim().length < 3)
                    ? 'Ingresa tu nombre'
                    : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: _dec('Correo Electrónico', 'tu@email.com',
                    Icons.email_outlined),
                validator: (v) {
                  final ok =
                      RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v ?? '');
                  return ok ? null : 'Correo no válido';
                },
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: _dec('Contraseña', 'Mínimo 6 caracteres',
                    Icons.lock_outline),
                validator: (v) => (v != null && v.length >= 6)
                    ? null
                    : 'Mínimo 6 caracteres',
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _pass2Ctrl,
                obscureText: true,
                decoration: _dec('Confirmar Contraseña',
                    'Repite tu contraseña', Icons.lock_outline),
                validator: (v) => (v == _passCtrl.text)
                    ? null
                    : 'Las contraseñas no coinciden',
              ),
              const SizedBox(height: 20),

              BotonPrimario(
                texto: 'Registrarse',
                onPressed: _registrar,
                cargando: _cargando,
              ),

              const SizedBox(height: 14),

              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  '¿Ya tienes cuenta? Inicia sesión',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
