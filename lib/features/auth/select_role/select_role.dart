import 'package:bus_system/core/utilies/assets/images/app_images.dart';
import 'package:bus_system/features/auth/sign_up/views/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppColors {
  AppColors._();
  static const Color primaryBlue = Color(0xFF0D4C73);
  static const Color lightBlue = Color(0xFF2F8FBE);
  static const Color primaryGreen = Color(0xFF3FAF6C);
  static const Color background = Color(0xFFF5F7FA);
  static const Color accentBlue = Color(0xFF3FAF6C);
  static const Color white = Colors.white;
  static const Color textPrimary = primaryBlue;
  static const Color textSecondary = Color(0xFF6C757D);
}

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;

  final List<Map<String, dynamic>> _roles = [
    {
      'role': 'Driver',
      'title': 'I\'m a Driver',
      'desc': 'Drive students safely and manage your routes in real-time.',
      'icon': Icons.directions_bus_rounded,
      'color': AppColors.primaryGreen,
    },
    {
      'role': 'Student',
      'title': 'I\'m a Student',
      'desc': 'Track your bus live and enjoy safe school trips.',
      'icon': Icons.person_rounded,
      'color': AppColors.accentBlue,
    },
    {
      'role': 'School',
      'title': 'I\'m a School',
      'desc': 'Manage all buses, drivers, and students from one dashboard.',
      'icon': Icons.school_rounded,
      'color': AppColors.primaryBlue,
    },
  ];

  void _continue() {
    if (selectedRole != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignUpScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            children: [
              // Lottie in glowing circle
              Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.lightBlue.withOpacity(0.3),
                        width: 14,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.2),
                          blurRadius: 60,
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      AppImages.logoImage,
                      fit: BoxFit.contain,
                    ),
                  )
                  .animate()
                  .scale(duration: 800.ms, curve: Curves.easeOutBack)
                  .then()
                  .shimmer(duration: 1400.ms),

              const SizedBox(height: 30),

              // Title
              Text(
                'Choose Your Role',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),

              Text(
                'Who are you in SmartBus?',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

              const SizedBox(height: 40),

              // Roles Cards
              Expanded(
                child: ListView.builder(
                  itemCount: _roles.length,
                  itemBuilder: (context, index) {
                    final role = _roles[index];
                    final isSelected = selectedRole == role['role'];
                    return GestureDetector(
                      onTap: () => setState(() => selectedRole = role['role']),
                      child:
                          Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isSelected
                                        ? role['color'].withOpacity(0.8)
                                        : AppColors.lightBlue.withOpacity(0.2),
                                    width: isSelected ? 3 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected
                                          ? role['color'].withOpacity(0.3)
                                          : Colors.black.withOpacity(0.05),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Icon Circle
                                    Container(
                                      width: 68,
                                      height: 68,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: role['color'].withOpacity(0.1),
                                      ),
                                      child: Icon(
                                        role['icon'],
                                        size: 36,
                                        color: role['color'],
                                      ),
                                    ),
                                    const SizedBox(width: 20),

                                    // Text
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            role['title'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            role['desc'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: AppColors.textSecondary,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Checkmark
                                    if (isSelected)
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: role['color'],
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ).animate().scale(
                                        duration: 300.ms,
                                        curve: Curves.elasticOut,
                                      ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(delay: (index * 100).ms)
                              .slideX(begin: 0.3, curve: Curves.easeOutQuad),
                    );
                  },
                ),
              ),

              // Continue Button
              GestureDetector(
                onTap: selectedRole != null ? _continue : null,
                child:
                    Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: selectedRole != null
                                  ? [
                                      AppColors.primaryBlue,
                                      AppColors.primaryGreen,
                                    ]
                                  : [
                                      Colors.grey.shade400,
                                      Colors.grey.shade400,
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              if (selectedRole != null)
                                BoxShadow(
                                  color: AppColors.primaryGreen.withOpacity(
                                    0.5,
                                  ),
                                  blurRadius: 25,
                                  offset: const Offset(0, 12),
                                ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              selectedRole != null
                                  ? 'Continue as $selectedRole 🚀'
                                  : 'Select a Role to Continue',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .scale(duration: 500.ms, curve: Curves.elasticOut)
                        .then()
                        .shimmer(duration: 1200.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
