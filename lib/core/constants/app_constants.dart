import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/features/student/subscriptions/models/subscriptions_plan_screen.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static final List<SubscriptionPlan> subscriptionPlans = [
    SubscriptionPlan(
      name: "Semester",
      period: "4 Months",
      price: "5000",
      saveText: "Best for short term",
      icon: Icons.school_rounded,
      color: AppColors.kPrimaryColor,
      isPopular: false,
      features: [
        "Unlimited trips per semester",
        "Live GPS tracking",
        "Priority seat selection",
        "Chat with driver",
      ],
      durationMonths: 4,
    ),
    SubscriptionPlan(
      name: "Yearly",
      period: "1 Year",
      price: "10000",
      saveText: "Save 20% • Full academic year",
      icon: Icons.emoji_events_rounded,
      color: const Color(0xFFFFC107),
      isPopular: true,
      features: [
        "All Semester features",
        "VIP Support 24/7",
        "Free university merch",
        "Exclusive student events",
        "Full year coverage",
      ],
      durationMonths: 12,
    ),
  ];
}
