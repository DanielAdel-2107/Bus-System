import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:bus_system/features/student/select_seat/views/screens/seat_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

////////////////////////////////////////////////////////////////////////////////
// Model
////////////////////////////////////////////////////////////////////////////////

class PickupPoint {
  final String name;
  final LatLng position;
  final double distanceKm;
  final String time;
  final String busNumber;
  final String driverName;
  final bool isNearest;

  const PickupPoint({
    required this.name,
    required this.position,
    required this.distanceKm,
    required this.time,
    required this.busNumber,
    required this.driverName,
    this.isNearest = false,
  });

  String get distanceText => "${distanceKm.toStringAsFixed(1)} km";

  PickupPoint copyWith({
    String? name,
    LatLng? position,
    double? distanceKm,
    String? time,
    String? busNumber,
    String? driverName,
    bool? isNearest,
  }) {
    return PickupPoint(
      name: name ?? this.name,
      position: position ?? this.position,
      distanceKm: distanceKm ?? this.distanceKm,
      time: time ?? this.time,
      busNumber: busNumber ?? this.busNumber,
      driverName: driverName ?? this.driverName,
      isNearest: isNearest ?? this.isNearest,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// States
////////////////////////////////////////////////////////////////////////////////

abstract class NearestPickupsState {}

class NearestPickupsInitial extends NearestPickupsState {}

class NearestPickupsLoading extends NearestPickupsState {
  final String message;
  NearestPickupsLoading(this.message);
}

class NearestPickupsLoaded extends NearestPickupsState {
  final List<PickupPoint> pickups;
  NearestPickupsLoaded(this.pickups);
}

class NearestPickupsError extends NearestPickupsState {
  final String message;
  NearestPickupsError(this.message);
}

class NearestPickupsLocationPermissionDenied extends NearestPickupsState {}

class NearestPickupsLocationServicesDisabled extends NearestPickupsState {}

////////////////////////////////////////////////////////////////////////////////
// Cubit
////////////////////////////////////////////////////////////////////////////////

class NearestPickupsCubit extends Cubit<NearestPickupsState> {
  NearestPickupsCubit() : super(NearestPickupsInitial());

  Future<void> loadData() async {
    emit(NearestPickupsLoading("جاري التحقق من الموقع..."));

    // ── 1. التحقق من تفعيل خدمة الموقع ──
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(NearestPickupsLocationServicesDisabled());
      return;
    }

    // ── 2. التحقق من الإذن ──
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        emit(NearestPickupsLocationPermissionDenied());
        return;
      }
    }

    emit(NearestPickupsLoading("جاري جلب موقعك الحالي..."));

    Position? position;
    try {
      // نحاول نأخذ آخر موقع معروف أولاً (أسرع)
      position = await Geolocator.getLastKnownPosition();
      position ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 20),
      );
    } catch (e) {
      emit(NearestPickupsError("تعذر الحصول على موقعك الحالي"));
      return;
    }

    emit(NearestPickupsLoading("جاري تحميل أقرب نقاط الالتقاط..."));

    try {
      final response = await Supabase.instance.client.rpc(
        'get_nearest_pickup_points',
        params: {
          'p_user_lat': position.latitude,
          'p_user_lon': position.longitude,
          'p_limit': 10,
        },
      );

      if (response == null || (response as List).isEmpty) {
        emit(NearestPickupsLoaded([]));
        return;
      }

      final List<PickupPoint> items = [];
      final defaultTimes = ['07:20 AM', '07:35 AM', '07:50 AM', '08:05 AM'];

      for (int i = 0; i < response.length; i++) {
        final row = response[i] as Map<String, dynamic>;

        final name = row['pickup_name'] as String? ?? 'غير معروف';
        final lat = (row['latitude'] as num?)?.toDouble() ?? 0.0;
        final lng = (row['longitude'] as num?)?.toDouble() ?? 0.0;
        final distance = (row['distance_km'] as num?)?.toDouble() ?? 999.9;
        final bus = row['bus_number'] as String? ?? 'غير محدد';
        final driver = row['driver_name'] as String? ?? 'غير معروف';

        items.add(PickupPoint(
          name: name,
          position: LatLng(lat, lng),
          distanceKm: distance,
          time: i < defaultTimes.length ? defaultTimes[i] : '08:30 AM',
          busNumber: bus,
          driverName: driver,
          isNearest: i == 0,
        ));
      }

      emit(NearestPickupsLoaded(items));
    } catch (e) {
      emit(NearestPickupsError("حدث خطأ أثناء جلب البيانات\n$e"));
    }
  }
}

////////////////////////////////////////////////////////////////////////////////
// Screen
////////////////////////////////////////////////////////////////////////////////

class NearestPickupsScreen extends StatefulWidget {
  const NearestPickupsScreen({super.key});

