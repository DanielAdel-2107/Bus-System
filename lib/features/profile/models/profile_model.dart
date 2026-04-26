class ProfileModel {
  final String id;
  final String name;
  final String phone;
  final String role;
  final String imageUrl;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    this.role = 'user',
    this.imageUrl = '',
  });

  ProfileModel copyWith({
    String? name,
    String? phone,
    String? role,
    String? imageUrl,
  }) {
    return ProfileModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
