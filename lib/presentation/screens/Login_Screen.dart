// lib/presentation/screens/login_screen.dart
import 'package:cesarpay/presentation/validators/FormValidatorRegister.dart';
import 'package:cesarpay/presentation/widget/ButtonCustom.dart';
import 'package:cesarpay/presentation/widget/Inputs.dart';
import 'package:cesarpay/presentation/widget/Logo.dart';
import 'package:cesarpay/presentation/widget/PasswordCustom.dart';
import 'package:cesarpay/presentation/widget/RegisterCustom.dart';
import 'package:cesarpay/presentation/widget/TextCustom.dart';
import 'package:cesarpay/presentation/widget/Waves.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  static const String routname = 'Login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Stack(
        children: [
          const WaveBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CesarPayLogo(topPadding: 50,),
                    const SizedBox(height: 5),
                    const CesarPayTitle(title: 'Inicio Sesión', topPadding: 5,),
                    const SizedBox(height: 40),
                    const CustomTextField(
                      label: 'Documento de Identificación',
                      icon: Icons.badge,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      validator: FormValidator.validateDocument,
                    ),
                    const SizedBox(height: 20),
                    const CustomTextField(
                      label: 'Contraseña',
                      icon: Icons.lock,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: FormValidator.validatePassword,
                    ),
                    const SizedBox(height: 10),
                    const ForgotPasswordButton(),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Iniciar Sesión',
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          // Logica del boton
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const RegisterButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
