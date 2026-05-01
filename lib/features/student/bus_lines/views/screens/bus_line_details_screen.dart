import 'dart:ui';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/features/student/bus_lines/view_models/cubit/bus_line_cubit.dart';
import 'package:bus_system/features/student/bus_lines/models/pickup_point_model.dart';
import 'package:bus_system/features/student/select_seat/views/screens/seat_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class BusLineDetailsScreen extends StatefulWidget {
  final String lineName;

  const BusLineDetailsScreen({
    super.key,
    required this.lineName,
  });

  @override
  State<BusLineDetailsScreen> createState() => _BusLineDetailsScreenState();
}

class _BusLineDetailsScreenState extends State<BusLineDetailsScreen> {
  final MapController _mapController = MapController();
  PickupPoint? _selectedPickup;

  void _animateToPickup(PickupPoint pickup) {
    _mapController.move(
      ll.LatLng(pickup.position.latitude, pickup.position.longitude),
      15.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BusLineCubit()..loadLineDetails(widget.lineName),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: BlocBuilder<BusLineCubit, BusLineState>(
          builder: (context, state) {
            if (state is BusLineLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppColors.kPrimaryColor),
                    const SizedBox(height: 20),
                    Text(state.message, style: GoogleFonts.poppins()),
                  ],
                ),
              );
            }

            if (state is BusLineError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              );
            }

            if (state is BusLineLoaded) {
              final pickups = state.pickupPoints;
              if (pickups.isEmpty) {
                return Center(
                  child: Text("No pickup points found for ${widget.lineName}"),
                );
              }

              final initialCenter = pickups.first.position;

              return Stack(
                children: [
                  // Map
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: ll.LatLng(initialCenter.latitude, initialCenter.longitude),
                      initialZoom: 14.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://mt{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}&hl=en',
                        subdomains: const ['0', '1', '2', '3'],
                        userAgentPackageName: 'com.example.bus_system',
                      ),
                      MarkerLayer(
                        markers: pickups.map((pickup) {
                          final isSelected = pickup == _selectedPickup;
                          return Marker(
                            point: ll.LatLng(pickup.position.latitude, pickup.position.longitude),
                            width: 60,
                            height: 60,
                            child: _buildMarker(pickup, isSelected),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  // Zoom Controls
                  _buildZoomControls(),

                  // Back Button
                  _buildBackButton(context),

                  // Draggable Bottom Sheet for Pickup Points
                  _buildDraggableSheet(pickups),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
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
      child: Icon(
        Icons.location_on_rounded,
        color: isSelected ? AppColors.kPrimaryColor : Colors.redAccent,
        size: isSelected ? 45 : 35,
      ).animate(target: isSelected ? 1 : 0).scale(duration: 200.ms),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      right: 20,
      child: SafeArea(
        child: Column(
          children: [
            _zoomButton(Icons.add, () {
              final currentZoom = _mapController.camera.zoom;
              _mapController.move(_mapController.camera.center, currentZoom + 1);
            }),
            const SizedBox(height: 8),
            _zoomButton(Icons.remove, () {
              final currentZoom = _mapController.camera.zoom;
              _mapController.move(_mapController.camera.center, currentZoom - 1);
            }),
          ],
        ),
      ),
    );
  }

  Widget _zoomButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child: Icon(icon, size: 22, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildDraggableSheet(List<PickupPoint> pickups) {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.15,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5)),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.lineName} Line",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "${pickups.length} points",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: pickups.length,
                  itemBuilder: (context, index) {
                    final pickup = pickups[index];
                    return _buildPickupListItem(pickup);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickupListItem(PickupPoint pickup) {
    final isSelected = pickup == _selectedPickup;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPickup = pickup;
        });
        _animateToPickup(pickup);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kPrimaryColor.withOpacity(0.04) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected ? AppColors.kPrimaryColor : Colors.grey.shade100,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.kPrimaryColor.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.kPrimaryColor : AppColors.kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.directions_bus_rounded,
                    color: isSelected ? Colors.white : AppColors.kPrimaryColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bus #${pickup.busNumber}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pickup.name,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      pickup.time,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kPrimaryColor,
                      ),
                    ),
                    Text(
                      "Departure",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.withOpacity(0.1), height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_rounded, size: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pickup.driverName,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SeatSelectionScreen(driverId: pickup.driverId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Book Now",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
