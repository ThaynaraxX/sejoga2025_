import 'package:flutter/services.dart';
import '../models/access_point.dart';

class WifiService {
  static const platform = MethodChannel('com.example.navegacao_indoor/wifi');

  Future<List<AccessPoint>> scanWifiNetworks() async {
    try {
      final List<dynamic> result = 
          await platform.invokeMethod('scanWifiNetworks');
      return result.map((ap) => AccessPoint.fromJson(ap)).toList();
    } on PlatformException catch (e) {
      print("Failed to scan WiFi: ${e.message}");
      return [];
    }
  }
}