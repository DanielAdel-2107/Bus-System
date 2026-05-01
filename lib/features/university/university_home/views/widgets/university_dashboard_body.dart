import 'package:bus_system/app/my_app.dart';
import 'package:bus_system/core/cache/cache_helper.dart';
import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/network/supabase/auth/sign_out_.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/sign_in/views/screens/sign_in_screen.dart';
import 'package:bus_system/features/university/driver_verification/views/screens/driver_verification_screen.dart';
import 'package:bus_system/features/university/pickup_management/views/screens/manage_pickup_screen.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UniversityDashboardBody extends StatelessWidget {
  const UniversityDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPremiumHeader(context),
          SizedBox(height: SizeConfig.height * 0.04),
          _buildSectionTitle('Quick Actions'),
          SizedBox(height: SizeConfig.height * 0.02),
          _buildActionsList(context),
          SizedBox(height: SizeConfig.height * 0.05),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    return Container(
      height: SizeConfig.height * 0.32,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.width * 0.06, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () async {
                      CustomQuickAlert.loading(message: "Logging out...");
                      try {
                        await SupabaseAuthService.signOut()
                            .timeout(const Duration(seconds: 5));
                        await getIt<CacheHelper>().clearData();

                        CustomQuickAlert.dismiss();
                        await Future.delayed(const Duration(milliseconds: 200));

                        if (navigatorKey.currentContext != null) {
                          Navigator.pushAndRemoveUntil(
                            navigatorKey.currentContext!,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        CustomQuickAlert.dismiss();
                        await getIt<CacheHelper>().clearData();
                        await Future.delayed(const Duration(milliseconds: 200));

                        if (navigatorKey.currentContext != null) {
                          Navigator.pushAndRemoveUntil(
                            navigatorKey.currentContext!,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withOpacity(0.5), width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(Icons.logout_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Welcome back,',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: getResponsiveFontSize(fontSize: 16),
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
              const SizedBox(height: 8),
              Text(
                'University Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveFontSize(fontSize: 32),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
              SizedBox(height: SizeConfig.height * 0.06),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.width * 0.06),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: getResponsiveFontSize(fontSize: 20),
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ).animate().fadeIn().slideX(),
    );
  }

  Widget _buildActionsList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.width * 0.06),
      child: Column(
        children: [
          _buildPremiumActionCard(
            context,
            title: 'Manage Pickup Points',
            subtitle: 'Add, edit, or remove university locations',
            icon: Icons.map_rounded,
            gradient: AppColors.greenGradient,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManagePickupScreen(),
                ),
              );
            },
            delay: 100,
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          _buildPremiumActionCard(
            context,
            title: 'Verify Drivers',
            subtitle: 'Review and approve pending driver requests',
            icon: Icons.verified_user_rounded,
            gradient: const LinearGradient(
              colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DriverVerificationScreen(),
                ),
              );
            },
            delay: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
    required int delay,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: getResponsiveFontSize(fontSize: 17),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: getResponsiveFontSize(fontSize: 13),
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.2);
  }
}
