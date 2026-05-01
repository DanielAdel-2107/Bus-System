import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  final String id;
  final String fullName;
  final String? phone;
  final String? licenseNumber;
  final String? busNumber;
  final int? totalSeats;
  final bool isVerified;
  final String status; // 'pending', 'accepted', 'rejected'
  final String? lineName;
  final String? pickupPointId;
  final String? pickupPointName;
  final DateTime? createdAt;

  const Driver({
    required this.id,
    required this.fullName,
    this.phone,
    this.licenseNumber,
    this.busNumber,
    this.totalSeats,
    required this.isVerified,
    required this.status,
    this.lineName,
    this.pickupPointId,
    this.pickupPointName,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        phone,
        licenseNumber,
        busNumber,
        totalSeats,
        isVerified,
        status,
        lineName,
        pickupPointId,
        pickupPointName,
        createdAt,
      ];

  Driver copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? licenseNumber,
    String? busNumber,
    int? totalSeats,
    bool? isVerified,
    String? status,
    String? lineName,
    String? pickupPointId,
    String? pickupPointName,
    DateTime? createdAt,
  }) {
    return Driver(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      busNumber: busNumber ?? this.busNumber,
      totalSeats: totalSeats ?? this.totalSeats,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
      lineName: lineName ?? this.lineName,
      pickupPointId: pickupPointId ?? this.pickupPointId,
      pickupPointName: pickupPointName ?? this.pickupPointName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    // Handling nested join profile data or flat view data
    final profile = map['profiles'] as Map<String, dynamic>?;
    
    return Driver(
      id: map['id'] as String,
      fullName: profile?['full_name'] ?? map['full_name'] ?? 'Unknown Driver',
      phone: profile?['phone'] ?? map['phone'],
      licenseNumber: map['license_number'] as String?,
      busNumber: map['bus_number'] as String?,
      totalSeats: map['total_seats'] as int?,
      isVerified: map['is_verified'] as bool? ?? false,
      status: map['status'] as String? ?? 'pending',
      lineName: map['line_name'] as String?,
      pickupPointId: map['pickup_point_id'] as String?,
      pickupPointName: map['pickup_point_name'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'is_verified': isVerified,
      'status': status,
      if (licenseNumber != null) 'license_number': licenseNumber,
      if (busNumber != null) 'bus_number': busNumber,
      if (totalSeats != null) 'total_seats': totalSeats,
    };
  }
}
