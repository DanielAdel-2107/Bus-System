import 'dart:ui';
import 'package:bus_system/core/cache/cache_helper.dart';
import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/core/network/supabase/auth/sign_out_.dart';
import 'package:bus_system/features/auth/sign_in/views/screens/sign_in_screen.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/features/settings/views/screens/settings_screen.dart';
import 'package:bus_system/features/student/dashboard/view_models/student_dashboard_cubit/student_dashboard_cubit.dart';
import 'package:bus_system/features/student/subscriptions/views/screens/subscriptions_screen.dart';
import 'package:bus_system/features/student/bus_lines/views/screens/bus_line_details_screen.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentDashboardBody extends StatelessWidget {
  const StudentDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentDashboardCubit, StudentDashboardState>(
      builder: (context, state) {
        if (state is StudentDashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is StudentDashboardError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(state.message, textAlign: TextAlign.center),
            ),
          );
        }

        if (state is StudentDashboardLoaded) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good morning 👋",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.studentName,
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.8,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        CustomQuickAlert.loading(message: "Logging out...");
                        try {
                          await SupabaseAuthService.signOut()
                              .timeout(const Duration(seconds: 5));
                          await getIt<CacheHelper>().clearData();

                          if (context.mounted) {
                            CustomQuickAlert.dismiss();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const SignInScreen()),
                              (route) => false,
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            CustomQuickAlert.dismiss();
                            await getIt<CacheHelper>().clearData();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const SignInScreen()),
                              (route) => false,
                            );
                          }
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.logout_rounded,
                            color: Colors.redAccent, size: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),


                // Subscription Status
                _buildSubscriptionSection(
                  state.hasActiveSubscription,
                  state.subscription,
                ),
                const SizedBox(height: 36),

                // To Sadat Academy Lines
                _buildBusLinesSection(context),
                const SizedBox(height: 36),


                // Active Booking
                _buildActiveBookingSection(state.activeBooking),
                const SizedBox(height: 40),

                // Quick Access
                _buildQuickAccessSection(context),
                const SizedBox(height: 40),
              ],
            ),
          );
        }

        return const Center(child: Text('Unexpected state'));
      },
    );
  }


  Widget _buildSubscriptionSection(
    bool isActive,
    Map<String, dynamic> subscription,
  ) {
    if (isActive) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${subscription['type']} Subscription",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Valid until ${subscription['end_date']}",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.kPrimaryColor.withOpacity(0.3),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Text(
                    "Active",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: AppColors.kPrimaryColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "No active subscription currently\nSubscribe to enjoy unlimited rides!",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.red[800]),
        ),
      );
    }
  }


  Widget _buildActiveBookingSection(Map<String, dynamic> booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Active Booking",
          style: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: AppColors.kPrimaryColor.withOpacity(0.12),
                blurRadius: 45,
                offset: const Offset(0, 22),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.directions_bus_rounded,
                      size: 30,
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking["bus"],
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          booking["pickup"],
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          booking["status"],
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kPrimaryColor,
                          ),
                        ),
                      ),
                      if (booking['distance'] != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          "${(booking['distance'] as double).toStringAsFixed(1)} km away",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.person_rounded,
                    size: 17,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      booking["driver"],
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (booking["seat"] != null) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.event_seat_rounded,
                      size: 17,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Seat ${booking["seat"]}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.withOpacity(0.15), height: 1),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: AppColors.kPrimaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Booking Date",
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    booking["time"],
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kPrimaryColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Access",
          style: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 165,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _modernQuickCard(
                Icons.credit_card_rounded,
                "Subscriptions",
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                ),
              ),
              _modernQuickCard(
                Icons.settings_rounded,
                "Settings",
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(isRoot: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _modernQuickCard(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        margin: const EdgeInsets.only(right: 18),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.kPrimaryColor, size: 30),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusLinesSection(BuildContext context) {
    final List<Map<String, dynamic>> lines = [
      {
        'name': 'Mokattam',
        'icon': Icons.terrain_rounded,
        'color': const Color(0xFF6366F1), // Indigo
        'bg': const Color(0xFFEEF2FF),
      },
      {
        'name': 'Nasr City',
        'icon': Icons.location_city_rounded,
        'color': const Color(0xFFF59E0B), // Amber
        'bg': const Color(0xFFFFFBEB),
      },
      {
        'name': '6 October',
        'icon': Icons.apartment_rounded,
        'color': const Color(0xFF10B981), // Emerald
        'bg': const Color(0xFFECFDF5),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "To Sadat Academy",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 195,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: lines.length,
            itemBuilder: (context, index) {
              final line = lines[index];
              final distance = (context.read<StudentDashboardCubit>().state as StudentDashboardLoaded).lineDistances[line['name']];
              return _buildLineCard(context, line, index, distance);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLineCard(BuildContext context, Map<String, dynamic> line, int index, double? distance) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BusLineDetailsScreen(lineName: line['name']),
            ),
          );
        },
        borderRadius: BorderRadius.circular(32),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: (line['color'] as Color).withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: (line['color'] as Color).withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: line['bg'],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  line['icon'],
                  color: line['color'],
                  size: 28,
                ),
              ),
              const Spacer(),
              Text(
                line['name'],
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                distance != null ? "${distance.toStringAsFixed(1)} km away" : "View Trips",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: distance != null ? (line['color'] as Color) : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.2, curve: Curves.easeOutCubic);
  }

  Widget _premiumSmallButton(
    String text,
    VoidCallback onTap, {
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimaryColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(
                color: AppColors.kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 10),
              Icon(icon, color: AppColors.kPrimaryColor, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
