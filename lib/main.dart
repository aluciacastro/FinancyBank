import 'package:cesarpay/presentation/screens/home/ConsigScreen.dart';
import 'package:cesarpay/presentation/screens/home/UserProfileScreen.dart';
import 'package:cesarpay/presentation/screens/home/retiroScreen.dart';
import 'package:cesarpay/presentation/screens/loan/loanScreen.dart';
import 'package:cesarpay/presentation/screens/login/CheckEmail.dart';
import 'package:cesarpay/presentation/screens/login/Login_Screen.dart';
import 'package:cesarpay/presentation/screens/login/NewPass.dart';
import 'package:cesarpay/presentation/screens/login/PassworrdRecovery.dart';
import 'package:cesarpay/presentation/screens/login/Register_Screen.dart';
import 'package:cesarpay/presentation/screens/login/ResetPass.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FINANCYBANK',
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/password': (context) => const PasswordRecoveryScreen(),
        '/checkEmail': (context) => const CheckEmailScreen(),
        '/newpass': (context) => const NewPasswordScreen(),
        '/resetPassword': (context) => const ResetPasswordScreen(),
        '/profile': (context) => const UserProfileScreen(),
        '/loan': (context) => const LoanScreen(),
        '/consig': (context) => const ConsignarScreen(),
        '/retiro': (context) => const RetiroScreen(),
      },
    );
  }
}