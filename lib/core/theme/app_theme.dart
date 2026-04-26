import 'package:bus_system/core/theme/dark_theme.dart';
import 'package:bus_system/core/theme/light_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => lightTheme;
  static ThemeData get dark => darkTheme;
}
