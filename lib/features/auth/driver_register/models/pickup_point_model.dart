class PickupPointModel {
  final String id;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;

  PickupPointModel({
    required this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
  });

  factory PickupPointModel.fromJson(Map<String, dynamic> json) {
    return PickupPointModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
