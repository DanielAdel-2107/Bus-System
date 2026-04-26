import 'package:bus_system/core/components/custom_loading_widget.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/student/nearest_pickups/models/pickup_point_model.dart';
import 'package:bus_system/features/student/nearest_pickups/view_models/cubit/nearest_pickups_cubit.dart';
import 'package:bus_system/features/student/nearest_pickups/view_models/cubit/nearest_pickups_state.dart';
import 'package:bus_system/features/student/nearest_pickups/views/screens/pickups_map_screen.dart';
import 'package:bus_system/features/student/select_seat/views/screens/seat_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import '../widgets/pickup_card.dart';

class NearestPickupsScreenBody extends StatelessWidget {
  const NearestPickupsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const PickupHeader(),
          Expanded(
            child: BlocBuilder<NearestPickupsCubit, NearestPickupsState>(
              builder: (context, state) {
                if (state is NearestPickupsLoading) {
                  return _buildLoadingState(state.message);
                }

                if (state is NearestPickupsLocationServicesDisabled) {
                  return _buildMessage(
                    context: context,
                    icon: Icons.location_off_rounded,
                    title: "Location Services Disabled",
                    message: "Please enable location services (GPS) to find points near you.",
                    buttonText: "Enable Location",
                    onPressed: () async {
                      await Geolocator.openLocationSettings();
                      context.read<NearestPickupsCubit>().loadData();
                    },
                  );
                }

                if (state is NearestPickupsLocationPermissionDenied) {
                  return _buildMessage(
                    context: context,
                    icon: Icons.location_disabled_rounded,
                    title: "Location Permission Denied",
                    message: "Please allow location access in app settings.",
                    buttonText: "Open Settings",
                    onPressed: () async {
                      await Geolocator.openAppSettings();
                      context.read<NearestPickupsCubit>().loadData();
                    },
                  );
                }

                if (state is NearestPickupsError) {
                  return _buildMessage(
                    context: context,
                    icon: Icons.error_outline_rounded,
                    title: "An Error Occurred",
                    message: state.message,
                    buttonText: "Retry",
                    onPressed: () =>
                        context.read<NearestPickupsCubit>().loadData(),
                  );
                }

                if (state is NearestPickupsLoaded) {
                  if (state.pickups.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_outlined, size: 64, color: Colors.grey.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          const Text(
                            "No pickup points available currently.",
                            style: TextStyle(fontSize: 17, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      SizeConfig.width * 0.05,
                      SizeConfig.height * 0.02,
                      SizeConfig.width * 0.05,
                      SizeConfig.height * 0.10,
                    ),
                    itemCount: state.pickups.length,
                    itemBuilder: (context, index) {
                      final point = state.pickups[index];
                      return PickupCard(
                        point: point,
                        onTrackPressed: () => _navigate2Map(context, point),
                        onSelectPressed: point.driverId.isEmpty 
                              ? () => CustomQuickAlert.warning(
                                  title: "Unavailable",
                                  message: "No driver is currently assigned to this pickup point.",
                                )
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SeatSelectionScreen(
                                      driverId: point.driverId,
                                    ),
                                  ),
                                );
                              },
                      )
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: 60 * index))
                          .slideY(begin: 0.1, curve: Curves.easeOutQuad);
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<NearestPickupsCubit, NearestPickupsState>(
        builder: (context, state) {
          if (state is NearestPickupsLoaded && state.pickups.isNotEmpty) {
            return MapFAB(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PickupsMapScreen(pickups: state.pickups),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return CustomLoadingWidget(message: message);
  }

  Widget _buildMessage({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  void _navigate2Map(BuildContext context, PickupPoint point) {
    final state = context.read<NearestPickupsCubit>().state;
    if (state is NearestPickupsLoaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PickupsMapScreen(
            pickups: state.pickups,
            initialPickup: point,
          ),
        ),
      );
    }
  }
}

class PickupHeader extends StatelessWidget {
  const PickupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.width * 0.06,
        MediaQuery.of(context).padding.top + SizeConfig.height * 0.01,
        SizeConfig.width * 0.06,
        SizeConfig.height * 0.025,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: Offset(0, SizeConfig.height * 0.005),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                iconSize: 22,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 8),
              const Text(
                "Pickup Points",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Choose the nearest or most convenient stop",
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class MapFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const MapFAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: const Icon(Icons.map_rounded),
      label: const Text("View on Map", style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: AppColors.kPrimaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ).animate().scale(delay: 500.ms);
  }
}
