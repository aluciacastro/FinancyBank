// lib/models/user_model.dart
class UserModel {
  final String email;
  final String phone;
  final String documentId;
  final String birthDate;
  final String name;

  UserModel({
    required this.email,
    required this.phone,
    required this.documentId,
    required this.birthDate,
    required this.name,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      documentId: map['documentId'] ?? '',
      birthDate: map['birthDate'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String get dateOfBirth => birthDate; // Correctly return birthDate

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phone': phone,
      'documentId': documentId,
      'birthDate': birthDate,
      'name': name,
    };
  }
}
