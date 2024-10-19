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

        await _ensureFieldsExist(userDoc);

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
      if (!data.containsKey('hasActiveLoan')) {
        await userDoc.reference.set({'hasActiveLoan': false}, SetOptions(merge: true));
      }
      if (!data.containsKey('isReported')) {
        await userDoc.reference.set({'isReported': false}, SetOptions(merge: true));
      }
      if (!data.containsKey('debt')) {
        await userDoc.reference.set({'debt': 0}, SetOptions(merge: true));
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

        await _ensureFieldsExist(userDoc);
        final hasActiveLoan = data?['hasActiveLoan'] ?? false;

        if (!hasActiveLoan) {
          await userDoc.reference.set({
            'hasActiveLoan': true,
            'loanAmount': loanAmount,
            'interestType': interestType,
            'debt': loanAmount // Inicializar deuda con el monto del préstamo
          }, SetOptions(merge: true));

          await _storePayments(payments, userDoc.reference);

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

  Future<void> _storePayments(List<Map<String, dynamic>> payments, DocumentReference userDocRef) async {
    await _firestore.collection('loan_payments').doc(userDocRef.id).set({
      'document': userDocRef.id,
      'loanStatus': 'active', // Estado del préstamo activo
      'payments': payments.map((payment) => {
        'cuota': payment['cuota']?.toStringAsFixed(2) ?? '0.00',
        'interes': payment['interes']?.toStringAsFixed(2) ?? '0.00',
        'amortizacion': payment['amortizacion']?.toStringAsFixed(2) ?? '0.00',
        'estado': false, // Pagos no realizados al inicio
      }).toList(),
    }, SetOptions(merge: true));
  }
}
