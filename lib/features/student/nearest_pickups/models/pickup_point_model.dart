// pickup_point_model.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickupPointModel {
  final String id;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;
  LatLng get position => LatLng(latitude, longitude);

  // من الـ join مع drivers + profiles
  final String? busNumber;
  final String? driverName;
  final String? driverId;

  // هتتحسب ديناميكيًا أو تجي من الـ backend
  final double? distanceKm;
  final String? estimatedTime; // "07:20 AM" أو "in 12 min"

  final bool isNearest; // هتتحدد في الـ UI حسب المسافة

  PickupPointModel({
    required this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    this.busNumber,
    this.driverName,
    this.driverId,
    this.distanceKm,
    this.estimatedTime,
    this.isNearest = false,
  });

  String get distanceText => distanceKm != null ? "${distanceKm!.toStringAsFixed(1)} km" : "—";

  // Factory من Supabase row
  factory PickupPointModel.fromJson(Map<String, dynamic> json) {
    return PickupPointModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      busNumber: json['bus_number'] as String?,
      driverName: json['full_name'] as String?, // من profiles
      driverId: json['driver_id'] as String?,
      // distanceKm & estimatedTime → هتتحسب بعدين
    );
  }
}