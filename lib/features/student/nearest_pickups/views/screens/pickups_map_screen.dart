import 'dart:ui';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/features/student/nearest_pickups/models/pickup_point_model.dart';
import 'package:bus_system/features/student/select_seat/views/screens/seat_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:flutter_animate/flutter_animate.dart';

class PickupsMapScreen extends StatefulWidget {
  final List<PickupPoint> pickups;
  final PickupPoint? initialPickup;

  const PickupsMapScreen({
    super.key,
    required this.pickups,
    this.initialPickup,
  });

  @override
  State<PickupsMapScreen> createState() => _PickupsMapScreenState();
}

class _PickupsMapScreenState extends State<PickupsMapScreen> {
  final MapController _mapController = MapController();
  PickupPoint? _selectedPickup;

  @override
  void initState() {
    super.initState();
    _selectedPickup = widget.initialPickup;
  }

  void _animateToPickup(PickupPoint pickup) {
    _mapController.move(
      ll.LatLng(pickup.position.latitude, pickup.position.longitude),
      15.0,
    );
  }

  Widget _buildMarker(PickupPoint pickup, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPickup = pickup;
        });
        _animateToPickup(pickup);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.kPrimaryColor.withOpacity(0.3),
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5), duration: 1500.ms)
                .fadeOut(duration: 1500.ms),
          Container(
            width: isSelected ? 42 : 36,
            height: isSelected ? 42 : 36,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.kPrimaryColor : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : AppColors.kPrimaryColor,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.directions_bus_rounded,
              size: isSelected ? 22 : 18,
              color: isSelected ? Colors.white : AppColors.kPrimaryColor,
            ),
          ).animate(target: isSelected ? 1 : 0).scale(duration: 300.ms),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initialCenter = _selectedPickup?.position ??
        (widget.pickups.isNotEmpty
            ? widget.pickups.first.position
            : const ll.LatLng(30.0444, 31.2357));

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: ll.LatLng(initialCenter.latitude, initialCenter.longitude),
              initialZoom: _selectedPickup != null ? 15.0 : 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.bus_system',
              ),
              MarkerLayer(
                markers: widget.pickups.map((pickup) {
                  final isSelected = pickup == _selectedPickup;
                  return Marker(
                    point: ll.LatLng(pickup.position.latitude, pickup.position.longitude),
                    width: 70,
                    height: 70,
                    child: _buildMarker(pickup, isSelected),
                  );
                }).toList(),
              ),
            ],
          ),

          // Glassmorphic Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20, color: AppColors.textPrimary),
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
          ),

          // Selected Pickup Info Card
          if (_selectedPickup != null)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: _buildPickupInfoCard(_selectedPickup!),
            ).animate().slideY(begin: 0.5, curve: Curves.easeOutCubic).fadeIn(),
        ],
      ),
    );
  }

  Widget _buildPickupInfoCard(PickupPoint pickup) {
    final hasDriver = pickup.driverId.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.all(SizeConfig.width * 0.05),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_bus_rounded,
                      color: AppColors.kPrimaryColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pickup.name,
                          style: TextStyle(
                            fontSize: getResponsiveFontSize(fontSize: 18),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.schedule_rounded,
                                size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                hasDriver ? "Arriving at ${pickup.time}" : "Not Scheduled",
                                style: TextStyle(
                                  fontSize: getResponsiveFontSize(fontSize: 13),
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on_rounded, color: AppColors.kPrimaryColor, size: 14),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              pickup.distanceText,
                              style: TextStyle(
                                color: AppColors.kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: hasDriver
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SeatSelectionScreen(
                                driverId: pickup.driverId,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasDriver ? AppColors.kPrimaryColor : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: hasDriver ? 6 : 0,
                    shadowColor: AppColors.kPrimaryColor.withOpacity(0.4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hasDriver ? "Book This Trip" : "Unavailable",
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(fontSize: 16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (hasDriver) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

