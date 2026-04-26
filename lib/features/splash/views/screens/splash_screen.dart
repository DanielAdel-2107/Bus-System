import 'dart:async';
import 'package:bus_system/core/utilies/assets/images/app_images.dart';
import 'package:bus_system/core/cache/cache_helper.dart';
import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/features/auth/sign_in/views/screens/sign_in_screen.dart';
import 'package:bus_system/features/driver/driver_main/views/screens/driver_main_screen.dart';
import 'package:bus_system/features/on_boarding/views/screens/on_boarding_screen.dart';
import 'package:bus_system/features/student/dashboard/views/screens/student_dashboard_screen.dart';
import 'package:bus_system/features/university/university_home/views/screens/university_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppColors {
  AppColors._();
  static const Color primaryBlue = Color(0xFF0D4C73);
  static const Color lightBlue = Color(0xFF2F8FBE);
  static const Color primaryGreen = Color(0xFF3FAF6C);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      // User is logged in, check role
      final userModel = getIt<CacheHelper>().getUserModel();
      final role = userModel?.role?.toLowerCase();

      Widget nextScreen;

      if (role == 'admin') {
        nextScreen = const UniversityDashboardScreen();
      } else if (role == 'driver') {
        nextScreen = const DriverMainScreen();
      } else if (role == 'student') {
        nextScreen = const StudentDashboardScreen();
      } else {
        // Fallback if role is unknown but user exists
        nextScreen = const SignInScreen();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    } else {
      // User not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryBlue,
              Color(0xFF1C7ED6),
              AppColors.primaryGreen,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ==================== LOTTIE + MULTIPLE GLOW ====================
              Stack(
                alignment: Alignment.center,
                children: [
                  // Glow Layer 1
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.25),
                          blurRadius: 100,
                          spreadRadius: 30,
                        ),
                      ],
                    ),
                  ),
                  // Glow Layer 2
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withOpacity(0.35),
                          blurRadius: 80,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  // Lottie with Pulse
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 8),
                    ),
                    child: Image.asset(
                      AppImages.logoImage,
                      fit: BoxFit.contain,
                    ),
                  )
                      .animate()
                      .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 1200.ms)
                      .then()
                      .scale(begin: const Offset(1.05, 1.05), end: const Offset(0.95, 0.95), duration: 1200.ms)
                      .rotate()
                      .shimmer(duration: 1800.ms, color: Colors.white),
                ],
              ),

              const SizedBox(height: 50),

              // ==================== GRADIENT APP NAME ====================
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xFF3FAF6C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'SmartBus',
                  style: GoogleFonts.poppins(
                    fontSize: 58,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -2,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 900.ms)
                  .slideY(begin: 0.5, curve: Curves.easeOutCubic)
                  .then()
                  .shimmer(duration: 1600.ms),

              const SizedBox(height: 8),

              // Tagline
              Text(
                'Smart & Safe Transportation',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.95),
                ),
              )
                  .animate()
                  .fadeIn(delay: 400.ms)
                  .slideY(begin: 0.3),

              const SizedBox(height: 90),

              // ==================== ANIMATED LOADING DOTS ====================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Loading the future',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _AnimatedDots(),
                ],
              )
                  .animate()
                  .fadeIn(delay: 1400.ms),
            ],
          ),
        ),
      ),
    );
  }
}

// Animated Dots Widget
class _AnimatedDots extends StatelessWidget {
  const _AnimatedDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        )
            .animate()
            .fadeIn(delay: (index * 200).ms)
            .then()
            .fadeOut(delay: 600.ms)
            .rotate();
      }),
    );
  }
}