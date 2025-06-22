import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/beacon_location.dart';
import '../models/access_point.dart';

class LocalizationService {
  Future<List<BeaconLocation>> loadBeaconLocations() async {
    final jsonStr = await rootBundle.loadString('assets/beacons.json');
    final List<dynamic> data = json.decode(jsonStr);
    return data.map((e) => BeaconLocation.fromJson(e)).toList();
  }

  Future<List<AccessPoint>> loadAccessPoints() async {
    final jsonStr = await rootBundle.loadString('assets/access_points.json');
    final List<dynamic> data = json.decode(jsonStr);
    return data.map((e) => AccessPoint.fromJson(e)).toList();
  }
}
