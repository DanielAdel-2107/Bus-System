import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Contact Us',
          style: TextStyle(
            fontSize: getResponsiveFontSize(fontSize: 20),
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How can we help you?",
              style: TextStyle(
                fontSize: getResponsiveFontSize(fontSize: 24),
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ).animate().fadeIn(),
            SizedBox(height: SizeConfig.height * 0.01),
            Text(
              "Our team is here to support you 24/7.",
              style: TextStyle(
                fontSize: getResponsiveFontSize(fontSize: 15),
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(delay: 100.ms),
            SizedBox(height: SizeConfig.height * 0.04),
            _buildContactCard(
              icon: Icons.email_rounded,
              title: "Email Support",
              subtitle: "support@bussystem.com",
              color: const Color(0xFF6366F1),
              onTap: () {
                CustomQuickAlert.success(
                  title: 'Email Copy',
                  message: 'Email copied to clipboard!',
                );
              },
            ).animate().slideX(begin: 0.1, duration: 400.ms).fadeIn(),
            _buildContactCard(
              icon: Icons.phone_rounded,
              title: "Technical Support",
              subtitle: "+20 101 222 3333",
              color: const Color(0xFF10B981),
              onTap: () {
                CustomQuickAlert.success(
                  title: 'Technical Call',
                  message: 'Starting technical support call...',
                );
              },
            ).animate().slideX(begin: 0.1, duration: 400.ms, delay: 100.ms).fadeIn(),
            _buildContactCard(
              icon: Icons.chat_rounded,
              title: "Live Chat",
              subtitle: "Available from 9AM to 6PM",
              color: const Color(0xFFF59E0B),
              onTap: () {
                CustomQuickAlert.success(
                  title: 'Live Chat',
                  message: 'Connecting to support agent...',
                );
              },
            ).animate().slideX(begin: 0.1, duration: 400.ms, delay: 200.ms).fadeIn(),
            SizedBox(height: SizeConfig.height * 0.04),
            Text(
              "Send us a Message",
              style: TextStyle(
                fontSize: getResponsiveFontSize(fontSize: 18),
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ).animate().fadeIn(delay: 400.ms),
            SizedBox(height: SizeConfig.height * 0.02),
            _buildInputField(label: "Subject", hint: "I need help with..."),
            SizedBox(height: SizeConfig.height * 0.02),
            _buildInputField(label: "Message", hint: "Write your details here...", maxLines: 5),
            SizedBox(height: SizeConfig.height * 0.04),
            SizedBox(
              width: double.infinity,
              height: SizeConfig.height * 0.065,
              child: ElevatedButton(
                onPressed: () {
                  CustomQuickAlert.success(
                    title: 'Sent',
                    message: 'Your message has been sent successfully!',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  'Send Message',
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(fontSize: 16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.height * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.width * 0.045),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
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
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(fontSize: 14),
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade300, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required String hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: getResponsiveFontSize(fontSize: 14),
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: SizeConfig.height * 0.01),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.kPrimaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
