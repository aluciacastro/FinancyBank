import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String documentId;
  final String dateOfBirth;
  final String email;
  final String phone;
  final String? photoUrl; // Agrega photoUrl

  UserModel({
    required this.name,
    required this.documentId,
    required this.dateOfBirth,
    required this.email,
    required this.phone,
    this.photoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      documentId: map['documentId'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoUrl: map['photoUrl'], // Asegúrate de que se maneje correctamente
    );
  }
}


class UserNotifier extends StateNotifier<UserModel?> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserNotifier() : super(null);

  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      state = UserModel.fromMap(doc.data() ?? {});
    }
  }

    Future<void> updateUserData({
    required String email,
    required String phone,
    required String name,
    required String document,
    required String dateOfBirth,
    String? photoUrl, // Agregado parámetro photoUrl
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      final updateData = {
        'email': email,
        'phone': phone,
        'name': name,
        'documentId': document,
        'dateOfBirth': dateOfBirth,
      };

      if (photoUrl != null) {
        updateData['photoUrl'] = photoUrl; // Incluye photoUrl solo si está disponible
      }

      await _firestore.collection('users').doc(user.uid).update(updateData);

      if (user.email != email) {
        await user.verifyBeforeUpdateEmail(email); // Usa el nuevo método recomendado
        await sendEmailChangeNotification();
      }
    }
  }


  Future<void> sendEmailChangeNotification() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }
}
