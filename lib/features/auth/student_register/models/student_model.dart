class StudentModel {
  final String id;
  final String faculty;
  final int level;
  final String? gender;
  final String? phone;

  StudentModel({
    required this.id,
    required this.faculty,
    required this.level,
    this.gender,
    this.phone,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      faculty: json['faculty'],
      level: json['level'],
      gender: json['gender'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'faculty': faculty,
      'level': level,
    };
  }
}
