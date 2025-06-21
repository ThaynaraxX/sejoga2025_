class AccessPoint {
  final String ssid;
  final String bssid;
  final double signalLevel;

  AccessPoint({
    required this.ssid,
    required this.bssid,
    required this.signalLevel,
  });

  factory AccessPoint.fromJson(Map<String, dynamic> json) {
    return AccessPoint(
      ssid: json['ssid'],
      bssid: json['bssid'],
      signalLevel: json['signalLevel'].toDouble(),
    );
  }
}