import 'package:cesarpay/app_view.dart';
import 'package:cesarpay/presentation/validators/FormValidatorRegister.dart';
import 'package:cesarpay/presentation/widget/ButtonCustom.dart';
import 'package:cesarpay/presentation/widget/Inputs.dart';
import 'package:cesarpay/presentation/widget/Logo.dart';
import 'package:cesarpay/presentation/widget/PasswordCustom.dart';
import 'package:cesarpay/presentation/widget/RegisterCustom.dart';
import 'package:cesarpay/presentation/widget/TextCustom.dart';
import 'package:cesarpay/presentation/widget/Waves.dart';
import 'package:flutter/material.dart';
import 'package:cesarpay/domain/controller/ControllerLogin.dart'; // Importa el controlador de login
import 'package:shared_preferences/shared_preferences.dart'; // Asegúrate de importar SharedPreferences

class LoginScreen extends StatefulWidget {
  static const String routname = 'Login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final loginLogic = LoginLogic(); // Instancia del controlador de login

  // Controladores para capturar los valores de los campos de texto
  final documentController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLastUserDocument();
  }

  Future<void> _loadLastUserDocument() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastUserDocument = prefs.getString('lastUserDocument');
    if (lastUserDocument != null) {
      documentController.text = lastUserDocument;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    const CesarPayLogo(topPadding: 20),
                    const SizedBox(height: 5),
                    const CesarPayTitle(title: '', topPadding: 5),
                    const SizedBox(height: 5),
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
                          loginLogic.loginWithDocument(
                            document: documentController.text.trim(),
                            password: passwordController.text.trim(),
                          ).then((_) async {
                            // Guardar el último documento en SharedPreferences
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('lastUserDocument', documentController.text.trim());
                            
                            Navigator.pushReplacement(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyAppView(document: documentController.text.trim()),
                              ),
                            );
                          }).catchError((e) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<bool>(
                      future: loginLogic.canCheckBiometrics(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data == true) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue, // Fondo azul
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.fingerprint, size: 40, color: Colors.white), // Icono blanco
                                  onPressed: () async {
                                    // Verificar si hay un documento almacenado
                                    final prefs = await SharedPreferences.getInstance();
                                    String? lastUserDocument = prefs.getString('lastUserDocument');

                                    if (lastUserDocument != null) {
                                      bool authenticated = await loginLogic.authenticateWithBiometrics();
                                      if (authenticated) {
                                        Navigator.pushReplacement(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyAppView(document: lastUserDocument),
                                          ),
                                        );
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Autenticación fallida')),
                                        );
                                      }
                                    } else {
                                      // Manejar el caso donde no hay documento almacenado
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('No hay documento almacenado para la autenticación')),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const CircularProgressIndicator();
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
