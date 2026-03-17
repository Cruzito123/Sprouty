import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/colores_app.dart';
import '../utils/api_url.dart';
import '../widgets/campo_texto.dart';
import '../widgets/boton_google.dart';
import '../widgets/tarjeta_auth.dart';
import '../widgets/boton_primario.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLogin();
}

class _PaginaLogin extends State<PaginaLogin> {
  // Controladores
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool mostrarContrasena = false;
  bool cargando = false;
  String? mensajeError;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // --------------------------------------------------------
  // LÓGICA 1: INICIAR CON GOOGLE
  // --------------------------------------------------------
  Future<void> iniciarConGoogle() async {
    try {
      setState(() {
        cargando = true;
        mensajeError = null;
      });

      await _googleSignIn.signOut();
      final usuarioGoogle = await _googleSignIn.signIn();

      if (usuarioGoogle == null) {
        setState(() => cargando = false);
        return;
      }

      final email = usuarioGoogle.email;
      print("Google Auth OK: $email. Consultando API...");

      final baseUrl = await ApiUrl.getBaseUrl();
      final url = Uri.parse("$baseUrl/api/login_google_check/");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      print("STATUS GOOGLE: ${response.statusCode}");

      if (response.statusCode == 200) {
        // ✅ 1. Decodificar respuesta
        final data = jsonDecode(response.body);

        // ✅ 2. Guardar ID en el teléfono
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', data['id']);

        // ✅ 3. Entrar
        if (mounted) Navigator.pushReplacementNamed(context, '/configurar');
      } else if (response.statusCode == 404) {
        setState(() {
          mensajeError = "Correo no registrado. Crea una cuenta primero.";
        });
      } else {
        setState(
            () => mensajeError = "Error del servidor (${response.statusCode})");
      }
    } catch (e) {
      print("ERROR GOOGLE: $e");
      setState(() => mensajeError = "Error de conexión con Google");
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  // --------------------------------------------------------
  // LÓGICA 2: LOGIN MANUAL (CORREO Y PASSWORD)
  // --------------------------------------------------------
  Future<void> iniciarSesionManual() async {
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.trim().isEmpty) {
      setState(() => mensajeError = "Ingresa correo y contraseña");
      return;
    }

    setState(() {
      cargando = true;
      mensajeError = null;
    });

    try {
      final baseUrl = await ApiUrl.getBaseUrl();
      final url = Uri.parse("$baseUrl/api/login_local/");

      print("Intentando login manual a: $url");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailCtrl.text.trim(),
          "password": _passCtrl.text.trim(),
        }),
      );

      print("STATUS LOGIN: ${response.statusCode}");

      if (response.statusCode == 200) {
        // ✅ 1. Decodificar respuesta
        final data = jsonDecode(response.body);

        // ✅ 2. Guardar ID en el teléfono
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', data['id']);

        // ✅ 3. Entrar
        if (mounted) Navigator.pushReplacementNamed(context, '/configurar');
      } else {
        try {
          final data = jsonDecode(response.body);
          setState(() {
            mensajeError = data['error'] ?? "Credenciales incorrectas";
          });
        } catch (_) {
          setState(() => mensajeError = "Error inesperado del servidor");
        }
      }
    } catch (e) {
      print("ERROR FLUTTER: $e");
      setState(() => mensajeError = "Error de conexión. Revisa tu IP.");
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: TarjetaAuth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bienvenido de vuelta',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
            ),
            const SizedBox(height: 20),

            // BOTÓN GOOGLE
            BotonGoogle(onPressed: cargando ? () {} : iniciarConGoogle),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(child: Divider(thickness: 1, color: Theme.of(context).dividerColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('o',
                      style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                ),
                Expanded(child: Divider(thickness: 1, color: Theme.of(context).dividerColor)),
              ],
            ),
            const SizedBox(height: 8),

            // EMAIL
            CampoTexto(
              controller: _emailCtrl,
              etiqueta: 'Correo Electrónico',
              sugerencia: 'tu@email.com',
              iconoInicio: Icons.email_outlined,
              hayError: mensajeError != null,
            ),
            const SizedBox(height: 14),

            // CONTRASEÑA
            CampoTexto(
              controller: _passCtrl,
              etiqueta: 'Contraseña',
              sugerencia: 'Mínimo 6 caracteres',
              iconoInicio: Icons.lock_outline_rounded,
              oculto: !mostrarContrasena,
              hayError: mensajeError != null,
              iconoFinal: IconButton(
                icon: Icon(
                  mostrarContrasena ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                onPressed: () => setState(() {
                  mostrarContrasena = !mostrarContrasena;
                }),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero),
                    child: Text('¿Olvidaste tu contraseña?',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor, fontSize: 12)),
                  ),
                ],
              ),
            ),

            if (mensajeError != null) ...[
              const SizedBox(height: 10),
              Text(
                mensajeError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
              ),
            ] else
              const SizedBox(height: 18),

            // BOTÓN INICIAR SESIÓN
            BotonPrimario(
              texto: 'Iniciar Sesión',
              onPressed: iniciarSesionManual,
              cargando: cargando,
            ),
            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¿No tienes cuenta?',
                    style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                TextButton(
                  onPressed: () async {
                    final creado =
                        await Navigator.pushNamed(context, '/registro');
                    if (creado == true && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Cuenta creada. Inicia sesión')),
                      );
                    }
                  },
                  child: Text(
                    'Crear nueva cuenta',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
