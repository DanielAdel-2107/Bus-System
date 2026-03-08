import 'package:bus_system/core/components/custom_elevated_button.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:bus_system/features/on_boarding/view_models/cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NextPageButton extends StatelessWidget {
  const NextPageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.03,
      ),
      child: BlocBuilder<OnBoardingCubit, int>(
        buildWhen: (previous, current) => current == 2 || previous == 2,
        builder: (context, state) {
          return CustomElevatedButton(
            hPadding: SizeConfig.width * 0.04,
            name: state == 2 ? "Continue" :"Next",
            width: SizeConfig.width * 0.9,
            backgroundColor: AppColors.kPrimaryColor,
            textStyle: AppTextStyles.title20WhiteW500,
            onPressed: () {
              context.read<OnBoardingCubit>().nextPage();
            },
          );
        },
      ),
    );
  }
}
