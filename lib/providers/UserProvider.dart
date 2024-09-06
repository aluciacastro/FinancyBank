// lib/providers/user_provider.dart
import 'package:cesarpay/domain/controller/ControllerProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends StateNotifier<UserModel?> {
  UserProvider() : super(null) {
    loadUserData();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'email': email,
        'phone': phone,
        'name': name,
      });

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



