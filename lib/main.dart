import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// TUS PANTALLAS
import 'package:sprouty_app/screens/pagina_bienvenida.dart';
import 'package:sprouty_app/screens/pagina_conf_wifi.dart';
import 'package:sprouty_app/screens/pagina_configurar_maceta.dart';
import 'package:sprouty_app/screens/pagina_dashboard.dart';
import 'package:sprouty_app/utils/especie.dart';
import 'package:sprouty_app/screens/pagina_Recomendations.dart';
import 'package:sprouty_app/screens/pagina_login.dart';
import 'package:sprouty_app/screens/pagina_registro.dart';
import 'package:sprouty_app/screens/pagina_notifications.dart';
import 'package:sprouty_app/screens/pagina_principal.dart';
import 'package:sprouty_app/screens/pagina_catalogo_tarjeta.dart';
import 'package:sprouty_app/screens/pagina_nombrar.dart';
import 'package:sprouty_app/screens/pagina_agregar_especie.dart';
import 'package:sprouty_app/screens/pagina_catalogo.dart';

// TUS UTILIDADES DE TEMA
import 'utils/tema_app.dart';
// NOTA: Ya no necesitamos importar theme_controller porque forzaremos el modo claro

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SproutyApp());
}

class SproutyApp extends StatelessWidget {
  const SproutyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPROUTY',

      // 🎨 CONFIGURACIÓN DE TEMA (SOLO CLARO)
      theme: AppTheme.light,

      // 🔒 BLOQUEO DE TEMA:
      // Esto asegura que la app siempre se vea crema/verde
      // incluso si el celular del usuario está en modo oscuro.
      themeMode: ThemeMode.light,

      // ⚠️ CORRECCIÓN DE RUTA INICIAL:
      // Tenías '/' pero no habías definido esa ruta en el mapa.
      // Lo cambié a '/login' para que no te de error de pantalla roja.
      initialRoute: '/login',

      routes: {
        '/bienvenida': (_) => const PaginaBienvenida(),
        '/login': (_) => const PaginaLogin(),
        '/config_wifi': (_) => const PaginaConfigWifi(),
        '/configurar': (_) => const PaginaConfigurarMaceta(),
        '/registro': (_) => const PaginaRegistro(),
        '/notifications': (_) => const PaginaNotifications(),
        '/principal': (_) => const PaginaPrincipal(),
        '/dashboard': (_) => const PaginaDashboard(),
        '/recomendaciones': (c) =>
            const PaginaRecomendations(species: 'general'),
        '/catalogo': (_) => const PaginaCatalogoTarjeta(),
        '/nombrar': (_) => const PaginaNombrar(
            especie: Especie(id: '', nombre: '', descripcion: '')),
        '/agregar_especie': (_) => const PaginaAgregarEspecie(
              nombrePlanta: '',
            ),
        '/catalogo_dashboard': (_) => const PaginaCatalogo(),
      },
    );
  }
}
