import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/assets/lotties/app_lotties.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

////////////////////////////////////////////////////////////////////////////////
// Seat Model
////////////////////////////////////////////////////////////////////////////////

class Seat {
  final int number;
  final String? studentGender;
  final bool isTaken;
  bool isSelected;

  Seat({
    required this.number,
    this.studentGender,
    required this.isTaken,
    this.isSelected = false,
  });

  String get status {
    if (number == 1) return 'driver';
    if (isTaken) return studentGender ?? 'occupied';
    return 'available';
  }

  Color get color {
    if (status == 'driver') return AppColors.primaryBlue;
    if (isTaken) {
      return studentGender == 'male' ? AppColors.maleSeat : AppColors.femaleSeat;
    }
    return isSelected ? AppColors.selectedSeat : AppColors.availableSeat;
  }
}

////////////////////////////////////////////////////////////////////////////////
// States & Cubit (مع دعم التاريخ)
////////////////////////////////////////////////////////////////////////////////

abstract class SeatState {}

class SeatInitial extends SeatState {}

class SeatLoading extends SeatState {}

class SeatLoaded extends SeatState {
  final List<Seat> seats;
  final int? selectedSeatNumber;

  SeatLoaded(this.seats, {this.selectedSeatNumber});
}

class SeatError extends SeatState {
  final String message;
  SeatError(this.message);
}

class SeatBookingSuccess extends SeatState {
  final int seatNumber;
  SeatBookingSuccess(this.seatNumber);
}

class SeatSelectionCubit extends Cubit<SeatState> {
  SeatSelectionCubit() : super(SeatInitial());

  String? _driverId;
  int? _selectedSeat;
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  Future<void> loadSeats(String driverId) async {
    _driverId = driverId;
    emit(SeatLoading());

    try {
      final response = await Supabase.instance.client
          .from('driver_seat_status')
          .select('seat_number, student_gender, is_taken')
          .eq('driver_id', driverId)
          .order('seat_number');

      List<Seat> loadedSeats = response.map((row) {
        return Seat(
          number: row['seat_number'] as int,
          studentGender: row['student_gender'] as String?,
          isTaken: row['is_taken'] as bool,
        );
      }).toList();

      if (!loadedSeats.any((s) => s.number == 1)) {
        loadedSeats.insert(0, Seat(number: 1, isTaken: true));
      }

      emit(SeatLoaded(loadedSeats, selectedSeatNumber: _selectedSeat));
    } catch (e) {
      emit(SeatError('Failed to load seats: $e'));
    }
  }

  void selectSeat(int number) {
    if (state is! SeatLoaded) return;
    final current = state as SeatLoaded;

    final seat = current.seats.firstWhere((s) => s.number == number);

    if (seat.status != 'available') return;

    if (_selectedSeat != null && _selectedSeat != number) {
      final prev = current.seats.firstWhere((s) => s.number == _selectedSeat);
      prev.isSelected = false;
    }

    seat.isSelected = !seat.isSelected;
    _selectedSeat = seat.isSelected ? number : null;

    emit(SeatLoaded(List.from(current.seats), selectedSeatNumber: _selectedSeat));
  }

  void changeDate(DateTime newDate) {
    _selectedDate = newDate;
    if (state is SeatLoaded) {
      emit(SeatLoaded(List.from((state as SeatLoaded).seats),
          selectedSeatNumber: _selectedSeat));
    }
  }

  Future<void> confirmBooking() async {
    if (_selectedSeat == null || _driverId == null || state is! SeatLoaded) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      emit(SeatError('Please login first'));
      return;
    }

    try {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select('gender')
          .eq('id', user.id)
          .maybeSingle();

      final gender = profile?['gender'] as String? ?? 'male';

      await Supabase.instance.client.from('bookings').insert({
        'student_id': user.id,
        'driver_id': _driverId,
        'seat_number': _selectedSeat,
        'gender': gender,
        'booking_date': _selectedDate.toIso8601String(),
        'status': 'booked',
      });

      emit(SeatBookingSuccess(_selectedSeat!));
      await loadSeats(_driverId!);
    } catch (e) {
      emit(SeatError('Booking failed: $e'));
    }
  }
}

////////////////////////////////////////////////////////////////////////////////
// Main Screen
////////////////////////////////////////////////////////////////////////////////

class SeatSelectionScreen extends StatefulWidget {
  final String driverId;

  const SeatSelectionScreen({super.key, required this.driverId});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final h = SizeConfig.height;
    final w = SizeConfig.width;

