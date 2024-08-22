import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginLogic {
  Future<void> loginWithDocument({
    required String document,
    required String password,
  }) async {
    try {
      // Buscar en Firestore el correo asociado al número de documento
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('document', isEqualTo: document)
          .limit(1)
          .get();

      // Si el usuario existe
      if (userSnapshot.docs.isNotEmpty) {
        // Obtener el email del usuario
        String email = userSnapshot.docs.first['email'];

        // Autenticar al usuario con Firebase usando el correo y la contraseña
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Si la autenticación es exitosa, aquí podrías navegar a la pantalla principal
      } else {
        throw Exception('Usuario no encontrado con ese número de documento.');
      }
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }
}
