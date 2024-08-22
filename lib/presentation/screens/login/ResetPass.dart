import 'package:flutter/material.dart';
import 'package:cesarpay/presentation/screens/login/NewPass.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const String routname = 'ResetPassword';
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Extraer el token de la URL
    final Uri uri = ModalRoute.of(context)!.settings.arguments as Uri;
    final String? oobCode = uri.queryParameters['oobCode'];

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navegar a la pantalla de nueva contraseña con el token
            Navigator.pushNamed(
              context,
              NewPasswordScreen.routname,
              arguments: oobCode,
            );
          },
          child: const Text('Restablecer Contraseña'),
        ),
      ),
    );
  }
}
