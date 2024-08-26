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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required String document,
    required String dateOfBirth,
  }) async {
    try {
      // Verificar si el documento ya está registrado en Firestore
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('document', isEqualTo: document)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        throw Exception('El número de documento ya está registrado.');
      }

      // Crea un nuevo usuario con Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guarda los datos adicionales en Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'document': document,
        'dateOfBirth': dateOfBirth,
        'email': email,
      });
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }
}
