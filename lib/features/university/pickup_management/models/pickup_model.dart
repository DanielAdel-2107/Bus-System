import 'package:equatable/equatable.dart';

class PickupPoint extends Equatable {
  final String? id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? createdBy;
  final DateTime? createdAt;
  final String? driverName;

  const PickupPoint({
    this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.createdBy,
    this.createdAt,
    this.driverName,
  });

  bool get isAssigned => driverName != null && driverName!.isNotEmpty;

  @override
  List<Object?> get props =>
      [id, name, address, latitude, longitude, createdBy, createdAt, driverName];

  PickupPoint copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? createdBy,
    DateTime? createdAt,
    String? driverName,
  }) {
    return PickupPoint(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      driverName: driverName ?? this.driverName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      if (createdBy != null) 'created_by': createdBy,
    };
  }

  factory PickupPoint.fromMap(Map<String, dynamic> map) {
    return PickupPoint(
      id: map['id']?.toString(),
      name: map['name']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      createdBy: map['created_by']?.toString(),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      driverName: map['driver_name']?.toString(),
    );
  }
}
