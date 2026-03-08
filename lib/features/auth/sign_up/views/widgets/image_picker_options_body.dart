import 'package:flutter/material.dart';
import 'package:bus_system/core/components/custom_text_button.dart';
import 'package:bus_system/core/utilies/extensions/app_extensions.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/picker_option.dart';

class ImagePickerOptionsBody extends StatelessWidget {
  const ImagePickerOptionsBody({
    super.key,
    this.onTapGallery,
    this.onTapCamera,
  });
  final Function()? onTapGallery;
  final Function()? onTapCamera;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.05,
        vertical: SizeConfig.height * 0.025,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Profile Photo',
            style: AppTextStyles.title16BlackBold,
          ),
          SizedBox(height: SizeConfig.height * 0.025),
          PickerOption(
            icon: Icons.photo_library_outlined,
            label: 'Gallery',
            onTap: onTapGallery,
          ),
          PickerOption(
            icon: Icons.camera_alt_outlined,
            label: 'Camera',
            onTap: onTapCamera,
          ),
          SizedBox(height: SizeConfig.height * 0.025),
          CustomTextButton(
            onPressed: () => context.popScreen(),
            title: 'Cancel',
          ),
        ],
      ),
    );
  }
}
