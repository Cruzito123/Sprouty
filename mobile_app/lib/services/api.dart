import 'dart:convert';
import 'dart:io'; // Necesario para Platform
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart'; // Necesario para detectar emulador

// --------------------------------------------------------------------------
// 1. CLASE API URL (Tu lógica para detectar IP dinámica)
// --------------------------------------------------------------------------
class ApiUrl {
  static Future<String> getBaseUrl() async {
    // Si es Android, verificamos si es emulador
    if (Platform.isAndroid) {
      final info = DeviceInfoPlugin();
      final android = await info.androidInfo;

      // Si NO es un dispositivo físico, es el emulador --> Usar 10.0.2.2
      if (!android.isPhysicalDevice) {
        return "http://10.0.2.2:8000";
      }
    }

    // Si es iOS o un Android físico --> Usar la IP de tu PC
    // OJO: Asegúrate que esta sea la IP actual de tu computadora (ipconfig/ifconfig)
    return "http://192.168.1.156:8000";
  }
}

// --------------------------------------------------------------------------
// 2. HELPERS DE PARSEO (Sin cambios, están perfectos)
// --------------------------------------------------------------------------
double _asDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  if (v is String) {
    return double.tryParse(v.replaceAll(',', '.')) ?? 0.0;
  }
  throw FormatException(
      'No se puede convertir a double: $v (${v.runtimeType})');
}

int _asInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  throw FormatException('No se puede convertir a int: $v (${v.runtimeType})');
}

// --------------------------------------------------------------------------
// 3. MODELOS (LecturaSensor y ConfigMaceta)
// --------------------------------------------------------------------------
class LecturaSensor {
  final double temperatura;
  final double humedad;
  final double? luz;
  final int macetaId;
  final DateTime fecha;

  LecturaSensor({
    required this.temperatura,
    required this.humedad,
    this.luz,
    required this.macetaId,
    required this.fecha,
  });

  factory LecturaSensor.fromJson(Map<String, dynamic> j) {
    final maceta = j.containsKey('maceta_id') ? j['maceta_id'] : j['maceta'];
    final fechaStr = (j['fecha_lectura'] ?? j['fecha'])?.toString();

    return LecturaSensor(
      temperatura: _asDouble(j['temperatura']),
      humedad: _asDouble(j['humedad']),
      luz: j['luz'] == null ? null : _asDouble(j['luz']),
      macetaId: _asInt(maceta),
      fecha: fechaStr != null ? DateTime.parse(fechaStr) : DateTime.now(),
    );
  }
}

class ConfigMaceta {
  final int macetaId;
  final double humedadObjetivo;
  final double? luzObjetivo;
  final double temperaturaObjetivo;

  ConfigMaceta({
    required this.macetaId,
    required this.humedadObjetivo,
    required this.luzObjetivo,
    required this.temperaturaObjetivo,
  });

  factory ConfigMaceta.fromJson(Map<String, dynamic> j) {
    final maceta = j.containsKey('maceta_id') ? j['maceta_id'] : j['maceta'];
    return ConfigMaceta(
      macetaId: _asInt(maceta),
      humedadObjetivo: _asDouble(j['humedad_objetivo']),
      luzObjetivo:
          j['luz_objetivo'] == null ? null : _asDouble(j['luz_objetivo']),
      temperaturaObjetivo: _asDouble(j['temperatura_objetivo']),
    );
  }
}

// --------------------------------------------------------------------------
// 4. SERVICIO API (Aquí integramos ApiUrl)
// --------------------------------------------------------------------------
class Api {
  // Ya NO usamos una constante estática, porque la URL cambia dinámicamente.
  // static const base = ... (ELIMINADO)

  static Future<LecturaSensor?> getUltimaLectura(int macetaId) async {
    // 1. Obtenemos la URL correcta según el dispositivo
    final String base = await ApiUrl.getBaseUrl();

    // 2. Construimos la URI
    final url = Uri.parse('$base/api/lecturas/ultima/$macetaId/');

    print("📡 Consultando API en: $url"); // Log útil para depurar

    try {
      final res = await http.get(url).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is Map<String, dynamic>) {
          return LecturaSensor.fromJson(data);
        }
        if (data is List &&
            data.isNotEmpty &&
            data.first is Map<String, dynamic>) {
          return LecturaSensor.fromJson(data.first as Map<String, dynamic>);
        }
        throw const FormatException('Respuesta 200 pero sin JSON válido');
      }

      if (res.statusCode == 204 || res.statusCode == 404) return null;

      throw Exception('Error HTTP ${res.statusCode}: ${res.body}');
    } catch (e) {
      // Re-lanzamos el error para que la UI (Dashboard) muestre el mensaje rojo
      rethrow;
    }
  }

  static Future<ConfigMaceta?> getConfigMaceta(int macetaId) async {
    // 1. Obtenemos la URL correcta
    final String base = await ApiUrl.getBaseUrl();
    final url = Uri.parse('$base/api/configuracion/$macetaId/');

    try {
      final res = await http.get(url).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is Map<String, dynamic>) {
          return ConfigMaceta.fromJson(data);
        }
        throw const FormatException('JSON inválido en ConfigMaceta');
      }
      if (res.statusCode == 404) return null;

      throw Exception('Error HTTP ${res.statusCode}');
    } catch (e) {
      rethrow;
    }
  }
}
