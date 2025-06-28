class AccessPoint {
  final String ssid;
  final String bssid;
  final int signalLevel;
  final String? room;

  AccessPoint({
    required this.ssid,
    required this.bssid,
    required this.signalLevel,
    this.room,
  });

  factory AccessPoint.fromJson(Map<String, dynamic> json) {
    return AccessPoint(
      ssid: json['ssid'] ?? '',
      bssid: json['bssid'] ?? '',
      signalLevel: json['signalLevel'] ?? -100,
      room: json['room'], // já está como String? (nullable)
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'ssid': ssid,
      'bssid': bssid,
      'signalLevel': signalLevel,
    };

    if (room != null) {
      data['room'] = room!;
    }

    return data;
  }
}