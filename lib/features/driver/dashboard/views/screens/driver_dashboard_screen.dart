import 'package:bus_system/core/cache/cache_helper.dart';
import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/core/network/supabase/auth/sign_out_.dart';
import 'package:bus_system/features/auth/sign_in/views/screens/sign_in_screen.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:bus_system/features/driver/dashboard/view_models/cubit/driver_dashboard_cubit.dart';
import 'package:bus_system/features/driver/dashboard/views/widgets/driver_dashboard_screen_body.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverDashboardCubit()..getDashboardData(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Dashboard',
            style: AppTextStyles.title20BlackW500.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                CustomQuickAlert.loading(message: "Logging out...");
                try {
                  await SupabaseAuthService.signOut().timeout(const Duration(seconds: 5));
                  await getIt<CacheHelper>().clearData();
                  
                  if (context.mounted) {
                    CustomQuickAlert.dismiss();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    CustomQuickAlert.dismiss();
                    await getIt<CacheHelper>().clearData();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                      (route) => false,
                    );
                  }
                }
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: const DriverDashboardScreenBody(),
      ),
    );
  }
}