  @override
  State<NearestPickupsScreen> createState() => _NearestPickupsScreenState();
}

class _NearestPickupsScreenState extends State<NearestPickupsScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return BlocProvider(
      create: (context) => NearestPickupsCubit()..loadData(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const PickupHeader(),
            Expanded(
              child: BlocBuilder<NearestPickupsCubit, NearestPickupsState>(
                builder: (context, state) {
                  if (state is NearestPickupsLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 24),
                          Text(
                            state.message,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is NearestPickupsLocationServicesDisabled) {
                    return _buildMessage(
                      icon: Icons.location_off_rounded,
                      title: "خدمة الموقع معطلة",
                      message: "يرجى تفعيل خدمة الموقع (GPS) لعرض أقرب النقاط",
                      buttonText: "تفعيل الموقع",
                      onPressed: () async {
                        await Geolocator.openLocationSettings();
                        context.read<NearestPickupsCubit>().loadData();
                      },
                    );
                  }

                  if (state is NearestPickupsLocationPermissionDenied) {
                    return _buildMessage(
                      icon: Icons.location_disabled_rounded,
                      title: "إذن الموقع مرفوض",
                      message: "يرجى السماح بالوصول للموقع من إعدادات التطبيق",
                      buttonText: "فتح الإعدادات",
                      onPressed: () async {
                        await Geolocator.openAppSettings();
                        context.read<NearestPickupsCubit>().loadData();
                      },
                    );
                  }

                  if (state is NearestPickupsError) {
                    return _buildMessage(
                      icon: Icons.error_outline_rounded,
                      title: "حدث خطأ",
                      message: state.message,
                      buttonText: "إعادة المحاولة",
                      onPressed: () => context.read<NearestPickupsCubit>().loadData(),
                    );
                  }

                  if (state is NearestPickupsLoaded) {
                    if (state.pickups.isEmpty) {
                      return const Center(
                        child: Text(
                          "لا توجد نقاط التقاط متاحة حالياً",
                          style: TextStyle(fontSize: 17, color: Colors.grey),
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
                          onTrackPressed: () => _showLiveTrackSheet(point),
                          onSelectPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SeatSelectionScreen(
                                  driverId: "1af57450-b0df-4d88-b5d2-b0fb4b71c864",
                                ),
                              ),
                            );
                          },
                        ).animate().fadeIn(delay: Duration(milliseconds: 60 * index)).slideY(begin: 0.06);
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
        floatingActionButton: MapFAB(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("🗺️ Opening interactive map...")),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessage({
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
            Icon(icon, size: 64, color: Colors.grey[700]),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  void _showLiveTrackSheet(PickupPoint point) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LiveTrackBottomSheet(point: point),
    );
  }
}

// ──────────────────────────────────────────────
//  باقي الـ widgets (لم يتم تغييرها نهائياً)
// ──────────────────────────────────────────────

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
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: SizeConfig.height * 0.032,
                ),
                color: AppColors.textPrimary,
              ),
              SizedBox(width: SizeConfig.width * 0.02),
              Text(
                "Pickup Points",
                style: AppTextStyles.title24BlackBold ??
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.height * 0.015),
          Text(
            "Choose the nearest or most convenient stop",
            style: AppTextStyles.title15TextSecondary ??
                const TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class PickupCard extends StatelessWidget {
  final PickupPoint point;
  final VoidCallback onTrackPressed;
  final VoidCallback onSelectPressed;

  const PickupCard({
    super.key,
    required this.point,
    required this.onTrackPressed,
    required this.onSelectPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isNearest = point.isNearest;

    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.height * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.03),
        border: isNearest
            ? Border.all(color: AppColors.kPrimaryColor.withOpacity(0.5), width: 1.8)
            : null,
        boxShadow: [
          BoxShadow(
            color: isNearest ? AppColors.kPrimaryColor.withOpacity(0.15) : Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: Offset(0, SizeConfig.height * 0.01),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.03),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.height * 0.027),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNearest) NearestBadge(),
                PickupNameAndDistance(point: point),
                SizedBox(height: SizeConfig.height * 0.02),
                PickupInfoRow(point: point),
                SizedBox(height: SizeConfig.height * 0.015),
                Text(
                  "Driver: ${point.driverName}",
                  style: AppTextStyles.title15TextSecondary,
                ),
                SizedBox(height: SizeConfig.height * 0.03),
                ActionButtonsRow(
                  onSelect: onSelectPressed,
                  onTrack: onTrackPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// باقي الـ classes (NearestBadge, PickupNameAndDistance, PickupInfoRow, ActionButtonsRow, LiveTrackBottomSheet, MapFAB)
// هي نفسها 100% زي الكود الأصلي اللي بعثته

class NearestBadge extends StatelessWidget {
  const NearestBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.height * 0.017),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.035,
        vertical: SizeConfig.height * 0.007,
      ),
      decoration: BoxDecoration(
        color: AppColors.kPrimaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.04),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: SizeConfig.height * 0.022,
            color: AppColors.kPrimaryColor,
          ),
          SizedBox(width: SizeConfig.width * 0.015),
          Text(
            "NEAREST TO YOU",
            style: TextStyle(
              fontSize: getResponsiveFontSize(fontSize: 13),
              fontWeight: FontWeight.w600,
              color: AppColors.kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class PickupNameAndDistance extends StatelessWidget {
  final PickupPoint point;

  const PickupNameAndDistance({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            point.name,
            style: AppTextStyles.title21BlackW700 ?? const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ),
        SizedBox(width: SizeConfig.width * 0.03),
        Text(
          point.distanceText,
          style: TextStyle(
            fontSize: getResponsiveFontSize(fontSize: 20),
            fontWeight: FontWeight.w700,
            color: AppColors.kPrimaryColor,
          ),
        ),
      ],
    );
  }
}

class PickupInfoRow extends StatelessWidget {
  final PickupPoint point;

  const PickupInfoRow({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.directions_bus_rounded,
          color: AppColors.kPrimaryColor,
          size: SizeConfig.height * 0.032,
        ),
        SizedBox(width: SizeConfig.width * 0.025),
        Text(
          "#"+point.busNumber,
          style: AppTextStyles.title17BlackW600,
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width * 0.03,
            vertical: SizeConfig.height * 0.007,
          ),
          decoration: BoxDecoration(
            color: AppColors.kPrimaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(SizeConfig.height * 0.04),
          ),
          child: Text(
            point.time,
            style: TextStyle(
              fontSize: getResponsiveFontSize(fontSize: 16),
              fontWeight: FontWeight.w600,
              color: AppColors.kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onSelect;
  final VoidCallback onTrack;

  const ActionButtonsRow({
    super.key,
    required this.onSelect,
    required this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: SizeConfig.height * 0.067,
            child: ElevatedButton(
              onPressed: onSelect,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.height * 0.02),
                ),
              ),
              child: Text(
                "Select Pickup",
                style: AppTextStyles.title16WhiteW600 ?? const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: SizeConfig.width * 0.04),
        Container(
          decoration: BoxDecoration(
            color: AppColors.kPrimaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(SizeConfig.height * 0.02),
          ),
          child: IconButton(
            onPressed: onTrack,
            icon: Icon(
              Icons.track_changes_rounded,
              color: AppColors.kPrimaryColor,
              size: SizeConfig.height * 0.034,
            ),
            padding: EdgeInsets.all(SizeConfig.height * 0.017),
          ),
        ),
      ],
    );
  }
}

class LiveTrackBottomSheet extends StatelessWidget {
  final PickupPoint point;

  const LiveTrackBottomSheet({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.width * 0.06,
        SizeConfig.height * 0.04,
        SizeConfig.width * 0.06,
        SizeConfig.height * 0.05,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(SizeConfig.height * 0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(SizeConfig.height * 0.025),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on_rounded,
              size: SizeConfig.height * 0.08,
              color: AppColors.kPrimaryColor,
            ),
          ),
          SizedBox(height: SizeConfig.height * 0.03),
          Text(
            "Live Tracking",
            style: AppTextStyles.title26BlackBold ?? const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          Text(
            point.busNumber,
            style: TextStyle(
              fontSize: getResponsiveFontSize(fontSize: 22),
              fontWeight: FontWeight.w600,
              color: AppColors.kPrimaryColor,
            ),
          ),
          SizedBox(height: SizeConfig.height * 0.015),
          Text(
            point.name,
            textAlign: TextAlign.center,
            style: AppTextStyles.title17TextSecondary ?? const TextStyle(fontSize: 17, color: AppColors.textSecondary),
          ),
          SizedBox(height: SizeConfig.height * 0.025),
          Text(
            "🚍 Arriving in ${point.time}",
            style: TextStyle(
              fontSize: getResponsiveFontSize(fontSize: 18),
              fontWeight: FontWeight.w600,
              color: AppColors.kPrimaryColor,
            ),
          ),
          SizedBox(height: SizeConfig.height * 0.045),
          SizedBox(
            width: double.infinity,
            height: SizeConfig.height * 0.07,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.height * 0.02),
                ),
              ),
              child: Text(
                "Close Tracking",
                style: AppTextStyles.title17WhiteW600,
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.4, curve: Curves.easeOutCubic).fadeIn();
  }
}

class MapFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const MapFAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.height * 0.02),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(Icons.map_rounded, size: SizeConfig.height * 0.028),
        label: Text(
          "View on Map",
          style: AppTextStyles.title16WhiteW600,
        ),
        backgroundColor: AppColors.kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.height * 0.04),
        ),
      ),
    );
  }
}