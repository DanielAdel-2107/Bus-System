import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:bus_system/features/auth/sign_up/view_models/cubit/sign_up_cubit.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/image_picker_options_body.dart';

class PickUserImage extends StatelessWidget {
  const PickUserImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<SignUpCubit>();
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (_) => ImagePickerOptionsBody(
                onTapCamera: () {
                  context
                      .read<SignUpCubit>()
                      .pickUserImage(source: ImageSource.camera);
                },
                onTapGallery: () {
                  context
                      .read<SignUpCubit>()
                      .pickUserImage(source: ImageSource.gallery);
                },
              ),
            );
          },
          child: Container(
            width: SizeConfig.width * 0.3,
            height: SizeConfig.height * 0.15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
              border: Border.all(
                color: AppColors.kPrimaryColor.withOpacity(0.3),
                width: SizeConfig.width * 0.005,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.kPrimaryColor.withOpacity(0.15),
                  blurRadius: SizeConfig.width * 0.03,
                  spreadRadius: SizeConfig.width * 0.0025,
                ),
              ],
            ),
            child: BlocBuilder<SignUpCubit, SignUpState>(
              buildWhen: (previous, current) =>
                  current is PickUserImageSuccess ||
                  previous is PickUserImageSuccess,
              builder: (context, state) {
                return Stack(
                  children: [
                    if (cubit.imageFile != null)
                      ClipOval(
                        child: Image.file(
                          cubit.imageFile!,
                          fit: BoxFit.cover,
                          width: SizeConfig.width * 0.3,
                          height: SizeConfig.height * 0.15,
                        ),
                      )
                    else ...[
                      Center(
                        child: Icon(
                          Icons.person_outlined,
                          size: SizeConfig.width * 0.1,
                          color: AppColors.kPrimaryColor.withOpacity(0.5),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.width * 0.02,
                              vertical: SizeConfig.height * 0.01),
                          decoration: BoxDecoration(
                            color: AppColors.kPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add_a_photo,
                              size: SizeConfig.width * 0.05,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
        SizedBox(height: SizeConfig.height * 0.01),
        BlocBuilder<SignUpCubit, SignUpState>(
          buildWhen: (previous, current) =>
              current is PickUserImageSuccess ||
              previous is PickUserImageSuccess,
          builder: (context, state) {
            return Text(
              cubit.imageFile != null
                  ? 'Photo Added!'
                  : 'Tap to Add Profile Photo',
              style: AppTextStyles.title12PrimaryColorW500,
              textAlign: TextAlign.center,
            );
          },
        ),
      ],
    );
  }
}
