// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentController {
  final String document; // Documento del usuario
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  PaymentController({required this.document});

 Future<List<Map<String, dynamic>>> getPayments(String document) async {
  try {
    // Buscar el documento con el número de documento como campo
    QuerySnapshot paymentSnapshot = await _firestore
        .collection('loan_payments')
        .where('document', isEqualTo: document)
        .limit(1)
        .get();

    if (paymentSnapshot.docs.isNotEmpty) {
      final paymentDoc = paymentSnapshot.docs.first;
      // Convertir correctamente los datos de 'loanPayments' a List<Map<String, dynamic>>
      final data = paymentDoc.data() as Map<String, dynamic>?;
      final List<Map<String, dynamic>> payments = List<Map<String, dynamic>>.from(data?['loanPayments'] ?? []);

      return payments.map<Map<String, dynamic>>((payment) {
        return {
          'cuota': payment['cuota']?.toString() ?? '0.00',
          'estado': payment['estado'] ?? false,
        };
      }).toList();
    } else {
      print('Error: Documento de pagos no encontrado.');
    }
  } catch (e) {
    print('Error al obtener los pagos: $e');
  }
  return [];
}
Future<bool> processPayment(Map<String, dynamic> payment) async {
  try {

    // Buscar el documento de pagos con el número de documento
    QuerySnapshot paymentSnapshot = await _firestore
        .collection('loan_payments')
        .where('document', isEqualTo: document)
        .limit(1)
        .get();

    if (paymentSnapshot.docs.isEmpty) {
      print('Error: Documento de pago no encontrado.');
      return false;
    }

    final paymentDoc = paymentSnapshot.docs.first;

    // Buscar el índice del pago
    final paymentIndex = await _findPaymentIndex(payment, paymentDoc);
    if (paymentIndex == -1) {
      print('Error: Pago no encontrado.');
      return false;
    }

    // Cambiar el estado del pago a true
    final data = paymentDoc.data() as Map<String, dynamic>; // Eliminamos el operador nulo
    List<dynamic> paymentsList = data['loanPayments'] ?? [];

    // Verificamos que 'paymentsList[paymentIndex]' sea un Map<String, dynamic>
    if (paymentsList[paymentIndex] is Map<String, dynamic>) {
      (paymentsList[paymentIndex] as Map<String, dynamic>)['estado'] = true;
    } else {
      print('Error: El formato del pago no es correcto.');
      return false;
    }

    // Obtener el balance actual del usuario
    final userSnapshot = await _firestore.collection('loan_payments').where('document', isEqualTo: document).limit(1).get();
    if (userSnapshot.docs.isEmpty) {
      print('Error: Usuario no encontrado.');
      return false;
    }
    final userDoc = userSnapshot.docs.first;
    double userBalance = double.tryParse(userDoc.data()['balance']?.toString() ?? '0.0') ?? 0.0;

    // Obtener el monto a pagar
    final amount = double.tryParse(payment['cuota']) ?? 0.0;

    // Verificar si hay saldo suficiente
    if (userBalance < amount) {
      print('Error: Saldo insuficiente.');
      return false;
    }

    // Restar del balance
    double newBalance = userBalance - amount;

    // Actualizar los documentos en Firestore
    await _firestore.collection('loan_payments').doc(paymentDoc.id).update({
      'loanPayments': paymentsList,
    });

    await _firestore.collection('loan_payments').doc(paymentDoc.id).update({
      'balance': newBalance,
    });

    return true; // Pago procesado con éxito
  } catch (e) {
    print('Error durante el procesamiento del pago: $e');
    return false;
  }
}

Future<int> _findPaymentIndex(Map<String, dynamic> payment, DocumentSnapshot paymentDoc) async {
  final data = paymentDoc.data() as Map<String, dynamic>; // Eliminamos el operador nulo
  final List<dynamic> paymentsList = data['loanPayments'] ?? [];

  // Buscar el índice del pago en la lista
  for (int i = 0; i < paymentsList.length; i++) {
    final paymentMap = paymentsList[i] as Map<String, dynamic>; // Cast adecuado

    // Debugging
    print('Comparando cuota: ${paymentMap['cuota']} con ${payment['cuota']}');
    print('Estado actual: ${paymentMap['estado']}');
    print('Estado esperado: ${payment['estado']}');

    // Comparar la cuota como cadena
    if (paymentMap['cuota'] == payment['cuota'] && paymentMap['estado'] == false) {
      return i; // Devuelve el índice si lo encontró
    }
  }

  return -1; // Devuelve -1 si no encontró el pago
}

}
