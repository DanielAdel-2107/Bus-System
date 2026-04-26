import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/driver/passenger_list/view_models/cubit/passenger_list_cubit.dart';
import 'package:bus_system/features/driver/passenger_list/views/widgets/passenger_list_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassengerListScreen extends StatelessWidget {
  final bool isRoot;
  const PassengerListScreen({super.key, this.isRoot = true});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // Using a sleek custom header instead of default AppBar
    return BlocProvider(
      create: (context) => PassengerListCubit()..fetchPassengers(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.width * 0.05,
                MediaQuery.of(context).padding.top + SizeConfig.height * 0.015,
                SizeConfig.width * 0.05,
                SizeConfig.height * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(SizeConfig.height * 0.035),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (!isRoot)
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: EdgeInsets.only(right: SizeConfig.width * 0.04),
                        padding: EdgeInsets.all(SizeConfig.height * 0.012),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.kPrimaryColor,
                          size: SizeConfig.height * 0.022,
                        ),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Passenger List',
                        style: TextStyle(
                          fontSize: SizeConfig.height * 0.026,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          letterSpacing: 0.1,
                        ),
                      ),
                      SizedBox(height: SizeConfig.height * 0.002),
                      Text(
                        "Today's Registered Passengers",
                        style: TextStyle(
                          fontSize: SizeConfig.height * 0.015,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Expanded(child: PassengerListScreenBody()),
          ],
        ),
      ),
    );
  }
}
