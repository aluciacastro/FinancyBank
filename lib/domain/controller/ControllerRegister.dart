import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void dispose() {
    passwordController.dispose();
    nameController.dispose();
    documentController.dispose();
    dateController.dispose();
    emailController.dispose();
  }
}

class RegisterLogic {
  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required String document,
    required String dateOfBirth,
  }) async {
    try {
      // Crea un nuevo usuario con Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guarda los datos adicionales en Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'document': document,
        'dateOfBirth': dateOfBirth,
        'email': email,
        'password': password,
      });
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }
}