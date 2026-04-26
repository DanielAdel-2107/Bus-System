import 'package:bus_system/core/app_route/route_names.dart';
import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/sign_in/views/screens/sign_in_screen.dart';
import 'package:bus_system/features/profile/view_models/profile_cubit/profile_cubit.dart';
import 'package:bus_system/features/profile/view_models/profile_cubit/profile_state.dart';
import 'package:bus_system/features/profile/views/widgets/profile_info_card.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreenBody extends StatefulWidget {
  const ProfileScreenBody({super.key});

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _syncControllers(String name, String phone) {
    if (_nameController.text != name) _nameController.text = name;
    if (_phoneController.text != phone) _phoneController.text = phone;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileUpdateSuccess) {
          CustomQuickAlert.dismiss();
          CustomQuickAlert.success(
            title: 'Success',
            message: 'Profile updated successfully!',
            confirmBtnColor: AppColors.kPrimaryColor,
          );
        } else if (state is ProfileUpdateError) {
          CustomQuickAlert.dismiss();
          CustomQuickAlert.error(
            title: 'Update Failed',
            message: state.message,
            confirmBtnColor: Colors.redAccent,
          );
        } else if (state is ProfileLogoutLoading) {
          CustomQuickAlert.loading(
            title: 'Please wait',
            message: 'Logging out...',
            barrierDismissible: false,
          );
        } else if (state is ProfileLogoutSuccess) {
          CustomQuickAlert.dismiss();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SignInScreen()),
            (route) => false,
          );
        } else if (state is ProfileLogoutError) {
          CustomQuickAlert.dismiss();
          CustomQuickAlert.error(
            title: 'Logout Failed',
            message: state.message,
            confirmBtnColor: Colors.redAccent,
          );
        } else if (state is ProfileUpdating) {
          CustomQuickAlert.loading(
            title: 'Please wait',
            message: 'Updating profile...',
            barrierDismissible: false,
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileInitial || state is ProfileLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.kPrimaryColor),
          ).animate().fadeIn();
        } else if (state is ProfileError) {
          return Center(child: Text(state.message));
        }

        final profile = context.read<ProfileCubit>().state is ProfileLoaded
            ? (context.read<ProfileCubit>().state as ProfileLoaded).profile
            : (context.read<ProfileCubit>().state is ProfileEditMode
                  ? (context.read<ProfileCubit>().state as ProfileEditMode)
                        .profile
                  : null);

        if (profile == null) return const SizedBox.shrink();

        final bool isEditing = state is ProfileEditMode;

        // Sync controllers smoothly
        if (!isEditing && _nameController.text.isEmpty) {
          _syncControllers(profile.name, profile.phone);
        }

        return Stack(
          children: [
            // Top colored background piece
            Container(
              height: SizeConfig.height * 0.12,
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
            ),

            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.width * 0.05,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.height * 0.04,
                  ), // Padding to overlap
                  // Avatar with white border
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: SizeConfig.height * 0.06,
                        backgroundColor: AppColors.kPrimaryColor.withOpacity(
                          0.1,
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: SizeConfig.height * 0.06,
                          color: AppColors.kPrimaryColor,
                        ),
                      ),
                    ),
                  ).animate().scale(
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  ),

                  SizedBox(height: SizeConfig.height * 0.02),

                  // Name and basic info
                  Text(
                    profile.name,
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(fontSize: 22),
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  Text(
                    '${profile.role[0].toUpperCase()}${profile.role.substring(1)} Account',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(fontSize: 14),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  SizedBox(height: SizeConfig.height * 0.04),

                  // Profile Info Card
                  ProfileInfoCard(
                    profile: profile,
                    isEditing: isEditing,
                    nameController: _nameController,
                    phoneController: _phoneController,
                    onEditToggle: () {
                      _syncControllers(profile.name, profile.phone);
                      context.read<ProfileCubit>().toggleEditMode();
                    },
                    onSave: () {
                      context.read<ProfileCubit>().updateProfile(
                        newName: _nameController.text.trim(),
                        newPhone: _phoneController.text.trim(),
                      );
                    },
                  ).animate().slideY(begin: 0.1, duration: 400.ms).fadeIn(),

                  SizedBox(height: SizeConfig.height * 0.04),

                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
