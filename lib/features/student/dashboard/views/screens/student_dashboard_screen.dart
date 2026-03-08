import 'dart:developer' show log;

import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/features/student/nearest_pickups/views/screens/nearest_pickups_screen.dart';
import 'package:bus_system/features/student/subscriptions/views/screens/subscriptions_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> fetchDashboardData() async {
    emit(DashboardLoading());

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        emit(DashboardError('Not logged in'));
        return;
      }

      final userId = user.id;

      // 1. Subscription
      final subRes = await supabase
          .from('subscriptions')
          .select()
          .eq('student_id', userId)
          .maybeSingle();

      Map<String, dynamic> subscription = {
        'type': 'Not specified',
        'end_date': 'Not specified',
        'is_active': false,
      };
      bool hasActiveSub = false;

      if (subRes != null) {
        subscription = {
          'type': subRes['type']?.toString() ?? 'Semester',
          'end_date': (subRes['end_date'] as String?)?.split('T')[0] ?? 'Not specified',
          'is_active': subRes['is_active'] == true,
        };
        hasActiveSub = subscription['is_active'] == true;
      }

      // 2. Student name
      String studentName = 'Student';
      final profile = await supabase
          .from('profiles')
          .select('full_name')
          .eq('id', userId)
          .maybeSingle();

      if (profile != null && profile['full_name'] != null) {
        studentName = profile['full_name'] as String;
      }

      // 3. Coordinates (temporary - replace with geolocator later)
      const double userLat = 26.5569;
      const double userLng = 31.7000;

      // 4. Nearest pickup (using RPC)
      Map<String, dynamic> nearestPickup = {
        'location': 'No nearby points',
        'distance': '',
        'next_bus_time': 'Not available',
      };

      final nearestRes = await supabase
          .rpc('get_nearest_pickup', params: {
            'student_lat': userLat,
            'student_lng': userLng,
          }).maybeSingle();

      if (nearestRes != null) {
        final distMeters = nearestRes['distance_meters'] as num?;
        nearestPickup = {
          'location': nearestRes['name'] ?? nearestRes['address'] ?? 'Unknown',
          'distance': _formatDistance(distMeters),
          'next_bus_time': '07:30 AM',
        };
      }

      // 5. All available pickups (using RPC)
      List<Map<String, dynamic>> availablePickups = [];

      final pickupsRes = await supabase.rpc(
        'get_all_pickup_points_with_distance',
        params: {
          'p_user_lat': userLat,
          'p_user_lon': userLng,
        },
      );
      log('Available pickups RPC result: $pickupsRes');
      if (pickupsRes is List && pickupsRes.isNotEmpty) {
        availablePickups = pickupsRes.map((row) {
          final distKm = (row['distance_km'] as num?)?.toDouble() ?? 999.9;

          return {
            'area': row['name'] ?? 'Unknown area',
            'point': row['address'] ?? row['pickup_name'] ?? '',
            'time': '07:30 AM', // temporary
            'bus': row['bus_number']?.toString() ?? 'Not specified',
            'driver': row['driver_name']?.toString() ?? 'Unknown',
            'distance': _formatDistanceKm(distKm),
          };
        }).toList();
      }

      // 6. Active / latest booking – REAL DATA from RPC
      Map<String, dynamic> activeBooking = {
        'bus': 'No active booking',
        'pickup': '—',
        'driver': '—',
        'time': '—',
        'status': 'None',
        'seat': null,
      };

      final bookingRes = await supabase
          .rpc('get_student_latest_active_booking', params: {'p_student_id': userId})
          .maybeSingle();

      if (bookingRes != null && bookingRes.isNotEmpty) {
        activeBooking = {
          'bus': bookingRes['bus_number']?.toString() ?? '—',
          'pickup': '—', // ← can be improved later with extra join
          'driver': bookingRes['driver_name']?.toString() ?? 'Unknown',
          'time': '07:20 AM', // ← still placeholder – consider adding schedule later
          'status': (bookingRes['status'] as String? ?? 'booked').toUpperCase(),
          'seat': bookingRes['seat_number'],
        };
      }

      emit(DashboardLoaded(
        studentName: studentName,
        subscription: subscription,
        nearestPickup: nearestPickup,
        availablePickups: availablePickups,
        activeBooking: activeBooking,
        hasActiveSubscription: hasActiveSub,
      ));
    } catch (e, stack) {
      emit(DashboardError('Error loading dashboard: $e'));
      debugPrint('Dashboard error: $e\n$stack');
    }
  }

  String _formatDistance(num? meters) {
    if (meters == null || meters <= 0) return '';
    if (meters < 1000) return '${meters.toStringAsFixed(0)} m';
    final km = meters / 1000;
    return '${km.toStringAsFixed(1)} km';
  }

  String _formatDistanceKm(double? km) {
    if (km == null || km <= 0) return 'Not available';
    if (km < 1) return '${(km * 1000).toStringAsFixed(0)} m';
    return '${km.toStringAsFixed(1)} km';
  }
}

// ──────────────────────────────────────────────── States ────────────────────────────────────────────────

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final String studentName;
  final Map<String, dynamic> subscription;
  final Map<String, dynamic> nearestPickup;
  final List<Map<String, dynamic>> availablePickups;
  final Map<String, dynamic> activeBooking;
  final bool hasActiveSubscription;

  DashboardLoaded({
    required this.studentName,
    required this.subscription,
    required this.nearestPickup,
    required this.availablePickups,
    required this.activeBooking,
    required this.hasActiveSubscription,
  });
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}

