import 'package:bus_system/features/on_boarding/view_models/cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingSteps extends StatelessWidget {
  const OnBoardingSteps({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, int>(
      builder: (context, state) {
        var cubit = context.read<OnBoardingCubit>();
        return Expanded(
          child: PageView.builder(
            itemCount: cubit.steps,
            onPageChanged: cubit.changePage,
            controller: cubit.pageController,
            itemBuilder: (context, index) {
              return null;
            
              // var step = AppConstants.onboardingSteps[index];
              // return CustomOnBoardingStep(
              //   title: step.title,
              //   description: step.description,
              //   image: step.image,
              // );
            },
          ),
        );
      },
    );
  }
}
