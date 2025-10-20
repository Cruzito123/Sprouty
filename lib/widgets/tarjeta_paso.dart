import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class TarjetaPaso extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final bool listo;
  final VoidCallback onTap;

  const TarjetaPaso({
    super.key,
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.listo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(0, 2),
                color: Color(0x14000000),
              )
            ],
            border: Border.all(color: kDivisor),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: kPrimario.withOpacity(.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icono, color: kPrimario),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            )),
                    const SizedBox(height: 2),
                    Text(
                      subtitulo,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.black45),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                listo ? Icons.check_circle : Icons.chevron_right_rounded,
                color: listo ? kPrimario : Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
