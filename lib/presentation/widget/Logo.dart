import 'package:flutter/material.dart';

class CesarPayLogo extends StatelessWidget {
  final double width;
  final double height;
  final double topPadding;
  final String logoPath; 

  const CesarPayLogo({
    super.key,
    this.width = 150.0,
    this.height = 200.0,
    this.topPadding = 0.0,
    this.logoPath = 'assets/images/logo.png',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Center(
        child: Image.asset(
          logoPath, 
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
