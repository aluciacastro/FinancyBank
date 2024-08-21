// lib/presentation/screens/password_recovery_screen.dart
import 'package:cesarpay/presentation/validators/FormValidatorRegister.dart';
import 'package:cesarpay/presentation/widget/ButtonCustom.dart';
import 'package:cesarpay/presentation/widget/Inputs.dart';
import 'package:cesarpay/presentation/widget/Logo.dart';
import 'package:cesarpay/presentation/widget/TextCustom.dart';
import 'package:cesarpay/presentation/widget/Waves.dart';
import 'package:flutter/material.dart';


class PasswordRecoveryScreen extends StatelessWidget {
  static const String routname = 'Password';
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Stack(
        children: [
          const WaveBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CesarPayLogo(
                    logoPath: 'assets/images/pass.png',
                  ),
                  const SizedBox(height: 5),
                  const CesarPayTitle(topPadding: 5, title: 'Contraseña olvidada',),
                  const SizedBox(height: 40),
                  const CustomTextField(
                    label: 'Correo Electrónico',
                    icon: Icons.email,
                    maxLength: 50,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    validator: FormValidator.validateEmail,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Recuperar Contraseña',
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        // Logica del boton
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
