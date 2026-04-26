class BookingModel {
  final String id;
  final String studentId;
  final String driverId;
  final String? pickupPointId;
  final int seatNumber;
  final DateTime bookingDate;
  final String status;
  final String? studentName;
  final String? pickupPointName;

  BookingModel({
    required this.id,
    required this.studentId,
    required this.driverId,
    this.pickupPointId,
    required this.seatNumber,
    required this.bookingDate,
    required this.status,
    this.studentName,
    this.pickupPointName,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      studentId: json['student_id'],
      driverId: json['driver_id'],
      pickupPointId: json['pickup_point_id'],
      seatNumber: json['seat_number'],
      bookingDate: DateTime.parse(json['booking_date']),
      status: json['status'],
      studentName: json['profiles']?['full_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'driver_id': driverId,
      'pickup_point_id': pickupPointId,
      'seat_number': seatNumber,
      'booking_date': bookingDate.toIso8601String(),
      'status': status,
    };
  }
}
