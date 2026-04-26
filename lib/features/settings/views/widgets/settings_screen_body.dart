import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/settings/view_models/settings_cubit/settings_cubit.dart';
import 'package:bus_system/features/settings/view_models/settings_cubit/settings_state.dart';
import 'package:bus_system/features/profile/views/screens/profile_screen.dart';
import 'package:bus_system/features/settings/views/screens/about_us_screen.dart';
import 'package:bus_system/features/settings/views/screens/contact_us_screen.dart';
import 'package:bus_system/features/settings/views/screens/privacy_policy_screen.dart';
import 'package:bus_system/features/settings/views/widgets/settings_toggle_tile.dart';
import 'package:bus_system/core/app_route/route_names.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SettingsScreenBody extends StatelessWidget {
  const SettingsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsLogoutLoading) {
          CustomQuickAlert.loading(
            title: 'Please wait',
            message: 'Logging out...',
            barrierDismissible: false,
          );
        } else if (state is SettingsLogoutSuccess) {
          CustomQuickAlert.dismiss( );
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.signInScreen,
            (route) => false,
          );
        } else if (state is SettingsLogoutError) {
          CustomQuickAlert.dismiss();
          CustomQuickAlert.error(message: state.message);
        }
      },
      builder: (context, state) {
        final settings = state.settings;

        return ListView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width * 0.05,
            vertical: SizeConfig.height * 0.02,
          ),
          physics: const BouncingScrollPhysics(),
          children: [
            // Account Section Header
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.width * 0.02,
                bottom: SizeConfig.height * 0.015,
              ),
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(fontSize: 14),
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                  letterSpacing: 1.2,
                ),
              ),
            ).animate().fadeIn(delay: 50.ms),

            _SettingsOptionTile(
                  title: 'My Profile',
                  subtitle: 'Manage your personal data',
                  icon: Icons.person_rounded,
                  iconColor: const Color(0xFF0EA5E9), // Sky Blue
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ProfileScreen(isRoot: false),
                      ),
                    );
                  },
                )
                .animate()
                .slideX(begin: 0.1, duration: 400.ms, delay: 50.ms)
                .fadeIn(),

            SizedBox(height: SizeConfig.height * 0.02),

            // Preference Section Header
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.width * 0.02,
                bottom: SizeConfig.height * 0.015,
              ),
              child: Text(
                'Preferences',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(fontSize: 14),
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade600,
                  letterSpacing: 1.2,
                ),
              ),
            ).animate().fadeIn(delay: 100.ms),

            // Notifications Toggle
            SettingsToggleTile(
              title: 'Push Notifications',
              subtitle: 'Receive alerts and ride updates',
              icon: Icons.notifications_active_rounded,
              iconColor: const Color(0xFFF59E0B), // Amber
              value: settings.isNotificationsEnabled,
              onChanged: (val) {
                context.read<SettingsCubit>().toggleNotifications(val);
              },
            ).animate().slideX(begin: 0.1, duration: 400.ms).fadeIn(),

            // Dark Mode Toggle
            SettingsToggleTile(
                  title: 'Dark Mode',
                  subtitle: 'Switch to a dark aesthetic theme',
                  icon: Icons.dark_mode_rounded,
                  iconColor: const Color(0xFF6366F1), // Indigo
                  value: settings.isDarkMode,
                  onChanged: (val) {
                    context.read<SettingsCubit>().toggleDarkMode(val);
                  },
                )
                .animate()
                .slideX(begin: 0.1, duration: 400.ms, delay: 100.ms)
                .fadeIn(),

            SizedBox(height: SizeConfig.height * 0.03),

            // General Section Header
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.width * 0.02,
                bottom: SizeConfig.height * 0.015,
              ),
              child: Text(
                'General',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(fontSize: 14),
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade600,
                  letterSpacing: 1.2,
                ),
              ),
            ).animate().fadeIn(delay: 200.ms),

            // Language Selector
            _SettingsOptionTile(
                  title: 'Language',
                  subtitle: settings.languageCode == 'en'
                      ? 'English (US)'
                      : 'العربية',
                  icon: Icons.language_rounded,
                  iconColor: const Color(0xFF10B981), // Emerald
                  onTap: () {
                    _showLanguageBottomSheet(context);
                  },
                )
                .animate()
                .slideX(begin: 0.1, duration: 400.ms, delay: 200.ms)
                .fadeIn(),

            SizedBox(height: SizeConfig.height * 0.03),

            // Support Section Header
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.width * 0.02,
                bottom: SizeConfig.height * 0.015,
              ),
              child: Text(
                'Support',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(fontSize: 14),
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade600,
                  letterSpacing: 1.2,
                ),
              ),
            ).animate().fadeIn(delay: 300.ms),

            // Contact Us
            _SettingsOptionTile(
                  title: 'Contact Us',
                  subtitle: 'Get help or report an issue',
                  icon: Icons.message_rounded,
                  iconColor: const Color(0xFFF43F5E), // Rose
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactUsScreen(),
                      ),
                    );
                  },
                )
                .animate()
                .slideX(begin: 0.1, duration: 400.ms, delay: 300.ms)
                .fadeIn(),

            SizedBox(height: SizeConfig.height * 0.03),

            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.width * 0.02,
                bottom: SizeConfig.height * 0.015,
              ),
              child: Text(
                'About',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(fontSize: 14),
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                  letterSpacing: 1.2,
                ),
              ),
            ).animate().fadeIn(delay: 400.ms),

            // About Us
            _SettingsOptionTile(
                  title: 'About Bus System',
                  subtitle: 'Version 1.0.0',
                  icon: Icons.info_rounded,
                  iconColor: const Color(0xFF3B82F6), // Blue
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutUsScreen(),
                      ),
                    );
                  },
                )
                .animate()
                .slideX(begin: 0.1, duration: 400.ms, delay: 400.ms)
                .fadeIn(),

            // Privacy Policy
            _SettingsOptionTile(
                  title: 'Privacy Policy',
                  subtitle: 'How we handle your data',
                  icon: Icons.security_rounded,
                  iconColor: const Color(0xFF8B5CF6), // Violet
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                )
                .animate()
                .slideX(begin: 0.1, duration: 400.ms, delay: 500.ms)
                .fadeIn(),

            SizedBox(height: SizeConfig.height * 0.05),
          ],
        );
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          padding: EdgeInsets.all(SizeConfig.width * 0.06),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(SizeConfig.height * 0.04),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: SizeConfig.width * 0.15,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: SizeConfig.height * 0.03),
              Text(
                'Select Language',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(fontSize: 20),
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: SizeConfig.height * 0.03),
              _buildLangOption(context, title: 'English (US)', langCode: 'en'),
              SizedBox(height: SizeConfig.height * 0.015),
              _buildLangOption(
                context,
                title: 'العربية (Arabic)',
                langCode: 'ar',
              ),
              SizedBox(height: SizeConfig.height * 0.03),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLangOption(
    BuildContext context, {
    required String title,
    required String langCode,
  }) {
    final cubit = context.read<SettingsCubit>();
    final isSelected = cubit.state.settings.languageCode == langCode;

    return InkWell(
      onTap: () {
        cubit.changeLanguage(langCode);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.height * 0.02),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kPrimaryColor.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.kPrimaryColor : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: getResponsiveFontSize(fontSize: 16),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected
                    ? AppColors.kPrimaryColor
                    : Colors.grey.shade700,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.kPrimaryColor,
                size: SizeConfig.height * 0.024,
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingsOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SettingsOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.height * 0.02),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.02),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.02),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SizeConfig.height * 0.02),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.04,
              vertical: SizeConfig.height * 0.018,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(SizeConfig.height * 0.014),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: SizeConfig.height * 0.024,
                  ),
                ),
                SizedBox(width: SizeConfig.width * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(fontSize: 16),
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: SizeConfig.height * 0.004),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(fontSize: 13),
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade400,
                  size: SizeConfig.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
