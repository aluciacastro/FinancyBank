import 'package:cloud_firestore/cloud_firestore.dart';

class ControllerMain {
  final String document;

  ControllerMain({required this.document});

  Future<Map<String, dynamic>> getUserData() async {
    if (document.isEmpty) {
      throw Exception('Documento no disponible');
    }

    try {
      // Consultamos Firebase para obtener el documento del usuario en la colección 'users'
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('document', isEqualTo: document)
          .limit(1)
          .get();

      // Consultamos Firebase para obtener el documento del balance en la colección 'loan_payments'
      QuerySnapshot loanSnapshot = await FirebaseFirestore.instance
          .collection('loan_payments')
          .where('document', isEqualTo: document)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty && loanSnapshot.docs.isNotEmpty) {
        // Datos de la colección 'users' (nombre y foto)
        final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
        final name = userData['name'] ?? 'Nombre no disponible';
        final photoUrl = userData['photoUrl'];

        // Datos de la colección 'loan_payments' (balance)
        final loanData = loanSnapshot.docs.first.data() as Map<String, dynamic>;
        final balance = loanData['balance'] ?? 0.0;

        // Retornar un Map combinado con todos los datos que necesitas
        return {
          'name': name,
          'photoUrl': photoUrl,
          'balance': balance,
        };
      } else {
        throw Exception('Usuario o balance no encontrado');
      }
    } catch (e) {
      throw Exception('Error al obtener datos del usuario: $e');
    }
  }
}
