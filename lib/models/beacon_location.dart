class BeaconLocation {
  final String id;
  final String name;

  BeaconLocation({
    required this.id,
    required this.name,
  });

  factory BeaconLocation.fromJson(Map<String, dynamic> json) {
    return BeaconLocation(
      id: json['id'],
      name: json['name'],
    );
  }
}
