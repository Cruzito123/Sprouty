import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class ApiUrl {
  static Future<String> getBaseUrl() async {
    final info = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await info.androidInfo;

      // Detectar si es emulador
      if (android.isPhysicalDevice == false) {
        return "http://10.0.2.2:8000";
      }
    }

    // Celular real → usar la IP de tu PC
    return "http://192.168.0.16:8000";
  }
}
