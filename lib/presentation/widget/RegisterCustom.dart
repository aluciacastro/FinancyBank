import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
      child: const Text(
        'No tienes Cuenta? Regístrate',
        style: TextStyle(
          color: Color.fromARGB(255, 0, 140, 255),
          fontSize: 12,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
