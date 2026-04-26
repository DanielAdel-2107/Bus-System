import 'dart:ui';
import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/university/pickup_management/view_models/manage_pickup_cubit/manage_pickup_cubit.dart';
import 'package:bus_system/features/university/pickup_management/view_models/manage_pickup_cubit/manage_pickup_state.dart';
import 'package:bus_system/features/university/pickup_management/views/widgets/add_edit_pickup_sheet.dart';
import 'package:bus_system/features/university/pickup_management/views/widgets/pickup_card.dart';
import 'package:flutter/material.dart';
import 'package:bus_system/features/university/pickup_management/models/pickup_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';

class ManagePickupScreenBody extends StatelessWidget {
  const ManagePickupScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ManagePickupCubit, ManagePickupState>(
      listener: (context, state) {
        if (state is ManagePickupError) {
          CustomQuickAlert.dismiss(); // Clear any existing dialogs
          CustomQuickAlert.error(title: 'Error', message: state.message);
        }
      },
      child: Stack(
        children: [
          _buildBackgroundHeader(),
          SafeArea(
            child: BlocBuilder<ManagePickupCubit, ManagePickupState>(
              builder: (context, state) {
                if (state is ManagePickupLoading &&
                    state is! ManagePickupSuccess) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                final List<PickupPoint> pickups = (state is ManagePickupSuccess)
                    ? state.pickups
                    : [];

                return Column(
                  children: [
                    _buildTopDashboard(pickups.length),
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
                          backgroundColor: Colors.white,
                          onRefresh: () async {
                            context.read<ManagePickupCubit>().watchPickups();
                            await Future.delayed(const Duration(milliseconds: 800));
                          },
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.width * 0.05,
                            ).copyWith(
                              top: SizeConfig.height * 0.03,
                              bottom: SizeConfig.height * 0.1,
                            ),
                            itemCount: pickups.length + 1,
                            itemBuilder: (context, index) {
                              if (index == pickups.length) {
                                return _buildAddNewCard(context);
                              }
                              return PickupCard(
                                pickup: pickups[index],
                                index: index,
                              ).animate().scale(
                                    begin: const Offset(0.9, 0.9),
                                    duration: 400.ms,
                                    curve: Curves.easeOutBack,
                                  );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundHeader() {
    return Container(
      height: SizeConfig.height * 0.35,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.kPrimaryColor,
            AppColors.kPrimaryColor.withBlue(200),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),
          Positioned(
            bottom: 40,
            left: -30,
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopDashboard(int count) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.width * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Managing Pickup Points',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: getResponsiveFontSize(fontSize: 16),
              fontWeight: FontWeight.w600,
            ),
          ).animate().fadeIn(duration: 400.ms),
          SizedBox(height: SizeConfig.height * 0.005),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$count Active Hubs',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveFontSize(fontSize: 28),
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ).animate().slideX(begin: -0.2).fadeIn(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Filter',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: getResponsiveFontSize(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),
            ],
          ),
          SizedBox(height: SizeConfig.height * 0.025),
          _buildGlassSearchBar(),
        ],
      ),
    );
  }

  Widget _buildGlassSearchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.7)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search stations, areas, labels...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(begin: const Offset(0.9, 0.9), delay: 300.ms).fadeIn();
  }

  Widget _buildAddNewCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (sheetContext) => BlocProvider.value(
            value: context.read<ManagePickupCubit>(),
            child: const AddEditPickupSheet(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: SizeConfig.height * 0.02),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              AppColors.kPrimaryColor.withOpacity(0.02),
              AppColors.kPrimaryColor.withOpacity(0.06),
            ],
          ),
          border: Border.all(
            color: AppColors.kPrimaryColor.withOpacity(0.15),
            width: 2,
            style: BorderStyle.none,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.05,
                child: Icon(
                  Icons.add_location_alt_rounded,
                  size: 60,
                  color: AppColors.kPrimaryColor,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.kPrimaryColor.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Add New Point',
                  style: TextStyle(
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }
}
