import 'package:flutter/material.dart';

class CesarPayTitle extends StatelessWidget {
  final String title;
  final double topPadding;

  const CesarPayTitle({
    super.key,
    this.title = 'CesarPay', 
    this.topPadding = 20.0, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 140, 255),
          shadows: [
            Shadow(
              offset: Offset(2, 2.2),
              blurRadius: 6,
              color: Colors.black45,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
