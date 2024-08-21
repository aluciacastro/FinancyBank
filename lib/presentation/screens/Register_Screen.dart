import 'package:cesarpay/domain/controller/ControllerRegister.dart';
import 'package:cesarpay/presentation/validators/FormValidatorRegister.dart';
import 'package:cesarpay/presentation/widget/ButtonCustom.dart';
import 'package:cesarpay/presentation/widget/InputDate.dart';
import 'package:cesarpay/presentation/widget/Inputs.dart';
import 'package:cesarpay/presentation/widget/TextCustom.dart';
import 'package:cesarpay/presentation/widget/Waves.dart';
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
  final RegisterController controller = RegisterController();
  final RegisterLogic registerLogic = RegisterLogic(); 

  void showSnackBar(BuildContext context, String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> registerUser() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        await registerLogic.registerUser(
          email: controller.emailController.text,
          password: controller.passwordController.text,
          name: controller.nameController.text,
          document: controller.documentController.text,
          dateOfBirth: controller.dateController.text,
        );

        // Limpia los campos de texto
        controller.emailController.clear();
        controller.passwordController.clear();
        controller.nameController.clear();
        controller.documentController.clear();
        controller.dateController.clear();

        // Muestra mensaje de éxito
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Registro exitoso', success: true);
        
        // Redirige al usuario a otra pantalla si es necesario
      } catch (e) {
        // Muestra mensaje de error
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Error al registrar usuario: $e');
      }
    }
  }

  @override
  void dispose() {
    controller.dispose(); // Asegúrate de liberar los recursos
    super.dispose();
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
                      controller: controller.nameController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Documento de Identificación',
                      icon: Icons.badge,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      validator: FormValidator.validateDocument,
                      controller: controller.documentController,
                    ),
                    const SizedBox(height: 20),
                    DatePickerField(
                      label: 'Fecha de Nacimiento',
                      icon: Icons.calendar_today,
                      validator: FormValidator.validateDate,
                      controller: controller.dateController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Correo Electrónico',
                      icon: Icons.email,
                      maxLength: 50,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      validator: FormValidator.validateEmail,
                      controller: controller.emailController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Contraseña',
                      icon: Icons.lock,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: FormValidator.validatePassword,
                      controller: controller.passwordController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Confirmar Contraseña',
                      icon: Icons.lock_outline,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: (value) {
                        return FormValidator.validateConfirmPassword(value, controller.passwordController.text);
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
