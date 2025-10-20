import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/fade_efecto.dart';
import '../widgets/logo_efecto.dart';

class PaginaBienvenida extends StatefulWidget {
  const PaginaBienvenida({super.key});

  @override
  State<PaginaBienvenida> createState() => _PaginaBienvenidaState();
}

class _PaginaBienvenidaState extends State<PaginaBienvenida> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    // Fade-in al montar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });

    // Auto-navegar después de 2.5s, con fade-out de 500ms antes
    Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      setState(() => _visible = false);
      Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final fondo = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: FadeOpacity(
              visible: _visible,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogoRedondo(assetPath: 'assets/SPROUTY_SF.png', size: 150),
                  const SizedBox(height: 24),
                  Text(
                    'Cuidar tus plantas nunca fue tan fácil',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
