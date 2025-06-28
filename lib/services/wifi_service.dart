import 'package:flutter/services.dart';
import '../models/access_point.dart';

class WifiService {
  static const MethodChannel _channel = MethodChannel('wifi_service');

  Future<List<AccessPoint>> scanWifiNetworks() async {
    try {
      final List result = await _channel.invokeMethod('scanWifi');
      return result.map((e) => AccessPoint.fromJson(Map<String, dynamic>.from(e))).toList();
    } on PlatformException catch (e) {
      print('Erro ao escanear Wi-Fi: ${e.message}');
      return [];
    }
  }
}
