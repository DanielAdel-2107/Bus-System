class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String image;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.image,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'image': image,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      };

  @override
  String toString() =>
      'User(id: $id, name: $fullName, email: $email, phone: $phoneNumber, image: $image, createdAt: $createdAt)';
}
