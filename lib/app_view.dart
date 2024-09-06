import 'package:cesarpay/presentation/screens/home/home.dart';
import 'package:flutter/material.dart';

class MyAppView extends StatelessWidget {
  final String document;

  const MyAppView({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Financy Banck",
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.grey.shade100, 
          onSurface: Colors.black, 
          primary: const Color.fromARGB(255, 7, 108, 239), 
          secondary: const Color.fromARGB(255, 51, 140, 248), 
          tertiary: const Color.fromARGB(255, 70, 181, 251), 
          outline: Colors.grey,
        ),
      ),
      home: HomeScreen(document: document),
    );
  }
}
