import 'package:flutter/material.dart';

class SubscriptionPlan {
  final String name;
  final String period;
  final String price;
  final String saveText;
  final IconData icon;
  final Color color;
  final bool isPopular;
  final List<String> features;
  final int durationMonths; // مهم لتحديد end_date

  const SubscriptionPlan({
    required this.name,
    required this.period,
    required this.price,
    required this.saveText,
    required this.icon,
    required this.color,
    required this.isPopular,
    required this.features,
    required this.durationMonths,
  });
}