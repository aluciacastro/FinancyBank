// lib/domain/controller/ControllerLoan.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ControllerLoan {
  final FirebaseFirestore _firestore;

  ControllerLoan(this._firestore);

  Future<String> checkEligibility(String document) async {
    if (document.isEmpty) {
      return "Por favor ingrese su número de documento.";
    }

    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('document', isEqualTo: document)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;

        final data = userDoc.data() as Map<String, dynamic>?;

        // Verificar y crear campos por defecto si no existen
        await _ensureFieldsExist(userDoc);

        // Obtener los valores
        final hasActiveLoan = data?['hasActiveLoan'] ?? false;
        final isReported = data?['isReported'] ?? false;

        if (!hasActiveLoan && !isReported) {
          return "Eres apto para solicitar un nuevo préstamo.";
        } else {
          return "No eres apto para solicitar un préstamo.";
        }
      } else {
        return "Usuario no encontrado.";
      }
    } catch (e) {
      return "Error al verificar la elegibilidad: $e";
    }
  }

  Future<void> _ensureFieldsExist(DocumentSnapshot userDoc) async {
    final data = userDoc.data() as Map<String, dynamic>?;

    if (data != null) {
      // Crear campos por defecto
      if (!data.containsKey('hasActiveLoan')) {
        await userDoc.reference.set({'hasActiveLoan': false}, SetOptions(merge: true));
      }
      if (!data.containsKey('isReported')) {
        await userDoc.reference.set({'isReported': false}, SetOptions(merge: true));
      }
      if (!data.containsKey('debt')) {
        await userDoc.reference.set({'debt': 0}, SetOptions(merge: true));
      }
      // Agregar campos para almacenar cuotas e interés
      if (!data.containsKey('installments')) {
        await userDoc.reference.set({'installments': []}, SetOptions(merge: true));
      }
      if (!data.containsKey('interest')) {
        await userDoc.reference.set({'interest': 0.0}, SetOptions(merge: true));
      }
    }
  }

  Future<String> requestLoan(String document, double loanAmount, String interestType, List<Map<String, dynamic>> payments) async {
  try {
    QuerySnapshot userSnapshot = await _firestore
        .collection('users')
        .where('document', isEqualTo: document)
        .limit(1)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      final userDoc = userSnapshot.docs.first;
      final data = userDoc.data() as Map<String, dynamic>?;

      // Verificar campos
      await _ensureFieldsExist(userDoc);
      final hasActiveLoan = data?['hasActiveLoan'] ?? false;

      if (!hasActiveLoan) {
        // Crear el préstamo y establecer 'hasActiveLoan' a true
        await userDoc.reference.set({
          'hasActiveLoan': true,
          'loanAmount': loanAmount,
          'interestType': interestType,
          'debt': loanAmount // Asignamos la deuda inicial al monto del préstamo
        }, SetOptions(merge: true));

        // Aquí puedes guardar las cuotas
        await _storePayments(payments, userDoc.reference); // Método que almacena los pagos

        return "Préstamo solicitado exitosamente.";
      } else {
        return "Ya tienes un préstamo activo.";
      }
    } else {
      return "Usuario no encontrado.";
    }
  } catch (e) {
    return "Error al solicitar el préstamo: $e";
  }
}

// Método auxiliar para almacenar pagos
Future<void> _storePayments(List<Map<String, dynamic>> payments, DocumentReference userDocRef) async {
  final collectionRef = FirebaseFirestore.instance.collection('loan_payments');
  for (var payment in payments) {
    await collectionRef.add({
      'document': userDocRef.id,
      ...payment,
    });
  }
}
}