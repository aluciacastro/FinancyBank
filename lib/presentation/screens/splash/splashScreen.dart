import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cesarpay/presentation/screens/login/Login_Screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente
        children: [
          Expanded(  // Expande la animación para ajustarse al tamaño disponible
            child: Center(
              child: LottieBuilder.asset("assets/lottie/Animation - 1728923557795.json"),
            ),
          ),
        ],
      ),
      nextScreen: const LoginScreen(),
      splashIconSize: MediaQuery.of(context).size.height * 0.4,
      backgroundColor: const Color.fromARGB(255, 51, 140, 248),
    );
  }
}
