// lib/models/user.dart
class User {
  final String id;
  final String name;
  final String role;
  final String email;
  final String phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'email': email,
      'phone_number': phoneNumber,
    };
  }
}