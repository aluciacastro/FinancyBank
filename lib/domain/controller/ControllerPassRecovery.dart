import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordRecoveryProvider with ChangeNotifier {
  Future<void> sendRecoveryEmail(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Navega a la pantalla de confirmación si deseas mostrar un mensaje de éxito
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/checkEmail'); // Usa una ruta adecuada
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar el enlace de recuperación: $e')),
      );
    }
  }

  Future<void> resetPassword(String newPassword, BuildContext context, String? oobCode) async {
    try {
      if (oobCode != null) {
        await FirebaseAuth.instance.confirmPasswordReset(
          code: oobCode,
          newPassword: newPassword,
        );
        // ignore: use_build_context_synchronously
        Navigator.popUntil(context, ModalRoute.withName('/'));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña actualizada exitosamente')),
        );
      } else {
        throw Exception('Token de recuperación no válido');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la contraseña: $e')),
      );
    }
  }
}
