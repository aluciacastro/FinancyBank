// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControllerRetiro {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> retirar(double monto) async {
    try {
      // Validar que el monto sea mayor que cero
      if (monto <= 0) {
        return 'El monto debe ser mayor que cero.';
      }

      // Obtener el documento del usuario desde SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDocument = prefs.getString('lastUserDocument');

      if (userDocument == null) {
        return 'No se encontró el documento del usuario en la caché.';
      }

      // Buscar el usuario por su número de documento en Firestore
      QuerySnapshot usuarioSnapshot = await _firestore
          .collection('users')
          .where('document', isEqualTo: userDocument)
          .limit(1)
          .get();

      if (usuarioSnapshot.docs.isEmpty) {
        return 'El usuario no fue encontrado.';
      }

      // Obtener el balance del usuario
      DocumentSnapshot usuarioData = usuarioSnapshot.docs.first;
      double usuarioBalance = usuarioData['balance'] as double? ?? 0.0;

      // Verificar si el usuario tiene suficiente saldo para retirar
      if (usuarioBalance < monto) {
        return 'Saldo insuficiente.';
      }

      // Calcular el nuevo saldo
      double nuevoSaldoUsuario = usuarioBalance - monto;

      // Actualizar el balance en Firestore
      await _firestore.collection('users').doc(usuarioData.id).update({
        'balance': nuevoSaldoUsuario,
      });

      return 'Retiro exitoso!';
    } catch (e) {
      print('Error durante el retiro: $e');
      return 'Error durante el retiro: $e';
    }
  }

  // Método para obtener el nombre del usuario
  Future<String> obtenerNombreUsuario(String documentId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userDocs = await _firestore
          .collection('users')
          .where('document', isEqualTo: documentId)
          .get();

      if (userDocs.docs.isNotEmpty) {
        return userDocs.docs.first.data()['name'] ?? 'Usuario desconocido';
      } else {
        return 'No se encontró el usuario';
      }
    } catch (e) {
      print('Error al obtener el nombre del usuario: $e');
      return 'Error al obtener el nombre del usuario';
    }
  }
}