    return BlocProvider(
      create: (_) => SeatSelectionCubit()..loadSeats(widget.driverId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              BusHeader(),
              DatePickerSection(),
              SeatLegend(),
              Expanded(
                child: BlocBuilder<SeatSelectionCubit, SeatState>(
                  builder: (context, state) {
                    if (state is SeatLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is SeatError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is SeatLoaded) {
                      return SeatMapContainer(
                        seats: state.seats,
                        selectedSeatNumber: state.selectedSeatNumber,
                        onSeatTapped: context.read<SeatSelectionCubit>().selectSeat,
                      );
                    }
                    if (state is SeatBookingSuccess) {
                      Navigator.pop(context); // Close the seat selection screen
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => BookingSuccessDialog(
                            seatId: state.seatNumber.toString(),
                          ),
                        );
                      });
                      return const SizedBox();
                    }
                    return const SizedBox();
                  },
                ),
              ),
              BlocBuilder<SeatSelectionCubit, SeatState>(
                builder: (context, state) {
                  final selected = state is SeatLoaded ? state.selectedSeatNumber : null;
                  return BottomActionBar(
                    selectedSeatId: selected?.toString(),
                    onConfirm: selected != null
                        ? () => context.read<SeatSelectionCubit>().confirmBooking()
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// Date Picker Section
////////////////////////////////////////////////////////////////////////////////

class DatePickerSection extends StatelessWidget {
  const DatePickerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final h = SizeConfig.height;
    final w = SizeConfig.width;
    final cubit = context.read<SeatSelectionCubit>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.015),
      child: InkWell(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: cubit.selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 60)),
          );

          if (picked != null && picked != cubit.selectedDate) {
            cubit.changeDate(picked);
          }
        },
        borderRadius: BorderRadius.circular(h * 0.02),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.015),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(h * 0.02),
            border: Border.all(color: AppColors.kPrimaryColor.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      color: AppColors.kPrimaryColor, size: h * 0.028),
                  SizedBox(width: w * 0.03),
                  Text(
                    "Trip Date: ${DateFormat('MMM d, yyyy').format(cubit.selectedDate)}",
                    style: AppTextStyles.title16PrimaryW600,
                  ),
                ],
              ),
              Icon(Icons.arrow_drop_down_rounded,
                  color: AppColors.kPrimaryColor, size: h * 0.035),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// Bus Header (نفس الأصلي)
////////////////////////////////////////////////////////////////////////////////

class BusHeader extends StatelessWidget {
  const BusHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final h = SizeConfig.height;
    final w = SizeConfig.width;

    return Container(
      padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.02, w * 0.04, h * 0.03),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, AppColors.background.withOpacity(0.98)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(h * 0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, h * 0.01),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: Offset(0, h * 0.005),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_rounded, size: h * 0.035, color: AppColors.primaryBlue),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.012),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(h * 0.04),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_rounded, size: h * 0.022, color: AppColors.kPrimaryColor),
                    SizedBox(width: w * 0.02),
                    Text("Today • 07:20 AM", style: AppTextStyles.title15PrimaryW600),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.025),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(h * 0.012),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(h * 0.02),
                ),
                child: Icon(Icons.directions_bus_filled_rounded, color: AppColors.kPrimaryColor, size: h * 0.04),
              ),
              SizedBox(width: w * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bus 12", style: AppTextStyles.title28PrimaryBold),
                    SizedBox(height: h * 0.005),
                    Text("Nasr City → Al-Noor School", style: AppTextStyles.title15SecondaryW500),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// Seat Legend (نفس الأصلي)
////////////////////////////////////////////////////////////////////////////////

class SeatLegend extends StatelessWidget {
  const SeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final h = SizeConfig.height;
    final w = SizeConfig.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
      child: Wrap(
        spacing: w * 0.06,
        runSpacing: h * 0.015,
        alignment: WrapAlignment.center,
        children: [
          _LegendItem("Male", AppColors.maleSeat),
          _LegendItem("Female", AppColors.femaleSeat),
          _LegendItem("Driver", AppColors.primaryBlue),
          _LegendItem("Available", AppColors.availableSeat),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    final h = SizeConfig.height;
    final w = SizeConfig.width;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: h * 0.032,
          height: h * 0.032,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(h * 0.012),
          ),
        ),
        SizedBox(width: w * 0.025),
        Text(label, style: AppTextStyles.title15GreyW600),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// Seat Map Container & Layout
////////////////////////////////////////////////////////////////////////////////

class SeatMapContainer extends StatelessWidget {
  final List<Seat> seats;
  final int? selectedSeatNumber;
  final Function(int) onSeatTapped;

  const SeatMapContainer({
    super.key,
    required this.seats,
    this.selectedSeatNumber,
    required this.onSeatTapped,
  });

  @override
  Widget build(BuildContext context) {
    final h = SizeConfig.height;
    final w = SizeConfig.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.01),
      padding: EdgeInsets.fromLTRB(w * 0.015, h * 0.025, w * 0.015, h * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(h * 0.04),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 22, offset: Offset(0, h * 0.01)),
        ],
      ),
      child: Column(
        children: [
          Text("Front of the Bus", style: AppTextStyles.title15GreyW600),
          SizedBox(height: h * 0.02),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: h * 0.01),
              child: _SeatsLayout(
                seats: seats,
                selectedSeatNumber: selectedSeatNumber,
                onSeatTapped: onSeatTapped,
              ),
            ),
          ),
          SizedBox(height: h * 0.02),
          Text("Rear of the Bus", style: AppTextStyles.title15GreyW600),
        ],
      ),
    );
  }
}

