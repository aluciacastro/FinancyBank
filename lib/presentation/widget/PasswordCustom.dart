import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  //final VoidCallback onPressed;

  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/password');
        },
        child: const Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 140, 255),
            fontSize: 12,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
