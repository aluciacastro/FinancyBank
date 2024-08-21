import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

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
