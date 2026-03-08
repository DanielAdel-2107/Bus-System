import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/features/student/subscriptions/models/subscriptions_plan_screen.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static final List<SubscriptionPlan> subscriptionPlans = [
    SubscriptionPlan(
      name: "Monthly",
      period: "1 Month",
      price: "450",
      saveText: "",
      icon: Icons.calendar_today_rounded,
      color: AppColors.kSecondaryColor,
      isPopular: false,
      features: [
        "Unlimited trips",
        "Live GPS tracking",
        "Chat with driver",
        "Cancel anytime",
      ],
      durationMonths: 1,
    ),
    SubscriptionPlan(
      name: "Semester",
      period: "3 Months",
      price: "1250",
      saveText: "Save 100 EGP",
      icon: Icons.school_rounded,
      color: AppColors.kPrimaryColor,
      isPopular: false,
      features: [
        "All Monthly features",
        "Priority seat selection",
        "Trip history & reports",
        "Free pickup & drop-off",
      ],
      durationMonths: 3,
    ),
    SubscriptionPlan(
      name: "Yearly",
      period: "12 Months",
      price: "4200",
      saveText: "Save 1200 EGP • Best Value",
      icon: Icons.emoji_events_rounded,
      color: Color(0xFFFFC107),
      isPopular: true,
      features: [
        "All Semester features",
        "VIP Support",
        "Free university merch",
        "2 months free",
        "Exclusive student events",
      ],
      durationMonths: 12,
    ),
  ];
}
