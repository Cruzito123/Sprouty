import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class PaginaCatalogo extends StatelessWidget {
  const PaginaCatalogo({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista completa con las 5 plantas y sus descripciones
    final List<Map<String, String>> plantas = [
      {
        'nombre': 'Suculenta',
        'cientifico': 'Echeveria spp.',
        'agua': 'Baja',
        'luz': 'Alta',
        'humedad': 'Baja',
        'imagen': 'assets/species/suculenta.png',
        'descripcion':
            'Planta carnosa que almacena agua, ideal para espacios muy soleados y de poco riego.'
      },
      {
        'nombre': 'Lengua de Suegra',
        'cientifico': 'Sansevieria trifasciata',
        'agua': 'Media',
        'luz': 'Alta',
        'humedad': 'Baja',
        'imagen': 'assets/species/lengua_de_suegra.png',
        'descripcion':
            'Indestructible y purificadora de aire. Perfecta para interiores y olvidadizos.'
      },
      {
        'nombre': 'Espatifilo',
        'cientifico': 'Spathiphyllum wallisii',
        'agua': 'Alta',
        'luz': 'Media',
        'humedad': 'Alta',
        'imagen': 'assets/species/espatifilo.png',
        'descripcion':
            'Elegante planta con flores blancas que avisa dramáticamente cuando necesita agua.'
      },
      // --- PLANTAS FALTANTES ---
      {
        'nombre': 'Monstera',
        'cientifico': 'Monstera deliciosa',
        'agua': 'Media',
        'luz': 'Indirecta',
        'humedad': 'Alta',
        'imagen': 'assets/species/monstera.png',
        'descripcion':
            'La costilla de Adán, famosa por sus hojas agujereadas y su toque tropical.'
      },
      {
        'nombre': 'Poto',
        'cientifico': 'Epipremnum aureum',
        'agua': 'Media',
        'luz': 'Media',
        'humedad': 'Media',
        'imagen': 'assets/species/poto.png',
        'descripcion':
            'Trepada resistente de rápido crecimiento, tolera casi cualquier condición de luz.'
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        title: Text("Catálogo Completo",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar plantas...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Explora nuestro catálogo y añade plantas a tu jardín virtual',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Lista de plantas renderizada
            Column(
              children: plantas.map((planta) {
                return _PlantCard(
                  nombre: planta['nombre']!,
                  cientifico: planta['cientifico']!,
                  descripcion: planta['descripcion']!, // Pasamos la descripción
                  agua: planta['agua']!,
                  luz: planta['luz']!,
                  humedad: planta['humedad']!,
                  imagen: planta['imagen']!,
                  onAdd: () {
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  final String nombre;
  final String cientifico;
  final String descripcion; // Variable nueva
  final String agua;
  final String luz;
  final String humedad;
  final String imagen;
  final VoidCallback onAdd;

  const _PlantCard({
    required this.nombre,
    required this.cientifico,
    required this.descripcion, // Requerida en constructor
    required this.agua,
    required this.luz,
    required this.humedad,
    required this.imagen,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: Theme.of(context).cardColor,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.asset(
              imagen,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                alignment: Alignment.center,
                child: Icon(Icons.broken_image_outlined,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), size: 40),
              ),
            ),
          ),

          // Información
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nombre,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(cientifico,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // --- AQUÍ MOSTRAMOS LA DESCRIPCIÓN ---
                Text(
                  descripcion,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 13, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Chips de info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _infoChip(context, Icons.water_drop, 'Agua', agua)),
                    const SizedBox(width: 8),
                    Expanded(child: _infoChip(context, Icons.wb_sunny, 'Luz', luz)),
                    const SizedBox(width: 8),
                    Expanded(child: _infoChip(context, Icons.cloud, 'Humedad', humedad)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icono, String titulo, String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Icon(icono, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 4),
          Text(titulo,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
          Text(valor,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12)),
        ],
      ),
    );
  }
}
