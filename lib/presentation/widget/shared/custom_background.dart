import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:cesarpay/presentation/widget/shared/close_icon.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;
  final bool showArrow;
  final bool showLogo;
  final double height;

  const CustomBackground({
    super.key,
    required this.child,
    this.showArrow = false,
    this.showLogo = false,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const WaveBackground(), 
          if (showArrow)
            const CloseIcon(
              navigation: "/login",
              icon: Icons.close_rounded,
              alignment: 320,
            ),
          child,
        ],
      ),
    );
  }
}

class WaveBackground extends StatelessWidget {
  const WaveBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: WaveWidget(
        config: CustomConfig(
          gradients: [
            [Colors.blueAccent, const Color.fromARGB(255, 64, 194, 255)],
            [Colors.lightBlueAccent, const Color.fromARGB(255, 56, 129, 255)],
            [Colors.lightBlue, const Color.fromARGB(255, 0, 140, 255)],
          ],
          durations: [35000, 19440, 10800],
          heightPercentages: [0.20, 0.23, 0.25],
          blur: const MaskFilter.blur(BlurStyle.solid, 2),
          gradientBegin: Alignment.bottomLeft,
          gradientEnd: Alignment.topRight,
        ),
        waveAmplitude: 0,
        size: const Size(double.infinity, 100),
      ),
    );
  }
}
