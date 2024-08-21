import 'package:cesarpay/presentation/validators/FormValidatorRegister.dart';
import 'package:cesarpay/presentation/widget/ButtonCustom.dart';
import 'package:cesarpay/presentation/widget/InputDate.dart';
import 'package:cesarpay/presentation/widget/Inputs.dart';
import 'package:cesarpay/presentation/widget/TextCustom.dart';
import 'package:cesarpay/presentation/widget/Waves.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const String routname = 'Register';
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> registerUser() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        final email = emailController.text;
        final password = passwordController.text;

        // Crea un nuevo usuario con Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Guarda los datos adicionales en Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
          'name': nameController.text,
          'document': documentController.text,
          'dateOfBirth': dateController.text,
          'email': email,
          'password': password,
        });

        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Registro exitoso');
        // Redirige al usuario a otra pantalla si es necesario
      } catch (e) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Error al registrar usuario: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const WaveBackground(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Aquí puedes incluir tu widget Logo
                    const SizedBox(height: 5),
                    const CesarPayTitle(title: 'Registro', topPadding: 70,),
                    const SizedBox(height: 40),
                    CustomTextField(
                      label: 'Nombre y Apellido',
                      icon: Icons.people,
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      validator: FormValidator.validateName,
                      controller: nameController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Documento de Identificación',
                      icon: Icons.badge,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      validator: FormValidator.validateDocument,
                      controller: documentController,
                    ),
                    const SizedBox(height: 20),
                    DatePickerField(
                      label: 'Fecha de Nacimiento',
                      icon: Icons.calendar_today,
                      validator: FormValidator.validateDate,
                      controller: dateController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Correo Electrónico',
                      icon: Icons.email,
                      maxLength: 50,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      validator: FormValidator.validateEmail,
                      controller: emailController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Contraseña',
                      icon: Icons.lock,
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: FormValidator.validatePassword,
                      controller: passwordController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Confirmar Contraseña',
                      icon: Icons.lock_outline,
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: (value) {
                        return FormValidator.validateConfirmPassword(value, passwordController.text);
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Registrarse',
                      onPressed: registerUser,
                    ),
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
