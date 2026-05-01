import 'package:latlong2/latlong.dart';

class PickupPoint {
  final String name;
  final LatLng position;
  final double distanceKm;
  final String time;
  final String busNumber;
  final String driverName;
  final bool isNearest;
  final String driverId;

  const PickupPoint({
    required this.name,
    required this.position,
    required this.distanceKm,
    required this.driverId,
    required this.time,
    required this.busNumber,
    required this.driverName,
    this.isNearest = false,
  });

  String get distanceText => "${distanceKm.toStringAsFixed(1)} km";

  PickupPoint copyWith({
    String? name,
    LatLng? position,
    String? driverId,
    double? distanceKm,
    String? time,
    String? busNumber,
    String? driverName,
    bool? isNearest,
  }) {
    return PickupPoint(
      name: name ?? this.name,
      position: position ?? this.position,
      distanceKm: distanceKm ?? this.distanceKm,
      time: time ?? this.time,
      driverId: driverId ?? this.driverId,
      busNumber: busNumber ?? this.busNumber,
      driverName: driverName ?? this.driverName,
      isNearest: isNearest ?? this.isNearest,
    );
  }
}