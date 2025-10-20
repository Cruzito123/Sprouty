// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../utils/especie.dart';
import 'pagina_nombrar.dart';

class PaginaCatalogoTarjeta extends StatefulWidget {
  const PaginaCatalogoTarjeta({super.key});

  @override
  State<PaginaCatalogoTarjeta> createState() => _PaginaCatalogoTarjetaState();
}

class _PaginaCatalogoTarjetaState extends State<PaginaCatalogoTarjeta> {
  final TextEditingController _ctrlBuscar = TextEditingController();
  String _query = '';

  /// Top 5 (asegúrate de tener estos PNG en assets/species/ y declararlos en pubspec.yaml)
  final List<Map<String, String>> _items = const [
    {'id': 'sp-espatifilo',  'nombre': 'Espatifilo',       'asset': 'assets/species/espatifilo.png'},
    {'id': 'sp-suculenta',   'nombre': 'Suculenta',        'asset': 'assets/species/suculenta.png'},
    {'id': 'sp-monstera',    'nombre': 'Monstera',         'asset': 'assets/species/monstera.png'},
    {'id': 'sp-poto',        'nombre': 'Poto',             'asset': 'assets/species/poto.png'},
    {'id': 'sp-sansevieria', 'nombre': 'Lengua de suegra', 'asset': 'assets/species/lengua_de_suegra.png'},
  ];

  @override
  void dispose() {
    _ctrlBuscar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _query.trim().isEmpty
        ? _items
        : _items
            .where((e) => e['nombre']!
                .toLowerCase()
                .contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Plantas'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Buscador
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
              child: TextField(
                controller: _ctrlBuscar,
                onChanged: (v) => setState(() => _query = v),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Buscar planta...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Encabezado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Top 5 Plantas Más Comunes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          )),
                  const SizedBox(height: 6),
                  Text('Selecciona la especie que vas a cuidar',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black54)),
                ],
              ),
            ),

            // Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: GridView.builder(
                  itemCount: visibles.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (_, i) {
                    final e = visibles[i];
                    return _PlantCard(
                      title: e['nombre']!,
                      assetPath: e['asset']!,
                      onTap: () async {
                        final esp = Especie(
                          id: e['id']!,
                          nombre: e['nombre']!,
                          descripcion: '',
                        );

                        // Abrimos Nombrar y esperamos la respuesta
                        final result = await Navigator.push<Map<String, dynamic>>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaginaNombrar(
                              especie: esp,
                              assetPath: e['asset'], // mostramos la imagen en Nombrar
                            ),
                          ),
                        );

                        // Si Nombrar devolvió datos, devolvemos el mismo result a ConfigurarMaceta
                        if (!mounted) return;
                        if (result != null) {
                          Navigator.pop(context, result);
                        }
                      },
                    );
                  },
                ),
              ),
            ),

            // Botón inferior opcional
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D32),
                  side: const BorderSide(color: Color(0xFF8BC48A)),
                  backgroundColor: const Color(0xFFE8F3EA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  // Aquí podrías abrir un formulario para agregar especie personalizada
                },
                icon: const Icon(Icons.add),
                label: const Text('Añadir Nueva Especie'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  final String title;
  final String assetPath;
  final VoidCallback onTap;

  const _PlantCard({
    required this.title,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                cacheWidth: 300,                 // reduce uso de RAM en emulador
                filterQuality: FilterQuality.low,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.image_not_supported),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
