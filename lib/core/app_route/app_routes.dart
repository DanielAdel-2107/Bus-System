import 'package:bus_system/features/auth/sign_in/views/screens/sign_in_screen.dart';
import 'package:bus_system/features/driver/dashboard/view_models/cubit/driver_dashboard_cubit.dart';
import 'package:bus_system/features/driver/driver_main/views/screens/driver_main_screen.dart';
import 'package:bus_system/features/student/dashboard/views/screens/student_dashboard_screen.dart';
import 'package:bus_system/features/auth/select_role/select_role.dart';
import 'package:bus_system/features/auth/sign_up/views/screens/sign_up_screen.dart';
import 'package:bus_system/features/auth/driver_register/views/screens/driver_register_screen.dart';
import 'package:bus_system/features/auth/student_register/views/screens/student_register_screen.dart';
import 'package:bus_system/features/on_boarding/views/screens/on_boarding_screen.dart';
import 'package:bus_system/features/splash/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:bus_system/core/app_route/route_names.dart';
import 'package:bus_system/features/university/university_home/views/screens/university_dashboard_screen.dart';
import 'package:bus_system/features/university/university_home/views/screens/university_main_screen.dart';
import 'package:bus_system/features/university/pickup_management/views/screens/manage_pickup_screen.dart';
import 'package:bus_system/features/university/driver_verification/views/screens/driver_verification_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
        RouteNames.splashScreen: (context) => const SplashScreen(),
        RouteNames.onBoardingScreen: (context) => const OnboardingScreen(),
        RouteNames.signInScreen: (context) => const SignInScreen(),
        RouteNames.dashboardScreen: (context) => BlocProvider(
          create: (context) => DriverDashboardCubit(),
          child: const StudentDashboardScreen(),
        ),
        RouteNames.selectRoleScreen: (context) => const RoleSelectionScreen(),
        //
        RouteNames.signUpScreen: (context) {
          final role = ModalRoute.of(context)!.settings.arguments as String;
          return SignUpScreen(role: role);
        },
        RouteNames.driverRegisterScreen: (context) =>
            const DriverRegisterScreen(),
        RouteNames.studentRegisterScreen: (context) =>
            const StudentRegisterScreen(),
        RouteNames.driverDashboard: (context) => const DriverMainScreen(),
        RouteNames.universityDashboard: (context) =>
            const UniversityDashboardScreen(),
        RouteNames.managePickups: (context) => const ManagePickupScreen(),
        RouteNames.driverVerification: (context) =>
            const DriverVerificationScreen(),
        RouteNames.universityMain: (context) {
          final int? index = ModalRoute.of(context)?.settings.arguments as int?;
          return UniversityMainScreen(initialIndex: index ?? 0);
        },
      };
}
