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
    String? photoUrl, 
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
        updateData['photoUrl'] = photoUrl; 
      }

      await _firestore.collection('users').doc(user.uid).update(updateData);

      if (user.email != email) {
        await user.verifyBeforeUpdateEmail(email); 
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
