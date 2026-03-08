import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bus_system/features/auth/sign_up/view_models/cubit/sign_up_cubit.dart';
import 'package:bus_system/features/auth/sign_up/views/screens/sign_up_screen.dart';
import 'package:bus_system/features/on_boarding/views/screens/on_boarding_screen.dart';
import 'package:bus_system/features/splash/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:bus_system/core/app_route/route_names.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    RouteNames.splashScreen: (context) => const SplashScreen(),
    RouteNames.onBoardingScreen: (context) => const OnboardingScreen(),
    //
    RouteNames.signUpScreen: (context) => BlocProvider(
          create: (context) => SignUpCubit(),
          child: const SignUpScreen(),
        ),
    //
    // RouteNames.signInScreen: (context) => BlocProvider(
    //       create: (context) => SignInCubit(),
    //       child: const SignInScreen(),
    //     ),
    //
  };
}
