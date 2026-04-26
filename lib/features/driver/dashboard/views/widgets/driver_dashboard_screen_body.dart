import 'package:bus_system/core/components/custom_loading_widget.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/driver/dashboard/view_models/cubit/driver_dashboard_cubit.dart';
import 'package:bus_system/features/driver/dashboard/view_models/cubit/driver_dashboard_state.dart';
import 'package:bus_system/features/driver/dashboard/views/widgets/bus_info_card.dart';
import 'package:bus_system/features/driver/dashboard/views/widgets/statistics_cards.dart';
import 'package:bus_system/features/driver/dashboard/views/widgets/all_bookings_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverDashboardScreenBody extends StatelessWidget {
  const DriverDashboardScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<DriverDashboardCubit, DriverDashboardState>(
      builder: (context, state) {
        if (state is DriverDashboardLoading) {
          return const Center(child: CustomLoadingWidget());
        }

        if (state is DriverDashboardFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                state.errorMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.red.shade400),
              ),
            ),
          );
        }

        // ── Pending approval screen
        if (state is DriverDashboardPending) {
          return _PendingApprovalBody(driverInfo: state.driverInfo);
        }

        if (state is DriverDashboardSuccess) {
          return RefreshIndicator(
            onRefresh: () =>
                context.read<DriverDashboardCubit>().getDashboardData(),
            color: AppColors.primaryBlue,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width * 0.05),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.height * 0.02),
                  BusInfoCard(
                    busNumber: state.driverInfo.busNumber.isNotEmpty
                        ? state.driverInfo.busNumber
                        : 'N/A',
                    licenseNumber: state.driverInfo.licenseNumber.isNotEmpty
                        ? state.driverInfo.licenseNumber
                        : 'N/A',
                  ),
                  SizedBox(height: SizeConfig.height * 0.03),
                  StatisticsCards(
                    totalSeats: state.totalSeats,
                    occupiedSeats: state.occupiedSeats,
                  ),
                  SizedBox(height: SizeConfig.height * 0.04),
                  AllBookingsList(bookings: state.allBookings),
                  SizedBox(height: SizeConfig.height * 0.04),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

// ── Pending Approval UI ────────────────────────────────────────────────────

class _PendingApprovalBody extends StatelessWidget {
  final dynamic driverInfo;
  const _PendingApprovalBody({required this.driverInfo});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: Column(
          children: [
            // Animated pending icon
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue.withOpacity(0.08),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.hourglass_top_rounded,
                size: 64,
                color: AppColors.primaryBlue,
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 2000.ms, color: AppColors.lightBlue.withOpacity(0.4))
                .then()
                .scale(begin: const Offset(1, 1), end: const Offset(1.04, 1.04), duration: 900.ms)
                .then()
                .scale(begin: const Offset(1.04, 1.04), end: const Offset(1, 1), duration: 900.ms),

            const SizedBox(height: 36),

            Text(
              'Awaiting Approval',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),

            const SizedBox(height: 12),

            Text(
              'Your registration has been submitted successfully.\nThe university team will review and approve your account shortly.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 40),

            // Info card with submitted details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Submitted Information',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _infoRow(Icons.directions_bus_rounded, 'Bus Number',
                      driverInfo.busNumber.isNotEmpty ? driverInfo.busNumber : '—'),
                  const SizedBox(height: 10),
                  _infoRow(Icons.badge_rounded, 'License Number',
                      driverInfo.licenseNumber.isNotEmpty ? driverInfo.licenseNumber : '—'),
                  const SizedBox(height: 10),
                  _infoRow(Icons.event_seat_rounded, 'Total Seats',
                      driverInfo.totalSeats.toString()),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),

            const SizedBox(height: 32),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.orange.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule_rounded, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Status: Pending Review',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 800.ms),

            const SizedBox(height: 20),

            // Refresh button
            TextButton.icon(
              onPressed: () =>
                  context.read<DriverDashboardCubit>().getDashboardData(),
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(
                'Check again',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
            ).animate().fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primaryBlue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
