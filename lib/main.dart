import 'package:cesarpay/domain/controller/ControllerPassRecovery.dart';
import 'package:cesarpay/presentation/screens/home/UserProfileScreen.dart';
import 'package:cesarpay/presentation/screens/login/CheckEmail.dart';
import 'package:cesarpay/presentation/screens/login/Login_Screen.dart';
import 'package:cesarpay/presentation/screens/login/NewPass.dart';
import 'package:cesarpay/presentation/screens/login/PassworrdRecovery.dart';
import 'package:cesarpay/presentation/screens/login/Register_Screen.dart';
import 'package:cesarpay/presentation/screens/login/ResetPass.dart';
import 'package:cesarpay/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'providers/registerProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    riverpod.ProviderScope(
    child: provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (_) => RegisterProvider()),
        provider.ChangeNotifierProvider(create: (_) => PasswordRecoveryProvider()),
        provider.ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CesarPay',
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routname,
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/password': (context) => const PasswordRecoveryScreen(),
        '/checkEmail': (context) => const CheckEmailScreen(),
        '/newpass': (context) => const NewPasswordScreen(),
        '/resetPassword': (context) => const ResetPasswordScreen(),
        '/profile': (context) => const UserProfileScreen(),
      },
    );
  }
}