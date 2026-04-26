class DriverModel {
  final String id;
  final String licenseNumber;
  final String busNumber;
  final int totalSeats;
  final String? pickupPointId;
  final bool isVerified;

  DriverModel({
    required this.id,
    required this.licenseNumber,
    required this.busNumber,
    required this.totalSeats,
    this.pickupPointId,
    this.isVerified = false,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      licenseNumber: json['license_number'],
      busNumber: json['bus_number'],
      totalSeats: json['total_seats'],
      pickupPointId: json['pickup_point_id'],
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'license_number': licenseNumber,
      'bus_number': busNumber,
      'total_seats': totalSeats,
      'pickup_point_id': pickupPointId,
      'is_verified': isVerified,
    };
  }
}
