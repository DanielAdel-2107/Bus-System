import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/university/driver_verification/models/driver_model.dart';
import 'package:bus_system/features/university/driver_verification/view_models/driver_verification_cubit/driver_verification_cubit.dart';
import 'package:bus_system/features/university/driver_verification/view_models/driver_verification_cubit/driver_verification_state.dart';
import 'package:bus_system/features/university/driver_verification/views/widgets/driver_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';

class DriverVerificationScreenBody extends StatelessWidget {
  const DriverVerificationScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DriverVerificationCubit, DriverVerificationState>(
      listener: (context, state) {
        if (state is DriverVerificationError) {
          CustomQuickAlert.dismiss(); // Clear any loading dialog
          CustomQuickAlert.error(title: 'Error', message: state.message);
        } else if (state is DriverVerificationSuccess && state.successMessage != null) {
          CustomQuickAlert.dismiss(); // Clear any loading dialog
          CustomQuickAlert.success(
            title: 'Success', 
            message: state.successMessage!,
            onConfirm: () {
              context.read<DriverVerificationCubit>().clearMessage();
            },
          );
        }
      },
      child: Stack(
        children: [
          _buildBackgroundHeader(),
          SafeArea(
            child: BlocBuilder<DriverVerificationCubit, DriverVerificationState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: state is DriverVerificationLoading
                      ? const Center(
                          key: ValueKey('loading'), 
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : state is! DriverVerificationSuccess
                          ? const SizedBox(key: ValueKey('empty_none'))
                          : _buildBody(context, state),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, DriverVerificationSuccess successState) {
    final allDrivers = successState.allDrivers;
    final selectedStatus = successState.selectedStatus;
    final drivers = successState.filteredDrivers;
    final pendingCount = allDrivers.where((d) => d.status == 'pending').length;
    final verifiedCount = allDrivers.where((d) => d.status == 'accepted').length;

    return Column(
      key: const ValueKey('body'),
      children: [
        _buildTopDashboard(context, pendingCount, verifiedCount),
        _buildFilterRow(context, selectedStatus, allDrivers),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: RefreshIndicator(
              color: AppColors.kPrimaryColor,
              onRefresh: () async {
                context.read<DriverVerificationCubit>().watchDrivers();
                await Future.delayed(const Duration(milliseconds: 800));
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: drivers.isEmpty
                    ? _buildEmptyState(selectedStatus)
                    : ListView.builder(
                        key: ValueKey('list_$selectedStatus'),
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.width * 0.05,
                        ).copyWith(
                          top: SizeConfig.height * 0.03,
                          bottom: SizeConfig.height * 0.05,
                        ),
                        itemCount: drivers.length,
                        itemBuilder: (context, index) {
                          return DriverCard(
                            key: ValueKey(drivers[index].id),
                            driver: drivers[index],
                            index: index,
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundHeader() {
    return Container(
      height: SizeConfig.height * 0.4,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.kPrimaryColor, AppColors.kSecondaryColor],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),
          Positioned(
            bottom: 60,
            left: -20,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopDashboard(BuildContext context, int pending, int verified) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.width * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8), // Replaced IconButton with a small spacing
          Text(
            'Driver Verifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: getResponsiveFontSize(fontSize: 22),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: SizeConfig.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Pending', pending.toString(), Icons.pending_actions_rounded, Colors.orangeAccent),
              _buildStatCard('Verified', verified.toString(), Icons.verified_user_rounded, Colors.greenAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: SizeConfig.width * 0.4,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: getResponsiveFontSize(fontSize: 24),
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: getResponsiveFontSize(fontSize: 14),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack);
  }

  Widget _buildFilterRow(BuildContext context, String selectedStatus, List<Driver> allDrivers) {
    final pendingCount = allDrivers.where((d) => d.status == 'pending').length;
    final acceptedCount = allDrivers.where((d) => d.status == 'accepted').length;
    final rejectedCount = allDrivers.where((d) => d.status == 'rejected').length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.width * 0.05),
        child: Row(
          children: [
            _buildFilterChip(context, 'All', 'all', selectedStatus, allDrivers.length),
            const SizedBox(width: 12),
            _buildFilterChip(context, 'Pending', 'pending', selectedStatus, pendingCount),
            const SizedBox(width: 12),
            _buildFilterChip(context, 'Accepted', 'accepted', selectedStatus, acceptedCount),
            const SizedBox(width: 12),
            _buildFilterChip(context, 'Rejected', 'rejected', selectedStatus, rejectedCount),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String value, String current, int count) {
    final isSelected = value == current;
    return GestureDetector(
      onTap: () => context.read<DriverVerificationCubit>().filterDrivers(value),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.kPrimaryColor : AppColors.textSecondary.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.kPrimaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : AppColors.kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.kPrimaryColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String selectedStatus) {
    String message = 'All drivers are processed!';
    IconData icon = Icons.fact_check_rounded;
    Color color = AppColors.kPrimaryColor;

    if (selectedStatus == 'pending') {
      message = 'No pending applications.';
      icon = Icons.hourglass_empty_rounded;
      color = Colors.orange;
    } else if (selectedStatus == 'rejected') {
      message = 'No rejected drivers.';
      icon = Icons.person_off_rounded;
      color = Colors.red;
    } else if (selectedStatus == 'accepted') {
      message = 'No accepted drivers yet.';
      icon = Icons.verified_user_rounded;
      color = Colors.green;
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: SizeConfig.height * 0.5,
        alignment: Alignment.center,
        child: Column(
          key: const ValueKey('empty'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 80, color: color.withOpacity(0.4)),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: getResponsiveFontSize(fontSize: 20),
                fontWeight: FontWeight.w800,
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'New driver registration requests will appear here in real-time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.6),
                  fontSize: getResponsiveFontSize(fontSize: 14),
                  height: 1.5,
                ),
              ),
            ).animate().fadeIn(delay: 400.ms),
          ],
        ),
      ),
    );
  }
}
