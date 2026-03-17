// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../utils/especie.dart';
import '../widgets/tarjeta_catalogo.dart';
import 'pagina_nombrar.dart';

class PaginaCatalogoTarjeta extends StatefulWidget {
  const PaginaCatalogoTarjeta({super.key});

  @override
  State<PaginaCatalogoTarjeta> createState() => _PaginaCatalogoTarjetaState();
}

class _PaginaCatalogoTarjetaState extends State<PaginaCatalogoTarjeta> {
  final TextEditingController _ctrlBuscar = TextEditingController();
  String _query = '';

  /// Lista de datos simulados con DESCRIPCIONES agregadas
  final List<Map<String, String>> _items = const [
    {
      'id': 'sp-espatifilo',
      'nombre': 'Espatifilo',
      'asset': 'assets/species/espatifilo.png',
      'descripcion':
          'Conocida como Cuna de Moisés, es elegante, purifica el aire y requiere riego moderado.'
    },
    {
      'id': 'sp-suculenta',
      'nombre': 'Suculenta',
      'asset': 'assets/species/suculenta.png',
      'descripcion':
          'Planta carnosa que almacena agua. Ama la luz directa y requiere muy poco riego.'
    },
    {
      'id': 'sp-monstera',
      'nombre': 'Monstera',
      'asset': 'assets/species/monstera.png',
      'descripcion':
          'Famosa por sus hojas agujereadas (Costilla de Adán). Prefiere luz indirecta y humedad.'
    },
    {
      'id': 'sp-poto',
      'nombre': 'Poto',
      'asset': 'assets/species/poto.png',
      'descripcion':
          'Muy resistente y de crecimiento rápido. Ideal para principiantes y espacios interiores.'
    },
    {
      'id': 'sp-sansevieria',
      'nombre': 'Lengua de suegra',
      'asset': 'assets/species/lengua_de_suegra.png',
      'descripcion':
          'Indestructible y arquitectónica. Tolera poca luz y sequía. Excelente purificadora.'
    },
  ];

  @override
  void dispose() {
    _ctrlBuscar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lógica del buscador: Filtra la lista _items basándose en lo que escribe el usuario
    final visibles = _query.trim().isEmpty
        ? _items
        : _items.where((e) {
            final nombre = e['nombre']!.toLowerCase();
            final input = _query.toLowerCase();
            return nombre.contains(input);
          }).toList();

    return Scaffold(
      // Fondo base alineado al tema
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Catálogo de Plantas'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Buscador
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
              child: TextField(
                controller: _ctrlBuscar,
                // Al escribir, actualizamos el estado para filtrar la lista
                onChanged: (v) => setState(() => _query = v),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Buscar planta...',
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
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
                  Text('Top Plantas Comunes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          )),
                  const SizedBox(height: 6),
                  Text('Selecciona la especie que vas a cuidar',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54))),
                ],
              ),
            ),

            // Grid de resultados
            Expanded(
              child: visibles.isEmpty
                  ? Center(
                      child: Text(
                        'No se encontraron plantas con "$_query"',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: GridView.builder(
                        itemCount: visibles.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 3 / 4,
                        ),
                        itemBuilder: (_, i) {
                          final e = visibles[i];
                          return PlantCard(
                            title: e['nombre']!,
                            assetPath: e['asset']!,
                            // Opcional: Si quieres mostrar la descripción en la tarjeta,
                            // podrías pasarla aquí, pero por espacio es mejor solo pasarla al onTap.
                            onTap: () async {
                              // Creamos el objeto Especie con la descripción correcta
                              final esp = Especie(
                                id: e['id']!,
                                nombre: e['nombre']!,
                                descripcion: e[
                                    'descripcion']!, // ¡Aquí usamos la descripción!
                              );

                              // Abrimos Nombrar y esperamos la respuesta
                              final result =
                                  await Navigator.push<Map<String, dynamic>>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PaginaNombrar(
                                    especie: esp,
                                    assetPath: e['asset'],
                                  ),
                                ),
                              );

                              // Devolvemos el resultado a la pantalla anterior
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
            ),
          ],
        ),
      ),
    );
  }
}
