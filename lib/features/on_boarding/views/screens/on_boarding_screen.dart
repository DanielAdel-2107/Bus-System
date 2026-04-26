import 'package:bus_system/core/utilies/assets/lotties/app_lotties.dart';
import 'package:bus_system/features/auth/sign_in/views/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppColors {
  AppColors._();
  static const Color primaryBlue = Color(0xFF0D4C73);
  static const Color lightBlue = Color(0xFF2F8FBE);
  static const Color primaryGreen = Color(0xFF3FAF6C);
  static const Color background = Color(0xFFF5F7FA);
  static const Color white = Colors.white;
  static const Color accentBlue = Color(0xFF1C7ED6);
  static const Color accentGreen = Color(0xFF2FBF71);
  static const Color textPrimary = primaryBlue;
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color success = Color(0xFF28A745);
}

class OnboardingData {
  final String title;
  final String description;
  final String lottieAsset;

  OnboardingData({
    required this.title,
    required this.description,
    required this.lottieAsset,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingData> _data = [
    OnboardingData(
      title: "Smart & Safe Transportation",
      description:
          "Enjoy organized and reliable university transportation designed for students' safety and comfort.",
      lottieAsset: AppLotties.busLottie,
    ),
    OnboardingData(
      title: "Find Pickup & Choose Your Seat",
      description:
          "Discover your nearest pickup point and select your preferred seat in real-time with clear availability.",
      lottieAsset: AppLotties.pickLocationLottie,
    ),
    OnboardingData(
      title: "Track Your Bus in Real-Time",
      description:
          "Stay updated with live bus tracking and receive instant pickup notifications.",
      lottieAsset: AppLotties.trackingLocationLottie,
    ),
    OnboardingData(
      title: "Flexible Plans & Secure Payment",
      description:
          "Choose monthly, semester, or yearly plans and pay securely in just a few taps.",
      lottieAsset: AppLotties.paymentLottie,
    ),
  ];

  void _goToNext() {
    if (_currentIndex < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SignInScreen()),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 20),
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).animate().fade(),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  final item = _data[index];
                  return _buildPage(item, index);
                },
              ),
            ),

            // Bottom Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primaryGreen,
                      dotColor: AppColors.lightBlue.withOpacity(0.3),
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 8,
                    ),
                  ),

                  // Next / Get Started Button
                  _currentIndex == 3
                      ? _buildGetStartedButton()
                      : _buildNextButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Lottie in glowing circle
          Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.lightBlue.withOpacity(0.4),
                    width: 12,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.15),
                      blurRadius: 50,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Lottie.asset(
                  item.lottieAsset,
                  fit: BoxFit.contain,
                  repeat: true,
                  frameRate: FrameRate(60),
                ),
              )
              .animate()
              .scale(duration: 900.ms, curve: Curves.easeOutBack)
              .then()
              .shimmer(duration: 1200.ms),

          const SizedBox(height: 40),

          // Title
          Text(
                item.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 100.ms)
              .slideY(begin: 0.3, curve: Curves.easeOutQuad),

          const SizedBox(height: 20),

          // Description
          Text(
                item.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.65,
                ),
              )
              .animate()
              .fadeIn(duration: 700.ms, delay: 300.ms)
              .slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _goToNext,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
          size: 28,
        ),
      ).animate().scale(duration: 400.ms),
    );
  }

  Widget _buildGetStartedButton() {
    return GestureDetector(
      onTap: _goToNext,
      child:
          Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.primaryGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.5),
                      blurRadius: 25,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Get Started 🚀',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut)
              .then()
              .shimmer(duration: 1500.ms),
    );
  }
}
