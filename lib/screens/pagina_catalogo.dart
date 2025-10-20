import 'package:flutter/material.dart';
import '../utils/colores_app.dart';

class PaginaCatalogo extends StatelessWidget {
  const PaginaCatalogo({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> plantas = [
      {
        'nombre': 'Suculenta',
        'cientifico': 'Echeveria spp.',
        'agua': 'Baja',
        'luz': 'Alta',
        'humedad': 'Baja',
        'imagen': 'assets/species/suculenta.png',
      },
      {
        'nombre': 'Lengua de Suegra',
        'cientifico': 'Sansevieria trifasciata',
        'agua': 'Media',
        'luz': 'Alta',
        'humedad': 'Baja',
        'imagen': 'assets/species/lengua_de_suegra.png',
      },
      {
        'nombre': 'Espatifilo',
        'cientifico': 'Spathiphyllum wallisii',
        'agua': 'Alta',
        'luz': 'Media',
        'humedad': 'Alta',
        // 👇 corregido para ser consistente con tus assets
        'imagen': 'assets/species/espatifilo.png',
      },
    ];

    return Scaffold(
      backgroundColor: kFondoCrema,
      appBar: AppBar(
        backgroundColor: kFondoCrema,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
                fillColor: Colors.white,
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
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Lista de plantas tipo tarjetas
            Column(
              children: plantas.map((planta) {
                return _PlantCard(
                  nombre: planta['nombre']!,
                  cientifico: planta['cientifico']!,
                  agua: planta['agua']!,
                  luz: planta['luz']!,
                  humedad: planta['humedad']!,
                  imagen: planta['imagen']!,
                  onAdd: () {
                    // Aquí podrías devolver datos o solo volver
                    Navigator.pop(context); // vuelve al dashboard
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
  final String agua;
  final String luz;
  final String humedad;
  final String imagen;
  final VoidCallback onAdd;

  const _PlantCard({
    required this.nombre,
    required this.cientifico,
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
      elevation: 0,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagen,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: const Color(0xFFF2F2F2),
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(cientifico,
                    style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.brown)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoChip('Agua', agua),
                    _infoChip('Luz', luz),
                    _infoChip('Humedad', humedad),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir al Jardín'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimario,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String titulo, String valor) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(titulo,
              style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.w500)),
          Text(valor,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }
}
