// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class ControllerConsign {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> consignar(String consignanteDoc, String destinatarioDoc, double monto) async {
    try {
      // Buscar el consignante por su número de documento
      QuerySnapshot consignanteSnapshot = await _firestore
          .collection('users')
          .where('document', isEqualTo: consignanteDoc)
          .limit(1)
          .get();
      
      if (consignanteSnapshot.docs.isEmpty) {
        return 'El consignante no fue encontrado.';
      }

      // Obtener el balance del consignante
      DocumentSnapshot consignanteData = consignanteSnapshot.docs.first;
      double consignanteBalance = consignanteData['balance'] as double? ?? 0.0;

      // Buscar el destinatario por su número de documento
      QuerySnapshot destinatarioSnapshot = await _firestore
          .collection('users')
          .where('document', isEqualTo: destinatarioDoc)
          .limit(1)
          .get();

      if (destinatarioSnapshot.docs.isEmpty) {
        return 'El destinatario no fue encontrado.';
      }

      // Obtener el balance del destinatario
      DocumentSnapshot destinatarioData = destinatarioSnapshot.docs.first;
      double destinatarioBalance = destinatarioData['balance'] as double? ?? 0.0;

      // Verificar si el consignante tiene suficiente saldo
      if (consignanteBalance < monto) {
        return 'Saldo insuficiente.';
      }

      // Actualizar balances
      double nuevoSaldoConsignante = consignanteBalance - monto;
      double nuevoSaldoDestinatario = destinatarioBalance + monto;

      // Realizar las actualizaciones en Firestore
      await _firestore.collection('users').doc(consignanteData.id).update({
        'balance': nuevoSaldoConsignante,
      });

      await _firestore.collection('users').doc(destinatarioData.id).update({
        'balance': nuevoSaldoDestinatario,
      });

      return 'Consignación exitosa! Nuevo saldo del consignante: \$${nuevoSaldoConsignante.toStringAsFixed(2)}';
    } catch (e) {
      print('Error durante la consignación: $e');
      return 'Error durante la consignación: $e';
    }
  }
}