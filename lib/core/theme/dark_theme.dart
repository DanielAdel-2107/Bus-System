import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.kPrimaryColor,
  scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
  cardColor: const Color(0xFF1E293B), // Slate 800
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.kPrimaryColor,
    primary: AppColors.kPrimaryColor,
    secondary: AppColors.kSecondaryColor,
    surface: const Color(0xFF1E293B),
    background: const Color(0xFF0F172A),
    brightness: Brightness.dark,
  ),
);
