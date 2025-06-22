class AccessPoint {
  final String ssid;
  final String bssid;
  final int signalLevel;

  AccessPoint({
    required this.ssid,
    required this.bssid,
    required this.signalLevel,
  });

  factory AccessPoint.fromJson(Map<String, dynamic> json) {
    return AccessPoint(
      ssid: json['ssid'] as String,
      bssid: json['bssid'] as String,
      signalLevel: json['signalLevel'] as int,
    );
  }
}