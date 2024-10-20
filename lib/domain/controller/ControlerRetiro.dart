// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControllerRetiro {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> retirar(double monto) async {
    try {
      if (monto <= 0) {
        return 'El monto debe ser mayor que cero.';
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDocument = prefs.getString('lastUserDocument');
      if (userDocument == null) {
        return 'No se encontró el documento del usuario en la caché.';
      }

      QuerySnapshot usuarioSnapshot = await _firestore
          .collection('loan_payments')
          .where('document', isEqualTo: userDocument)
          .limit(1)
          .get();

      if (usuarioSnapshot.docs.isEmpty) {
        return 'El usuario no fue encontrado.';
      }

      DocumentSnapshot usuarioData = usuarioSnapshot.docs.first;
      double usuarioBalance = usuarioData['balance'] as double? ?? 0.0;
      if (usuarioBalance < monto) {
        return 'Saldo insuficiente.';
      }

      double nuevoSaldoUsuario = usuarioBalance - monto;
      await _firestore.collection('loan_payments').doc(usuarioData.id).update({
        'balance': nuevoSaldoUsuario,
      });

      await _firestore.collection('retiros_historial').add({
        'document': userDocument,
        'movimiento': {
          'descripcion': 'Retiro de $monto',
          'fecha': FieldValue.serverTimestamp(),
          'monto': monto,
        }
      });

      return 'Retiro exitoso!';
    } catch (e) {
      print('Error durante el retiro: $e');
      return 'Error durante el retiro: $e';
    }
  }

  Future<String> obtenerNombreUsuario(String documentId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userDocs = await _firestore
          .collection('loan_payments')
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
