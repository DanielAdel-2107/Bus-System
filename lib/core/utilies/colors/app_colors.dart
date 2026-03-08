import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color kPrimaryColor = Color(0xFF27AE60);
  static const Color kSecondaryColor = Color(0xFF81C784);
  static const Color waveColor = Color(0xFF27AE60);
  static Color gridColor = Colors.grey.withOpacity(0.3);

  static const Color primaryBlue = Color(0xFF0D4C73);
  static const Color lightBlue = Color(0xFF2F8FBE);
  static const Color primaryGreen = Color(0xFF3FAF6C);

  static const Color background = Color(0xFFF5F7FA);
  static const Color white = Colors.white;
  static const Color cardColor = Colors.white;

  static const Color accentBlue = Color(0xFF1C7ED6);
  static const Color accentGreen = Color(0xFF2FBF71);

  static const Color textPrimary = primaryBlue;
  static const Color textSecondary = Color(0xFF6C757D);

  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFE03131);
  static const Color warning = Color(0xFFF59F00);

  static const Color maleSeat = Color(0xFF4C9AFF);
  static const Color femaleSeat = Color(0xFFFF6B9D);
  static const Color availableSeat = Color(0xFFE9ECEF);
  static const Color selectedSeat = primaryGreen;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [kPrimaryColor, kSecondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFF0F7FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