// ──────────────────────────────────────────────── Screen (your original English UI – only active booking part updated)

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is DashboardError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(state.message, textAlign: TextAlign.center),
              ),
            ),
          );
        }

        if (state is DashboardLoaded) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header - English, no avatar, no university name
                    Text(
                      "Good morning, ${state.studentName} 👋",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.8,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Nearest Pickup ── unchanged
                    Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        gradient: AppColors.cardGradient,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.15),
                            blurRadius: 65,
                            offset: const Offset(0, 25),
                          ),
                          BoxShadow(
                            color: AppColors.kPrimaryColor.withOpacity(0.1),
                            blurRadius: 35,
                            offset: const Offset(0, 12),
                          ),
                        ],
                        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star_rounded, size: 40, color: AppColors.kPrimaryColor),
                              const SizedBox(width: 14),
                              Text(
                                "Nearest Pickup Point",
                                style: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              state.nearestPickup['location'],
                              style: GoogleFonts.poppins(
                                fontSize: 27.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.9,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.nearestPickup['distance'].isNotEmpty
                                ? "${state.nearestPickup['distance']} away • Next bus ${state.nearestPickup['next_bus_time']}"
                                : "No nearby pickup points available",
                            style: GoogleFonts.poppins(fontSize: 16.5, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 26),
                          _premiumButton("Book Now 🚀", () {}, icon: Icons.arrow_forward_rounded),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms).scale(
                          begin: const Offset(0.9, 0.9),
                          curve: Curves.easeOutBack,
                        ),
                    const SizedBox(height: 32),

                    // Subscription Status ── unchanged
                    if (state.hasActiveSubscription)
                      ClipRRect(
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
                                  child: const Icon(Icons.verified, size: 44, color: Colors.white),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${state.subscription['type']} Subscription",
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "Valid until ${state.subscription['end_date']}",
                                        style: GoogleFonts.poppins(fontSize: 15, color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(color: AppColors.kPrimaryColor.withOpacity(0.3), blurRadius: 20),
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
                      )
                    else
                      Container(
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
                      ),
                    const SizedBox(height: 36),

                    // Available Pickups Today ── unchanged
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Available Pickups Today",
                          style: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "View All",
                            style: GoogleFonts.poppins(color: AppColors.kPrimaryColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (state.availablePickups.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Text("No pickups available at the moment", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        ),
                      )
                    else
                      SizedBox(
                        height: 162,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.availablePickups.length,
                          itemBuilder: (context, index) {
                            final p = state.availablePickups[index];
                            return Container(
                              width: 220,
                              margin: const EdgeInsets.only(right: 16),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 25, offset: const Offset(0, 15)),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p['area'],
                                    style: GoogleFonts.poppins(fontSize: 17.5, fontWeight: FontWeight.w700),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    p['point'],
                                    style: GoogleFonts.poppins(fontSize: 15, color: AppColors.textSecondary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        p['time'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 18.5,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.kPrimaryColor,
                                        ),
                                      ),
                                      Text(
                                        p['bus'],
                                        style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                  if (p['distance'].isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      "${p['distance']} away",
                                      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.kPrimaryColor.withOpacity(0.8)),
                                    ),
                                  ],
                                  if (p['driver'].isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      "Driver: ${p['driver']}",
                                      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ).animate().fadeIn(delay: (60 * index).ms).slideX(begin: 0.15);
                          },
                        ),
                      ),

                    const SizedBox(height: 36),

                    // Active Booking ── only this section updated (real data + seat)
                    Text(
                      "Active Booking",
                      style: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(color: AppColors.kPrimaryColor.withOpacity(0.12), blurRadius: 45, offset: const Offset(0, 22)),
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.kPrimaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Icon(Icons.directions_bus_rounded, size: 32, color: AppColors.kPrimaryColor),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.activeBooking["bus"],
                                            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            state.activeBooking["pickup"],
                                            style: GoogleFonts.poppins(fontSize: 16.5, color: AppColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  "Driver: ${state.activeBooking["driver"]}",
                                  style: GoogleFonts.poppins(fontSize: 15.5, color: AppColors.textSecondary),
                                ),
                                if (state.activeBooking["seat"] != null) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    "Seat: ${state.activeBooking["seat"]}",
                                    style: GoogleFonts.poppins(fontSize: 15, color: AppColors.textSecondary),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                                decoration: BoxDecoration(
                                  color: AppColors.kPrimaryColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  state.activeBooking["status"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.kPrimaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                state.activeBooking["time"],
                                style: GoogleFonts.poppins(
                                  fontSize: 29,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.kPrimaryColor,
                                  letterSpacing: -1,
                                ),
                              ),
                              Text(
                                "AM",
                                style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Quick Access ── unchanged
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
                            Icons.map_rounded,
                            "Nearest\nPickup Points",
                            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NearestPickupsScreen())),
                          ),
                          _modernQuickCard(
                            Icons.credit_card_rounded,
                            "Subscriptions",
                            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen())),
                          ),
                          _modernQuickCard(Icons.settings_rounded, "Settings", () {}),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: Text('Unexpected state')));
      },
    );
  }

  Widget _premiumButton(String text, VoidCallback onTap, {IconData? icon}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 19),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(color: AppColors.kPrimaryColor.withOpacity(0.4), blurRadius: 25, offset: const Offset(0, 12)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(fontSize: 17.5, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            if (icon != null) ...[
              const SizedBox(width: 10),
              Icon(icon, color: Colors.white, size: 24),
            ],
          ],
        ),
      ).animate().scale(duration: 300.ms, curve: Curves.easeOut),
    );
  }

  Widget _modernQuickCard(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: AppColors.kPrimaryColor.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 15)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 34, color: AppColors.kPrimaryColor),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14.5, fontWeight: FontWeight.w600, height: 1.2),
            ),
          ],
        ),
      ).animate().fadeIn().scale(),
    );
  }
}