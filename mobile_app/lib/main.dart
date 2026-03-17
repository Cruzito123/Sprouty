import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Asegúrate de que este archivo exista (generado por flutterfire)

// SERVICIOS (Importante para inicializar notificaciones)
import 'package:sprouty_app/services/servicio_notificaciones.dart';

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

// PROVIDERS Y TEMA
import 'package:provider/provider.dart';
import 'package:sprouty_app/providers/theme_notifier.dart';
import 'utils/tema_app.dart';

void main() async {
  // 1. Asegurar vinculación con el motor de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializar FIREBASE con manejo de errores
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase inicializado correctamente");
  } catch (e) {
    print("❌ ERROR CRÍTICO: No se pudo inicializar Firebase: $e");
    // Aquí la app podría continuar, pero sin funciones de login/bd
  }

  // 3. Inicializar NOTIFICACIONES (Necesario para pedir permisos en Android 13+)
  try {
    await ServicioNotificaciones().init();
    print("✅ Servicio de Notificaciones listo");
  } catch (e) {
    print("⚠️ Error al cargar notificaciones: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: const SproutyApp(),
    ),
  );
}

class SproutyApp extends StatelessWidget {
  const SproutyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SPROUTY',

          // 🎨 CONFIGURACIÓN DE TEMA
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeNotifier.themeMode,

          // Define tu ruta inicial.
          // Si el usuario ya está logueado (Firebase Auth), podrías cambiar esto dinámicamente,
          // pero por ahora '/login' o '/bienvenida' está bien.
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

            // Rutas con parámetros por defecto (ten cuidado si necesitas pasar datos reales)
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
      },
    );
  }
}
