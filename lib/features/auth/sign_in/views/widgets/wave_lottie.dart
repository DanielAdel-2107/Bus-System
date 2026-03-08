import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';

class WaveLottie extends StatelessWidget {
  const WaveLottie({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: SizedBox(
        width: SizeConfig.width,
        height: SizeConfig.height * 0.4,
        child: Lottie.asset(
          'assets/lotties/Green Wave.json',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
