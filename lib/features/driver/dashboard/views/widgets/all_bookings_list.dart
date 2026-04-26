import 'package:flutter/material.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/driver/dashboard/models/booking_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AllBookingsList extends StatelessWidget {
  final List<BookingModel> bookings;

  const AllBookingsList({
    super.key,
    required this.bookings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'All Bookings',
              style: AppTextStyles.title18BlackW600.copyWith(
                fontSize: 20,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${bookings.length} Total',
                style: AppTextStyles.title14PrimaryColor.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.height * 0.02),
        if (bookings.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.height * 0.05),
              child: Column(
                children: [
                   Container(
                     padding: const EdgeInsets.all(20),
                     decoration: BoxDecoration(
                       color: Colors.grey.withOpacity(0.1),
                       shape: BoxShape.circle,
                     ),
                     child: Icon(Icons.event_busy_rounded, size: 60, color: AppColors.textSecondary.withOpacity(0.6)),
                   ),
                  SizedBox(height: SizeConfig.height * 0.02),
                  Text(
                    'No bookings yet.',
                    style: AppTextStyles.title16BlackW500.copyWith(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: SizeConfig.height * 0.01),
                  Text(
                    'There are currently no scheduled trips.',
                    style: AppTextStyles.title14Grey,
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 500.ms)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookings.length,
            separatorBuilder: (context, index) => SizedBox(height: SizeConfig.height * 0.02),
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return _buildBookingItem(booking, index);
            },
          ),
      ],
    );
  }

  Widget _buildBookingItem(BookingModel booking, int index) {
    final studentName = booking.studentName ?? 'Unknown Student';
    final seatNumber = booking.seatNumber;

    return Container(
      padding: EdgeInsets.all(SizeConfig.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: SizeConfig.width * 0.14,
            height: SizeConfig.width * 0.14,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue.withOpacity(0.15), AppColors.primaryBlue.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Seat',
                    style: AppTextStyles.title12PrimaryColorW500.copyWith(fontSize: 10),
                  ),
                  Text(
                    seatNumber.toString(),
                    style: AppTextStyles.title18PrimaryColorW500.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: SizeConfig.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: AppTextStyles.title16BlackW500.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: SizeConfig.height * 0.005),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'Ready for pickup',
                      style: AppTextStyles.title12Grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Confirmed',
                  style: AppTextStyles.title12BlackColorW400.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (100 * index).ms).slideX(begin: 0.1, curve: Curves.easeOutQuad);
  }
}
