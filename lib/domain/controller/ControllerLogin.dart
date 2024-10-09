import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginLogic {
  final LocalAuthentication auth = LocalAuthentication();

  // Método para iniciar sesión con documento y contraseña
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

        // Guardar el documento en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('lastUserDocument', document);
      } else {
        throw Exception('Usuario no encontrado con ese número de documento.');
      }
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  // Método para autenticar al usuario con huella digital
  Future<bool> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      // Verificar si hay un documento almacenado
      final prefs = await SharedPreferences.getInstance();
      final lastUserDocument = prefs.getString('lastUserDocument');

      // Si no hay documento, no se puede autenticar
      if (lastUserDocument == null) {
        throw Exception('No hay documento almacenado. No se puede autenticar.');
      }

      authenticated = await auth.authenticate(
        localizedReason: 'Use su huella digital para autenticarse',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      // Si se autentica correctamente
      if (authenticated) {
        return true; // Retorna true si la autenticación fue exitosa
      }
    } catch (e) {
      throw Exception('Error con la autenticación biométrica: $e');
    }
    return false; // Retorna false si no está autenticado
  }

  // Verifica si el dispositivo puede usar la autenticación biométrica
  Future<bool> canCheckBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      throw Exception('No se pudo verificar la biometría: $e');
    }
    return canCheckBiometrics;
  }

  // Método para cargar el último documento utilizado
  Future<String?> loadLastUserDocument() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastUserDocument');
  }
}
