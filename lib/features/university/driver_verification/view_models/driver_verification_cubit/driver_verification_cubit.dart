import 'dart:async';
import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/features/university/driver_verification/models/driver_model.dart';
import 'package:bus_system/features/university/driver_verification/view_models/driver_verification_cubit/driver_verification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DriverVerificationCubit extends Cubit<DriverVerificationState> {
  final supabase = getIt<SupabaseClient>();
  static const String _tableName = 'drivers';
  static const String _viewName = 'drivers_with_profiles';

  StreamSubscription? _driversSubscription;

  DriverVerificationCubit() : super(DriverVerificationInitial());

  void watchDrivers() {
    _fetchAndEmitDrivers();

    _driversSubscription?.cancel();
    // Listen to the drivers TABLE for any changes (insert/update/delete)
    // When a change occurs, we re-fetch the enriched data from the VIEW
    _driversSubscription = supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .listen((_) => _fetchAndEmitDrivers());
  }

  Future<void> _fetchAndEmitDrivers() async {
    try {
      final data = await supabase
          .from(_viewName)
          .select()
          .order('created_at', ascending: false);
      
      final drivers = data.map((json) => Driver.fromMap(json)).toList();
      
      final currentStatus = state is DriverVerificationSuccess 
          ? (state as DriverVerificationSuccess).selectedStatus 
          : 'all';
      
      emit(DriverVerificationSuccess(
        allDrivers: drivers, 
        selectedStatus: currentStatus,
        successMessage: null, // Always nullify here to prevent redundant alerts on background sync
      ));
    } catch (e) {
      if (state is! DriverVerificationSuccess) {
        emit(DriverVerificationError(e.toString()));
      }
    }
  }

  void filterDrivers(String status) {
    if (state is DriverVerificationSuccess) {
      final currentState = state as DriverVerificationSuccess;
      emit(currentState.copyWith(
        selectedStatus: status,
        successMessage: null, // Ensure message is cleared when switching filters
      ));
    }
  }

  Future<void> approveDriver(String id) async {
    try {
      await supabase
          .from(_tableName)
          .update({
            'is_verified': true,
            'status': 'accepted',
          })
          .eq('id', id);
      
      // Force an immediate refresh of the list
      await _fetchAndEmitDrivers();
      
      if (state is DriverVerificationSuccess) {
        emit((state as DriverVerificationSuccess).copyWith(successMessage: 'Driver Approved Successfully!'));
      }
    } catch (e) {
      emit(DriverVerificationError(e.toString()));
    }
  }

  Future<void> rejectDriver(String id) async {
    try {
      await supabase
          .from(_tableName)
          .update({
            'is_verified': false,
            'status': 'rejected',
          })
          .eq('id', id);
      
      // Force an immediate refresh of the list
      await _fetchAndEmitDrivers();
      
      if (state is DriverVerificationSuccess) {
        emit((state as DriverVerificationSuccess).copyWith(successMessage: 'Driver Application Rejected.'));
      }
    } catch (e) {
      emit(DriverVerificationError(e.toString()));
    }
  }

  void clearMessage() {
    if (state is DriverVerificationSuccess) {
      emit((state as DriverVerificationSuccess).copyWith(successMessage: null));
    }
  }

  @override
  Future<void> close() {
    _driversSubscription?.cancel();
    return super.close();
  }
}
