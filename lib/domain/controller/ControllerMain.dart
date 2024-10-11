import 'package:cloud_firestore/cloud_firestore.dart';

class ControllerMain {
  final String document;

  ControllerMain({required this.document});

  Future<Map<String, dynamic>> getUserData() async {
    if (document.isEmpty) {
      throw Exception('Documento no disponible');
    }

    try {
      // Consultamos Firebase para obtener el documento del usuario
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('document', isEqualTo: document)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

        // Si no existe el campo 'balance', lo inicializamos a 0.0
        if (!userData.containsKey('balance')) {
          await userSnapshot.docs.first.reference.update({'balance': 0.0});
          userData['balance'] = 0.0;
        }

        return userData;
      } else {
        throw Exception('Usuario no encontrado');
      }
    } catch (e) {
      throw Exception('Error al obtener datos del usuario: $e');
    }
  }
}