class _SeatsLayout extends StatelessWidget {
  final List<Seat> seats;
  final int? selectedSeatNumber;
  final Function(int) onSeatTapped;

  const _SeatsLayout({
    required this.seats,
    this.selectedSeatNumber,
    required this.onSeatTapped,
  });

  @override
  Widget build(BuildContext context) {
    final h = SizeConfig.height;
    final w = SizeConfig.width;

    final sortedSeats = List<Seat>.from(seats)..sort((a, b) => a.number.compareTo(b.number));

    return Column(
      children: [
        // الصف الأول: السواق + كرسي واحد بس بعده بمسافة كبيرة
        Padding(
          padding: EdgeInsets.only(bottom: h * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // السواق
              Container(
                width: h * 0.095,
                height: h * 0.095,
                margin: EdgeInsets.only(left: w * 0.08), // مسافة من الحافة الشمال
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(h * 0.025),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, h * 0.007)),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_bus_rounded, color: Colors.white, size: h * 0.045),
                      SizedBox(height: h * 0.007),
                      Text("Driver", style: AppTextStyles.title13WhiteW600),
                    ],
                  ),
                ),
              ),

              // مسافة كبيرة بين السواق والكرسي الوحيد
              SizedBox(width: w * 0.35), // ← هنا المسافة الكبيرة اللي طلبتها

              // الكرسي الوحيد على اليمين
              if (sortedSeats.length > 1)
                _SeatWidget(
                  seat: sortedSeats.firstWhere((s) => s.number > 1, orElse: () => Seat(number: 2, isTaken: false)),
                  isSelected: selectedSeatNumber == sortedSeats.firstWhere((s) => s.number > 1, orElse: () => Seat(number: 2, isTaken: false)).number,
                  onTap: () => onSeatTapped(sortedSeats.firstWhere((s) => s.number > 1, orElse: () => Seat(number: 2, isTaken: false)).number),
                  isWindow: true,
                ),
            ],
          ),
        ),

        // باقي الصفوف (4 كراسي + ممر في النص)
        ...List.generate(((sortedSeats.length - 2) / 4).ceil(), (rowIndex) {
          final start = 2 + rowIndex * 4;
          final end = (start + 4).clamp(2, sortedSeats.length);

          final rowSeats = sortedSeats.sublist(start, end);

          return Padding(
            padding: EdgeInsets.only(bottom: h * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < rowSeats.length; i++) ...[
                  if (i == 2)
                    Expanded(
                      child: Container(
                        height: h * 0.10,
                        margin: EdgeInsets.symmetric(horizontal: w * 0.08),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(h * 0.025),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                  _SeatWidget(
                    seat: rowSeats[i],
                    isSelected: rowSeats[i].number == selectedSeatNumber,
                    onTap: () => onSeatTapped(rowSeats[i].number),
                    isWindow: i == 0 || i == rowSeats.length - 1,
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _SeatWidget extends StatelessWidget {
  final Seat seat;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isWindow;

  const _SeatWidget({
    required this.seat,
    required this.isSelected,
    required this.onTap,
    required this.isWindow,
  });

  @override
  Widget build(BuildContext context) {
    final h = SizeConfig.height;
    final w = SizeConfig.width;

    return GestureDetector(
      onTap: seat.status == 'available' ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        width: w * 0.18,
        height: h * 0.095,
        margin: EdgeInsets.symmetric(horizontal: w * 0.008),
        decoration: BoxDecoration(
          color: seat.color,
          borderRadius: BorderRadius.circular(h * 0.025),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: isSelected ? 4 : 0,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.kPrimaryColor.withOpacity(0.4), blurRadius: 16, spreadRadius: 2)]
              : [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: Offset(0, h * 0.005))],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                seat.number.toString(),
                style: AppTextStyles.title17BlackW700?.copyWith(
                  color: (seat.status == 'available' || isSelected) ? Colors.black87 : Colors.white,
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle_rounded, color: Colors.white, size: h * 0.03),
              if (isWindow && seat.status == 'available' && !isSelected)
                Padding(
                  padding: EdgeInsets.only(top: h * 0.005),
                  child: Icon(Icons.sensor_window_outlined, size: h * 0.022, color: Colors.grey[600]),
                ),
            ],
          ),
        ),
      ).animate(target: isSelected ? 1 : 0).scale(begin: const Offset(0.90, 0.90), duration: 300.ms),
    );
  }
}

// ──────────────────────────────────────────────
// Bottom Action Bar & Success Dialog
// ──────────────────────────────────────────────

class BottomActionBar extends StatelessWidget {
  final String? selectedSeatId;
  final VoidCallback? onConfirm;

  const BottomActionBar({
    super.key,
    required this.selectedSeatId,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final h = SizeConfig.height;
    final w = SizeConfig.width;

    return Container(
      padding: EdgeInsets.fromLTRB(w * 0.05, h * 0.02, w * 0.05, h * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 24,
            offset: Offset(0, -h * 0.015),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedSeatId != null)
              Text(
                "Selected: $selectedSeatId",
                style: AppTextStyles.title18PrimaryW700,
              )
            else
              Text(
                "Tap an available seat",
                style: AppTextStyles.title16Secondary,
              ),
            SizedBox(height: h * 0.02),
            SizedBox(
              width: double.infinity,
              height: h * 0.075,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedSeatId == null
                      ? Colors.grey.shade400
                      : AppColors.kPrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(h * 0.05),
                  ),
                  elevation: selectedSeatId == null ? 0 : 8,
                ),
                child: Text(
                  selectedSeatId == null ? "Select a Seat" : "Confirm Booking",
                  style: AppTextStyles.title18WhiteW600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingSuccessDialog extends StatelessWidget {
  final String seatId;

  const BookingSuccessDialog({super.key, required this.seatId});

  @override
  Widget build(BuildContext context) {
    final h = SizeConfig.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(h * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(h * 0.045),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 40,
              offset: Offset(0, h * 0.025),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              AppLotties.paymentLottie,
              width: h * 0.175,
              height: h * 0.175,
              repeat: false,
            ),
            SizedBox(height: h * 0.02),
            Text("Booking Confirmed!", style: AppTextStyles.title26BlackBold),
            SizedBox(height: h * 0.01),
            Text(
              "Seat $seatId • Bus 12",
              style: TextStyle(
                fontSize: getResponsiveFontSize(fontSize: 16),
                color: AppColors.kPrimaryColor,
              ),
            ),
            SizedBox(height: h * 0.04),
            SizedBox(
              width: double.infinity,
              height: h * 0.07,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("🎉 Booking successful!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: h * 0.08, vertical: h * 0.022),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(h * 0.05)),
                  elevation: 4,
                ),
                child: Text("Done", style: AppTextStyles.title18WhiteW600),
              ),
            ),
          ],
        ),
      ).animate().scale(duration: 420.ms, curve: Curves.elasticOut),
    );
  }
}
// ──────────────────────────────────────────────
// Date Picker Section
// ──────────────────────────────────────────────

class _DatePickerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final h = SizeConfig.height;
    final w = SizeConfig.width;
    final cubit = context.read<SeatSelectionCubit>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.015),
      child: InkWell(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: cubit.selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 30)),
          );

          if (picked != null && picked != cubit.selectedDate) {
            cubit.changeDate(picked);
          }
        },
        borderRadius: BorderRadius.circular(h * 0.02),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.015),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(h * 0.02),
            border: Border.all(color: AppColors.kPrimaryColor.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      color: AppColors.kPrimaryColor, size: h * 0.028),
                  SizedBox(width: w * 0.03),
                  Text(
                    "Trip Date: ${DateFormat('EEEE, MMM d, yyyy').format(cubit.selectedDate)}",
                    style: AppTextStyles.title16PrimaryW600,
                  ),
                ],
              ),
              Icon(Icons.arrow_drop_down_rounded,
                  color: AppColors.kPrimaryColor, size: h * 0.035),
            ],
          ),
        ),
      ),
    );
  }
}

