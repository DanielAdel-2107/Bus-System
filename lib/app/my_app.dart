import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/core/theme/app_theme.dart';
import 'package:bus_system/features/settings/view_models/settings_cubit/settings_cubit.dart';
import 'package:bus_system/features/settings/view_models/settings_cubit/settings_state.dart';
import 'package:bus_system/features/splash/views/screens/splash_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:bus_system/core/app_route/app_routes.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsCubit>(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              SizeConfig.init(context);
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                builder: DevicePreview.appBuilder,
                debugShowMaterialGrid: false,
                useInheritedMediaQuery: true,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: state.settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                routes: AppRoutes.routes,
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
