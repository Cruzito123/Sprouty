import 'package:flutter/material.dart';
import '../utils/colores_app.dart';
import '../widgets/campo_texto.dart';
import '../widgets/boton_google.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginEstado();
}

class _PaginaLoginEstado extends State<PaginaLogin> {
  bool mostrarContrasena = false;
  bool cargando = false;
  String? mensajeError;

  @override
  Widget build(BuildContext context) {
    const radioTarjeta = 18.0;

    return Scaffold(
      backgroundColor: kFondoCrema,
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
                  borderRadius: BorderRadius.circular(radioTarjeta),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Image.asset('assets/SPROUTY.png', height: 108),
                    const SizedBox(height: 30),

                    const Text(
                      'Bienvenido de vuelta',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    // Botón Google
                    BotonGoogle(onPressed: () {}),
                    const SizedBox(height: 16),

                    // Divisor
                    const Row(
                      children: [
                        Expanded(child: Divider(thickness: 1, color: kDivisor)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('o',
                              style: TextStyle(color: Colors.black45)),
                        ),
                        Expanded(child: Divider(thickness: 1, color: kDivisor)),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Email
                    CampoTexto(
                      etiqueta: '',
                      sugerencia: 'Correo electronico',
                      iconoInicio: Icons.email_outlined,
                      hayError: mensajeError != null,
                    ),

                    // Contraseña
                    CampoTexto(
                      etiqueta: '',
                      sugerencia: 'Contraseña',
                      iconoInicio: Icons.lock_outline_rounded,
                      oculto: !mostrarContrasena,
                      hayError: mensajeError != null,
                      iconoFinal: IconButton(
                        icon: Icon(
                          mostrarContrasena
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(() {
                          mostrarContrasena = !mostrarContrasena;
                        }),
                      ),
                    ),

                    // Olvidaste contraseña
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
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('¿Olvidaste tu contraseña?',
                                style:
                                    TextStyle(color: kPrimario, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),

                    if (mensajeError != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        mensajeError!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ] else
                      const SizedBox(height: 18),

                    // CTA
                    ElevatedButton(
                      onPressed: cargando
                          ? null
                          : () async {
                              setState(() {
                                cargando = true;
                                mensajeError = null;
                              });
                              await Future.delayed(const Duration(seconds: 2));
                              setState(() {
                                cargando = false;
                                mensajeError =
                                    'Correo electrónico o contraseña incorrectos';
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimario,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: cargando
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

                    // Crear cuenta
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
                                color: kPrimario, fontWeight: FontWeight.bold),
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
