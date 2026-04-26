import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UniversitySettingsBody extends StatelessWidget {
  const UniversitySettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.05,
              vertical: SizeConfig.height * 0.02,
            ),
            children: [
              _buildSectionTitle('General Settings'),
              _buildSettingItem(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                subtitle: 'Manage admin alerts',
                color: Colors.blue,
              ),
              _buildSettingItem(
                icon: Icons.security_rounded,
                title: 'Security',
                subtitle: 'Two-factor authentication',
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Account'),
              _buildSettingItem(
                icon: Icons.person_outline_rounded,
                title: 'Profile Info',
                subtitle: 'Update university details',
                color: Colors.purple,
              ),
              _buildSettingItem(
                icon: Icons.language_rounded,
                title: 'Language',
                subtitle: 'Choose your preference',
                color: Colors.orange,
              ),
              const SizedBox(height: 40),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: SizeConfig.height * 0.08,
        bottom: 30,
        left: 30,
        right: 30,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.kPrimaryColor, AppColors.kSecondaryColor],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveFontSize(fontSize: 28),
                  fontWeight: FontWeight.w900,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.settings_suggest_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'University Administrative Panel',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: getResponsiveFontSize(fontSize: 14),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ).animate().fadeIn().slideY(begin: -0.2),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: getResponsiveFontSize(fontSize: 18),
          fontWeight: FontWeight.w800,
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: getResponsiveFontSize(fontSize: 16),
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: getResponsiveFontSize(fontSize: 12),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
        onTap: () {},
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1);
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
            const SizedBox(width: 12),
            Text(
              'Logout Session',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: getResponsiveFontSize(fontSize: 16),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).scale();
  }
}
