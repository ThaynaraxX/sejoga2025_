import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sejoga2025_certo/models/beacon_location.dart';
import '../models/access_point.dart';

class LocalizationService {
  Future<List<BeaconLocation>> loadBeaconLocations() async {
    final String response = await rootBundle.loadString('assets/beacon_map.json');
    final List<dynamic> jsonData = json.decode(response);
    return jsonData.map((json) => BeaconLocation.fromJson(json)).toList();
  }

  Future<List<AccessPoint>> loadAccessPoints() async {
    final String response = await rootBundle.loadString('assets/wifi_map.json');
    final List<dynamic> jsonData = json.decode(response);
    return jsonData.map((json) => AccessPoint.fromJson(json)).toList();
  }
}