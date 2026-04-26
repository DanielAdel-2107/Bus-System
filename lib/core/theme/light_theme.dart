import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.kPrimaryColor,
  scaffoldBackgroundColor: AppColors.background,
  cardColor: AppColors.cardColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: AppColors.textPrimary),
  ),
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    bodyLarge: const TextStyle(color: AppColors.textPrimary),
    bodyMedium: const TextStyle(color: AppColors.textPrimary),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.kPrimaryColor,
    primary: AppColors.kPrimaryColor,
    secondary: AppColors.kSecondaryColor,
    surface: AppColors.cardColor,
    background: AppColors.background,
    brightness: Brightness.light,
  ),
);
