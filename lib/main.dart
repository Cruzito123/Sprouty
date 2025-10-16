import 'package:flutter/material.dart';

void main() => runApp(const SproutyApp());

class SproutyApp extends StatelessWidget {
  const SproutyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF5CAF6B);
    const creamBg = Color(0xFFF3EEE4);
    const cardRadius = 18.0;
    const dividerColor = Color(0xFFE7E3DA);
    return Scaffold(
      backgroundColor: creamBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(cardRadius),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Image.asset('assets/SPROUTY.png', height: 96),
                    const SizedBox(height: 48),

                    const Text(
                      'Bienvenido de vuelta',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    // Botón Google (estilo claro)
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.login,
                          size: 18, color: Colors.black87),
                      label: const Text(
                        'Continuar con Google',
                        style: TextStyle(color: Colors.black87),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7F6F3),
                        side: const BorderSide(color: Color(0xFFE7E3DA)),
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Divisor "o continúa con email"
                    const Row(
                      children: [
                        Expanded(
                            child: Divider(thickness: 1, color: dividerColor)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('o',
                              style: TextStyle(color: Colors.black45)),
                        ),
                        Expanded(
                            child: Divider(thickness: 1, color: dividerColor)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Campo correo
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Correo Electrónico',
                        fillColor: const Color(0xFFF7F6F3),
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: _errorMessage != null
                                  ? Colors.red
                                  : const Color(0xFFE7E3DA)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: primary),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo contraseña
                    TextField(
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Contraseña',
                        fillColor: const Color(0xFFF7F6F3),
                        prefixIcon: const Icon(Icons.lock_outline_rounded,
                            color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: _errorMessage != null
                                  ? Colors.red
                                  : const Color(0xFFE7E3DA)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: primary),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                    ),

                    // Enlace olvidaste contraseña y mensaje de error
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap),
                            child: const Text('¿Olvidaste tu contraseña?',
                                style: TextStyle(color: primary, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),

                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      )
                    else
                      const SizedBox(height: 18),

                    // CTA Iniciar sesión
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                                _errorMessage = null;
                              });
                              // Simula una llamada de red
                              await Future.delayed(const Duration(seconds: 2));
                              setState(() {
                                _isLoading = false;
                                _errorMessage =
                                    'Correo electrónico o contraseña incorrectos';
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text('Iniciar Sesión'),
                    ),
                    const SizedBox(height: 14),

                    // Link crear cuenta
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes cuenta?',
                            style: TextStyle(color: Colors.black54)),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Crear nueva cuenta',
                            style: TextStyle(
                                color: primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
