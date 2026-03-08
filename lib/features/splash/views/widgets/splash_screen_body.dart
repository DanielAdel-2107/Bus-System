import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bus_system/core/utilies/assets/images/app_images.dart';

class SplashScreenBody extends StatelessWidget {
  const SplashScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Image.asset(
          AppImages.logoImage,
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width , // حجم مناسب للشعار
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: false),
            )
            .fadeIn(
              duration: 800.ms,
              curve: Curves.easeInOut,
            )
            .scale(
              duration: 1000.ms,
              curve: Curves.elasticOut, // تأثير مطاطي للظهور
            )
            .slide(
              // استخدم slide لـ Offset (الإزاحة)
              duration: 800.ms,
              begin: const Offset(
                  0, 0.3), // من الأسفل (dx=0 أفقيًا، dy=0.3 رأسيًا)
              curve: Curves.easeOutBack,
            )
            .shimmer(
              duration: 1500.ms,
              delay: 1500.ms,
            )
            .then(delay: 500.ms),
      ),
    );
  }
}
