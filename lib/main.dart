import 'package:flutter/material.dart';
import 'package:sprouty_app/screens/pagina_bienvenida.dart';
import 'package:sprouty_app/screens/pagina_conf_wifi.dart';
import 'package:sprouty_app/screens/pagina_configurar_maceta.dart';
import 'package:sprouty_app/screens/pagina_dashboard.dart';
import 'package:sprouty_app/utils/especie.dart';
import 'utils/tema_app.dart';
import 'screens/pagina_Recomendations.dart';
import 'screens/pagina_login.dart';
import 'screens/pagina_registro.dart';
import 'screens/pagina_notifications.dart';
import 'screens/pagina_principal.dart';
import 'package:sprouty_app/screens/pagina_catalogo_tarjeta.dart';
import 'package:sprouty_app/screens/pagina_nombrar.dart';
import 'package:sprouty_app/screens/pagina_agregar_especie.dart';
import 'package:sprouty_app/screens/pagina_catalogo.dart';
import 'services/servicio_notificaciones.dart';

void main() async {
  // <--- Convertir a async
  WidgetsFlutterBinding.ensureInitialized(); // <--- Necesario para plugins
  await ServicioNotificaciones().init(); // <--- Inicializar servicio
  runApp(const SproutyApp());
}

class SproutyApp extends StatelessWidget {
  const SproutyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPROUTY',
      theme: construirTemaApp(),
      initialRoute: '/bienvenida',
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
