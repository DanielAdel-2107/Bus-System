import 'package:bus_system/core/components/custom_drop_down_button_form_field.dart';
import 'package:bus_system/core/components/custom_text_form_field_with_title.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/driver_register/models/pickup_point_model.dart';
import 'package:bus_system/features/auth/driver_register/view_models/cubit/driver_register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DriverRegisterCubit>();
    return Form(
      key: cubit.formKey,
      child: Column(
        children: [
          CustomTextFormFieldWithTitle(
            title: 'License Number',
            hintText: 'e.g. 123456789',
            controller: cubit.licenseController,
            prefixIcon: Icons.badge_rounded,
            keyboardType: TextInputType.text,
            primaryColor: AppColors.primaryBlue,
          ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),

          SizedBox(height: SizeConfig.height * 0.02),

          CustomTextFormFieldWithTitle(
            title: 'Bus Number',
            hintText: 'e.g. ABC 123',
            controller: cubit.busNumberController,
            prefixIcon: Icons.directions_bus_rounded,
            keyboardType: TextInputType.text,
            primaryColor: AppColors.primaryBlue,
          ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),

          SizedBox(height: SizeConfig.height * 0.02),

          CustomTextFormFieldWithTitle(
            title: 'Total Seats',
            hintText: 'e.g. 50',
            controller: cubit.totalSeatsController,
            prefixIcon: Icons.event_seat_rounded,
            keyboardType: TextInputType.number,
            primaryColor: AppColors.primaryBlue,
          ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1),

          SizedBox(height: SizeConfig.height * 0.02),

          CustomDropDownButtonFormField<PickupPointModel>(
            title: 'Starting Pickup Point',
            hintText: 'Select your starting point',
            items: cubit.pickupPoints,
            value: cubit.selectedPickupPoint,
            onChanged: (val) => cubit.selectPickupPoint(val),
            fillColor: Colors.grey.shade50,
            itemLabelBuilder: (item) => item.name,
            primaryColor: AppColors.primaryBlue,
          ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1),
        ],
      ),
    );
  }
}
