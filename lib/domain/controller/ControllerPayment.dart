// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentController {
  final String document; // Documento del usuario
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PaymentController({required this.document});

  Future<List<Map<String, dynamic>>> getPayments() async {
    try {
      final paymentDoc = await _firestore.collection('loan_payments').doc(document).get();
      if (paymentDoc.exists) {
        final List<dynamic> payments = paymentDoc.data()?['payments'] ?? [];
        return payments.map<Map<String, dynamic>>((payment) => {
          'cuota': payment['cuota']?.toString() ?? '0.0', // Asegúrate de convertir a cadena
          'estado': payment['estado'] ?? false,
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
    final paymentDoc = await _firestore.collection('loan_payments').doc(document).get();

    if (!paymentDoc.exists) {
      print('Error: Documento de pago no encontrado.');
      return false;
    }

    // Buscar el índice del pago
    final paymentIndex = await _findPaymentIndex(payment);
    if (paymentIndex == -1) {
      print('Error: Pago no encontrado.'); // Verificar la razón
      return false;
    }

    // Cambiar el estado del pago a true
    List<dynamic> paymentsList = paymentDoc.data()?['payments'] ?? [];
    paymentsList[paymentIndex]['estado'] = true; // Cambiar el estado a true

    // Obtener el balance actual del usuario
    final userDoc = await _firestore.collection('users').doc(document).get();
    double userBalance = double.tryParse(userDoc.data()?['balance']?.toString() ?? '0.0') ?? 0.0;

    // Obtener el monto a pagar
    final amount = double.tryParse(payment['cuota']) ?? 0.0; // Convertir cuota a double

    // Verificar si hay saldo suficiente
    if (userBalance < amount) {
      print('Error: Saldo insuficiente.');
      return false;
    }

    // Restar del balance
    double newBalance = userBalance - amount;

    // Actualizar los documentos en Firestore
    await _firestore.collection('loan_payments').doc(document).update({
      'payments': paymentsList,
    });

    await _firestore.collection('users').doc(document).update({
      'balance': newBalance,
    });

    return true; // Pago procesado con éxito
  } catch (e) {
    print('Error durante el procesamiento del pago: $e');
    return false;
  }
}


  Future<int> _findPaymentIndex(Map<String, dynamic> payment) async {
  final paymentDoc = await _firestore.collection('loan_payments').doc(document).get();
  
  if (paymentDoc.exists) {
    final List<dynamic> paymentsList = paymentDoc.data()?['payments'] ?? [];
    
    // Buscar el índice del pago en la lista
    for (int i = 0; i < paymentsList.length; i++) {
      // Debugging
      print('Comparando cuota: ${paymentsList[i]['cuota']} con ${payment['cuota']}');
      print('Estado actual: ${paymentsList[i]['estado']}');
      print('Estado esperado: ${payment['estado']}');

      // Comparar la cuota como cadena
      if (paymentsList[i]['cuota'] == payment['cuota'] && paymentsList[i]['estado'] == false) {
        return i; // Devuelve el índice si lo encontró
      }
    }
  }
  
  return -1; // Devuelve -1 si no encontró el pago
}

}
