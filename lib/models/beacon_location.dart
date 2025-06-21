class BeaconLocation {
  final String id;
  final String name;
  final String description;
  final double xPosition;
  final double yPosition;

  BeaconLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.xPosition,
    required this.yPosition,
  });

  factory BeaconLocation.fromJson(Map<String, dynamic> json) {
    return BeaconLocation(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      xPosition: json['xPosition'].toDouble(),
      yPosition: json['yPosition'].toDouble(),
    );
  }
}