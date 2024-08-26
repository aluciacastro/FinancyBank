// lib/providers/user_provider.dart
import 'package:cesarpay/domain/controller/ControllerProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _user;

  UserModel? get user => _user;

  get documentController => null;

  get dateController => null;

  get nameController => null;

  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      _user = UserModel.fromMap(doc.data() ?? {});
      notifyListeners();
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
        await user
            .verifyBeforeUpdateEmail(email); // Usa el nuevo método recomendado
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
