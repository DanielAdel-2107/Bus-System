class PassengerModel {
  final String id;
  final String name;
  final int seatNumber;
  final String gender;
  final String phoneNumber;

  const PassengerModel({
    required this.id,
    required this.name,
    required this.seatNumber,
    required this.gender, // 'male' or 'female'
    required this.phoneNumber,
  });

  bool get isMale => gender.toLowerCase() == 'male';
}
