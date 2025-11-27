import 'dart:convert';
import 'package:http/http.dart' as http;

/// ---------- Helpers de parseo seguros ----------
double _asDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  if (v is String) {
    // por si llega "27,1" en lugar de "27.1"
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

/// ---------- Modelo ----------
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
    // Aceptar maceta o maceta_id
    final maceta = j.containsKey('maceta_id') ? j['maceta_id'] : j['maceta'];

    // Aceptar fecha_lectura o fecha
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
      luzObjetivo: j['luz_objetivo'] == null ? null : _asDouble(j['luz_objetivo']),
      temperaturaObjetivo: _asDouble(j['temperatura_objetivo']),
    );
  }
}

/// ---------- Servicio API ----------
class Api {
  /// ⬇️ Ajusta esta BASE según tu entorno:
  static const base = 'http://192.168.1.9:8000';
  // Si usas emulador Android:
  // static const base = 'http://10.0.2.2:8000';

  static Future<LecturaSensor?> getUltimaLectura(int macetaId) async {
    final url = Uri.parse('$base/api/lecturas/ultima/$macetaId/');
    final res = await http.get(url).timeout(const Duration(seconds: 8));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data is Map<String, dynamic>) {
        return LecturaSensor.fromJson(data);
      }
      // Si el backend devuelve lista, toma el primer elemento
      if (data is List &&
          data.isNotEmpty &&
          data.first is Map<String, dynamic>) {
        return LecturaSensor.fromJson(data.first as Map<String, dynamic>);
      }
      throw const FormatException(
          'Respuesta 200 pero sin JSON válido de lectura');
    }

    // 204 = sin datos; 404 = maceta no encontrada; maneja como prefieras
    if (res.statusCode == 204 || res.statusCode == 404) return null;

    throw Exception(
      'Error HTTP ${res.statusCode} al obtener última lectura: ${res.body}',
    );
  }

  static Future<ConfigMaceta?> getConfigMaceta(int macetaId) async {
    final url = Uri.parse('$base/api/configuracion/$macetaId/');
    final res = await http.get(url).timeout(const Duration(seconds: 8));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data is Map<String, dynamic>) {
        return ConfigMaceta.fromJson(data);
      }
      throw const FormatException('Respuesta 200 pero sin JSON válido de ConfiguracionMaceta');
    }
    if (res.statusCode == 404) return null;

    throw Exception('Error HTTP ${res.statusCode} al obtener configuración: ${res.body}');
  }
}
