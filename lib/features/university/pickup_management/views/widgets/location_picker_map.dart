import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LocationPickerMap extends StatefulWidget {
  final ll.LatLng? initialLocation;
  const LocationPickerMap({super.key, this.initialLocation});

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  ll.LatLng? _selectedLocation;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation = ll.LatLng(
        widget.initialLocation!.latitude,
        widget.initialLocation!.longitude,
      );
    } else {
      _selectedLocation = const ll.LatLng(30.0444, 31.2357); // Cairo default
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Pin Location',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w900,
            fontSize: getResponsiveFontSize(fontSize: 20),
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation!,
              initialZoom: 15.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedLocation = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.bus_system',
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.kPrimaryColor,
                        size: 40,
                      ),
                    )
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: SizeConfig.height * 0.05,
            left: SizeConfig.width * 0.1,
            right: SizeConfig.width * 0.1,
            child: GestureDetector(
              onTap: () {
                if (_selectedLocation != null) {
                  Navigator.pop(
                    context,
                    ll.LatLng(
                      _selectedLocation!.latitude,
                      _selectedLocation!.longitude,
                    ),
                  );
                }
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.kPrimaryColor,
                      AppColors.kPrimaryColor.withBlue(200),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kPrimaryColor.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Confirm Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: getResponsiveFontSize(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ).animate().slideY(
                  begin: 1,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOutBack,
                ),
          ),
        ],
      ),
    );
  }
}
