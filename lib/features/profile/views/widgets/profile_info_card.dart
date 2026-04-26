import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/profile/models/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final ProfileModel profile;
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final VoidCallback onEditToggle;
  final VoidCallback onSave;

  const ProfileInfoCard({
    super.key,
    required this.profile,
    required this.isEditing,
    required this.nameController,
    required this.phoneController,
    required this.onEditToggle,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.width * 0.06),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personal Info',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(fontSize: 18),
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: isEditing ? onSave : onEditToggle,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width * 0.03,
                    vertical: SizeConfig.height * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: isEditing ? AppColors.kPrimaryColor : AppColors.kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isEditing ? 'Save' : 'Edit',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(fontSize: 14),
                      fontWeight: FontWeight.w700,
                      color: isEditing ? Colors.white : AppColors.kPrimaryColor,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: SizeConfig.height * 0.03),
          _buildField(
            icon: Icons.person_outline_rounded,
            label: 'Full Name',
            controller: nameController,
            isEditing: isEditing,
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          _buildField(
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            controller: phoneController,
            isEditing: isEditing,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: getResponsiveFontSize(fontSize: 13),
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
          ),
        ),
        SizedBox(height: SizeConfig.height * 0.008),
        Container(
          decoration: BoxDecoration(
            color: isEditing ? Colors.white : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isEditing ? AppColors.kPrimaryColor.withOpacity(0.5) : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(SizeConfig.height * 0.015),
                child: Icon(
                  icon,
                  color: isEditing ? AppColors.kPrimaryColor : Colors.grey.shade400,
                  size: SizeConfig.height * 0.024,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: isEditing,
                  keyboardType: keyboardType,
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(fontSize: 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: SizeConfig.height * 0.015,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
