// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class ControllerConsign {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> consignar(String documento, double monto) async {
    try {
      // Buscar el usuario en la base de datos usando el número de documento
      var userDoc = await _firestore.collection('usuarios').doc(documento).get();

      if (userDoc.exists) {
        // Actualizar el balance del usuario
        double currentBalance = userDoc['balance'] ?? 0.0;
        double newBalance = currentBalance + monto;

        await _firestore.collection('usuarios').doc(documento).update({'balance': newBalance});
        return true; // Consignación exitosa
      } else {
        return false; // Documento no encontrado
      }
    } catch (e) {
      print('Error durante la consignación: $e');
      return false; // Error en el proceso
    }
  }
}
