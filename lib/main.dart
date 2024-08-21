import 'package:cesarpay/presentation/screens/Login_Screen.dart';
import 'package:cesarpay/presentation/screens/PassworrdRecovery.dart';
import 'package:cesarpay/presentation/screens/Register_Screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importar Firebase
import 'firebase_options.dart'; // Importar el archivo generado
import 'package:provider/provider.dart'; // Importar Provider
import 'providers/registerProvider.dart'; // Importar el provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura la inicialización
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Inicializa Firebase
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
      ],
      child: MaterialApp(
        title: 'CesarPay',
        debugShowCheckedModeBanner: false,
        initialRoute: LoginScreen.routname,
        routes: {
          '/': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/password': (context) => const PasswordRecoveryScreen(),
        },
      ),
    );
  }
}
