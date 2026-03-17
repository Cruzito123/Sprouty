import 'package:flutter/material.dart';

class TarjetaPlanta extends StatelessWidget {
  final String nombre;
  final String especie;
  final String tempTexto;
  final String humedadTexto;
  final String luzTexto;

  final bool tempOk;
  final bool humedadOk;
  final bool luzOk;

  // ✅ ESTA ES LA VARIABLE QUE TE FALTA Y CAUSA EL ERROR ROJO
  final String? mensajeAlerta;

  final VoidCallback onEditarParametros;
  final VoidCallback onVerRecomendaciones;

  const TarjetaPlanta({
    super.key,
    required this.nombre,
    required this.especie,
    required this.tempTexto,
    required this.humedadTexto,
    required this.luzTexto,
    required this.tempOk,
    required this.humedadOk,
    required this.luzOk,
    this.mensajeAlerta, // ✅ Ahora el widget sabe recibir el mensaje
    required this.onEditarParametros,
    required this.onVerRecomendaciones,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cabecera
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(nombre,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 18)),
                        const SizedBox(width: 6),
                        if (mensajeAlerta != null)
                          Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.error,
                                  shape: BoxShape.circle))
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(especie,
                        style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color)),
                  ],
                ),
                InkWell(
                  onTap: onEditarParametros,
                  child: Row(children: [
                    Icon(Icons.settings_outlined,
                        size: 16, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 4),
                    Text("Parámetros",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold))
                  ]),
                )
              ],
            ),
          ),

          // Sensores
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                    child: _SensorBox(
                        label: "Temperatura",
                        valor: tempTexto,
                        icon: Icons.thermostat,
                        ok: tempOk)),
                const SizedBox(width: 10),
                Expanded(
                    child: _SensorBox(
                        label: "Humedad",
                        valor: humedadTexto,
                        icon: Icons.water_drop_outlined,
                        ok: humedadOk)),
                const SizedBox(width: 10),
                Expanded(
                    child: _SensorBox(
                        label: "Luz",
                        valor: luzTexto,
                        icon: Icons.wb_sunny_outlined,
                        ok: luzOk,
                        isLight: true)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Alerta Amarilla
          if (mensajeAlerta != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Theme.of(context).primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(mensajeAlerta!,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),

          const SizedBox(height: 20),

          // Botón Inferior
          InkWell(
            onTap: onVerRecomendaciones,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Theme.of(context).dividerColor))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sort,
                      size: 18, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Text("Ver Recomendaciones Detalladas",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SensorBox extends StatelessWidget {
  final String label, valor;
  final IconData icon;
  final bool ok;
  final bool isLight;
  const _SensorBox(
      {required this.label,
      required this.valor,
      required this.icon,
      required this.ok,
      this.isLight = false});

  @override
  Widget build(BuildContext context) {
    Color bg = ok
        ? (isLight
            ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
            : Theme.of(context).scaffoldBackgroundColor)
        : Theme.of(context).colorScheme.error.withValues(alpha: 0.1);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Icon(icon,
            size: 16, color: Theme.of(context).textTheme.bodySmall?.color),
        const SizedBox(height: 4),
        Text(valor,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
