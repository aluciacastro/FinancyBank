import 'package:cesarpay/app_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    // Controladores para capturar los valores de los campos de texto
    final documentController = TextEditingController();
    final passwordController = TextEditingController();

    // Lógica de login
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

          // Navega a la pantalla principal después del login exitoso, por ejemplo:
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => MyAppView(document: document),),);

        } else {
          throw Exception('Usuario no encontrado con ese número de documento.');
        }
      } catch (e) {
        // Muestra un mensaje de error si el login falla
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: $e')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
                    const CesarPayTitle(title: '', topPadding: 5,),
                    const SizedBox(height: 40),
                    CustomTextField(
                      controller: documentController,
                      label: 'Documento de Identificación',
                      icon: Icons.badge,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      validator: FormValidator.validateDocument,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: passwordController,
                      label: 'Contraseña',
                      icon: Icons.lock,
                      maxLength: 6,
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
                          loginWithDocument(
                            document: documentController.text.trim(),
                            password: passwordController.text.trim(),
                          );
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
