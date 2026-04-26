import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/driver/passenger_list/view_models/cubit/passenger_list_cubit.dart';
import 'package:bus_system/features/driver/passenger_list/view_models/cubit/passenger_list_state.dart';
import 'package:bus_system/features/driver/passenger_list/views/widgets/passenger_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PassengerListScreenBody extends StatelessWidget {
  const PassengerListScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PassengerListCubit, PassengerListState>(
      builder: (context, state) {
        if (state is PassengerListLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.kPrimaryColor,
            ),
          ).animate().fadeIn(duration: 300.ms);
        } else if (state is PassengerListError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(
                fontSize: SizeConfig.height * 0.02,
                color: Colors.redAccent,
              ),
            ),
          ).animate().fadeIn();
        } else if (state is PassengerListSuccess) {
          if (state.passengers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_bus_filled_rounded,
                    size: SizeConfig.height * 0.08,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: SizeConfig.height * 0.02),
                  Text(
                    'No passengers today.',
                    style: TextStyle(
                      fontSize: SizeConfig.height * 0.022,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2);
          }

          return ListView.builder(
            padding: EdgeInsets.fromLTRB(
              SizeConfig.width * 0.05,
              SizeConfig.height * 0.03,
              SizeConfig.width * 0.05,
              SizeConfig.height * 0.1,
            ),
            physics: const BouncingScrollPhysics(),
            itemCount: state.passengers.length,
            itemBuilder: (context, index) {
              return PassengerCard(
                passenger: state.passengers[index],
              )
                  .animate()
                  .fadeIn(duration: 450.ms, delay: (80 * index).ms)
                  .slideX(begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

