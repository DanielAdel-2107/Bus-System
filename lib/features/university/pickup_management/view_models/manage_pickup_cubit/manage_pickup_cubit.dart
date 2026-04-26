import 'dart:async';
import 'package:bus_system/core/network/supabase/database/add_data.dart';
import 'package:bus_system/core/network/supabase/database/remove_data.dart';
import 'package:bus_system/features/university/pickup_management/models/pickup_model.dart';
import 'package:bus_system/features/university/pickup_management/view_models/manage_pickup_cubit/manage_pickup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bus_system/core/di/dependancy_injection.dart';

class ManagePickupCubit extends Cubit<ManagePickupState> {
  final supabase = getIt<SupabaseClient>();
  static const String _tableName = 'pickup_points';
  static const String _viewName = 'pickup_points_with_drivers';
  
  StreamSubscription? _pickupsSubscription;

  ManagePickupCubit() : super(ManagePickupInitial());

  void watchPickups() {
    emit(ManagePickupLoading());
    
    _pickupsSubscription?.cancel();
    _pickupsSubscription = supabase
        .from(_viewName)
        .stream(primaryKey: ['id'])
        .map((data) => data.map((json) => PickupPoint.fromMap(json)).toList())
        .listen(
          (pickups) {
            emit(ManagePickupSuccess(pickups));
          },
          onError: (error) {
            emit(ManagePickupError(error.toString()));
          },
        );
  }

  Future<void> addPickup(PickupPoint pickup) async {
    try {
      // Ensure created_by is set to current user if available
      final userId = supabase.auth.currentUser?.id;
      final pickupData = pickup.toMap();
      if (userId != null) {
        pickupData['created_by'] = userId;
      }
      
      await addData(tableName: _tableName, data: pickupData);
    } catch (e) {
      emit(ManagePickupError(e.toString()));
    }
  }

  Future<void> updatePickup(PickupPoint pickup) async {
    try {
      if (pickup.id == null) return;
      await addData(tableName: _tableName, data: pickup.toMap());
    } catch (e) {
      emit(ManagePickupError(e.toString()));
    }
  }

  Future<void> deletePickup(String id) async {
    try {
      await removeData(tableName: _tableName, data: {'id': id});
    } catch (e) {
      emit(ManagePickupError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _pickupsSubscription?.cancel();
    return super.close();
  }
}
