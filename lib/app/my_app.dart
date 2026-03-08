// ignore_for_file: deprecated_member_use
import 'package:bus_system/features/splash/views/screens/splash_screen.dart';
import 'package:bus_system/features/student/dashboard/test.dart';
import 'package:bus_system/features/student/subscriptions/views/screens/subscriptions_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:bus_system/core/app_route/app_routes.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig.init(context);
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          builder: DevicePreview.appBuilder,
            useInheritedMediaQuery: true,
          routes: AppRoutes.routes,
          // initialRoute: RouteNames.splashScreen,
          home: SplashScreen(),
        );
      },
    );
  }
}
