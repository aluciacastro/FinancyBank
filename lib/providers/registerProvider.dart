// lib/providers/register_provider.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register({
    required String name,
    required String document,
    required String birthDate,
    required String email,
    required String password,
  }) async {
    try {
      // Registrar usuario en Firebase
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      notifyListeners();
    } catch (e) {
      rethrow; // Manejo de errores o mostrar mensajes de error
    }
  }
}
