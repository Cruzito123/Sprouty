// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/colores_app.dart';
import '../utils/api_url.dart';

class PaginaSettings extends StatefulWidget {
  const PaginaSettings({super.key});

  @override
  State<PaginaSettings> createState() => _PaginaSettingsState();
}

class _PaginaSettingsState extends State<PaginaSettings> {
  // Datos
  String _nombre = "Cargando...";
  String _email = "Cargando...";
  String? _fotoUrlBackend;
  int? _userId;

  // UI
  bool _notifOn = true;
  bool _subiendoFoto = false;
  File? _imagenLocal;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  // ----------------------------------------------------------------
  // 1. CARGAR DATOS (CORREGIDO PARA LA RUTA DE FOTO)
  // ----------------------------------------------------------------
  Future<void> _cargarDatosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id');

    if (_userId == null) return;

    try {
      final baseUrl = await ApiUrl.getBaseUrl();
      final url = Uri.parse('$baseUrl/api/perfil/$_userId/');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Datos RAW del backend: $data"); // Debug

        setState(() {
          _nombre = data['nombre'] ?? 'Sin Nombre';
          _email = data['email'] ?? 'Sin Email';

          // --- 🛠️ CORRECCIÓN DE LA RUTA DE LA FOTO 🛠️ ---
          String? rawFoto = data['foto_perfil'];

          if (rawFoto != null && rawFoto.isNotEmpty) {
            // 1. Si ya es una URL completa (http...), la usamos tal cual
            if (rawFoto.startsWith('http')) {
              _fotoUrlBackend = rawFoto;
            }
            // 2. Si es una ruta relativa o solo nombre de archivo
            else {
              // Aseguramos que empiece con /
              String path = rawFoto.startsWith('/') ? rawFoto : '/$rawFoto';

              // ⚠️ TRUCO CLAVE: Si no dice "/media", se lo agregamos
              // Django suele guardar en /media/foto.jpg, pero si tu BD solo tiene "foto.jpg", fallará.
              if (!path.startsWith('/media')) {
                path = '/media$path';
              }

              _fotoUrlBackend = '$baseUrl$path';
            }
          } else {
            _fotoUrlBackend = null;
          }

          print("URL FINAL CORREGIDA: $_fotoUrlBackend");
        });
      }
    } catch (e) {
      print("Error cargando perfil: $e");
    }
  }

  // ----------------------------------------------------------------
  // 2. SUBIR FOTO AUTOMÁTICA
  // ----------------------------------------------------------------
  Future<void> _seleccionarFoto() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.gallery);

    if (foto != null) {
      File imagenFile = File(foto.path);

      setState(() {
        _imagenLocal = imagenFile;
        _subiendoFoto = true;
      });

      _subirFotoAlServidor(imagenFile);
    }
  }

  Future<void> _subirFotoAlServidor(File imagen) async {
    if (_userId == null) return;

    try {
      final baseUrl = await ApiUrl.getBaseUrl();
      final url = Uri.parse('$baseUrl/api/perfil/$_userId/');

      var request = http.MultipartRequest('PUT', url);
      request.files
          .add(await http.MultipartFile.fromPath('foto_perfil', imagen.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto actualizada 📸')),
        );
        _cargarDatosUsuario(); // Recargar para obtener la nueva URL
      } else {
        setState(() => _imagenLocal = null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al subir')),
        );
      }
    } catch (e) {
      print("Error subiendo foto: $e");
      setState(() => _imagenLocal = null);
    } finally {
      setState(() => _subiendoFoto = false);
    }
  }

  // ----------------------------------------------------------------
  // 3. ACTUALIZAR TEXTO
  // ----------------------------------------------------------------
  Future<void> _actualizarCampo(String campo, String valor) async {
    if (_userId == null) return;
    try {
      final baseUrl = await ApiUrl.getBaseUrl();
      final url = Uri.parse('$baseUrl/api/perfil/$_userId/');

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({campo: valor}),
      );

      if (response.statusCode == 200) {
        _cargarDatosUsuario();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guardado ✅')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar')),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _enviarCambioPassword(String anterior, String nueva) async {
    if (_userId == null) return;
    try {
      final baseUrl = await ApiUrl.getBaseUrl();
      final url = Uri.parse('$baseUrl/api/cambiar-password/$_userId/');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'password_anterior': anterior, 'password_nueva': nueva}),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña actualizada 🔒')),
        );
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'Error')),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  // ----------------------------------------------------------------
  // UI Y WIDGETS
  // ----------------------------------------------------------------

  InputDecoration _inputDeco(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF5F7F6),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: kPrimario, width: 1.5)),
    );
  }

  void _mostrarDialogoEditar(
      String titulo, String campoBackend, String valorActual, IconData icono) {
    final controller = TextEditingController(text: valorActual);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: kPrimario.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icono, color: kPrimario, size: 28),
              ),
              const SizedBox(height: 16),
              Text('Editar $titulo',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(height: 24),
              TextField(
                controller: controller,
                autofocus: true,
                style: const TextStyle(fontSize: 16),
                decoration: _inputDeco('Escribe aquí...', Icons.edit_outlined),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Cancelar',
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _actualizarCampo(
                          campoBackend, controller.text.trim()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimario,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Guardar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoPassword() {
    final passAntiguaCtrl = TextEditingController();
    final passNuevaCtrl = TextEditingController();
    bool oculto = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateSB) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.lock_reset_rounded,
                        color: Colors.orange, size: 28),
                  ),
                  const SizedBox(height: 16),
                  const Text('Nueva Contraseña',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const SizedBox(height: 24),
                  TextField(
                      controller: passAntiguaCtrl,
                      obscureText: oculto,
                      decoration:
                          _inputDeco('Contraseña actual', Icons.lock_outline)),
                  const SizedBox(height: 12),
                  TextField(
                      controller: passNuevaCtrl,
                      obscureText: oculto,
                      decoration: _inputDeco('Nueva contraseña', Icons.key)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => setStateSB(() => oculto = !oculto),
                      child: Text(
                          oculto ? 'Mostrar caracteres' : 'Ocultar caracteres',
                          style: const TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _enviarCambioPassword(
                          passAntiguaCtrl.text, passNuevaCtrl.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimario,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Guardar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.grey)),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    final colorFondoCard = Theme.of(context).cardColor;

    // --- DECISIÓN DE FOTO ---
    ImageProvider? imagenProvider;

    if (_imagenLocal != null) {
      imagenProvider = FileImage(_imagenLocal!);
    } else if (_fotoUrlBackend != null) {
      imagenProvider = NetworkImage(_fotoUrlBackend!);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Ajustes',
                style: texto.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Tarjeta Perfil
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorFondoCard,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // CÍRCULO DEL AVATAR
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: kPrimario.withOpacity(0.1),
                        backgroundImage: imagenProvider,
                        // Mostrar icono solo si NO hay imagen
                        child: (imagenProvider == null)
                            ? const Icon(Icons.person,
                                size: 45, color: kPrimario)
                            : null,
                      ),

                      // SPINNER DE CARGA
                      if (_subiendoFoto)
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.black38, shape: BoxShape.circle),
                            child: const Padding(
                              padding: EdgeInsets.all(25.0),
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            ),
                          ),
                        ),

                      // BOTÓN DE CÁMARA
                      GestureDetector(
                        onTap: _subiendoFoto ? null : _seleccionarFoto,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              color: kPrimario, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 18),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  _itemDato(
                      'Nombre',
                      _nombre,
                      () => _mostrarDialogoEditar(
                          'Nombre', 'nombre', _nombre, Icons.person_outline)),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1)),
                  _itemDato(
                      'Correo',
                      _email,
                      () => _mostrarDialogoEditar(
                          'Correo', 'email', _email, Icons.email_outlined)),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1)),
                  _itemDato('Contraseña', '••••••••', _mostrarDialogoPassword),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Preferencias
            Text('Preferencias',
                style:
                    texto.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                  color: colorFondoCard,
                  borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Notificaciones',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    activeColor: kPrimario,
                    value: _notifOn,
                    onChanged: (v) => setState(() => _notifOn = v),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    secondary: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.notifications_outlined,
                          color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            TextButton(
              onPressed: _cerrarSesion,
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red.withOpacity(0.08),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, size: 22),
                  SizedBox(width: 8),
                  Text('Cerrar Sesión',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _itemDato(String etiqueta, String valor, VoidCallback alEditar) {
    return InkWell(
      onTap: alEditar,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(etiqueta,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(valor,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87)),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.edit_rounded, size: 18, color: kPrimario),
            )
          ],
        ),
      ),
    );
  }
}
