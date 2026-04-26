import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bus_system/features/driver/passenger_list/models/passenger_model.dart';
import 'package:bus_system/features/driver/passenger_list/view_models/cubit/passenger_list_state.dart';

class PassengerListCubit extends Cubit<PassengerListState> {
  PassengerListCubit() : super(PassengerListInitial());

  Future<void> fetchPassengers() async {
    emit(PassengerListLoading());

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(const PassengerListError('User is not authenticated.'));
        return;
      }
      
      final driverId = user.id;

      // Fetch booked seats for this driver using the new view
      final response = await Supabase.instance.client
          .from('driver_seat_status')
          .select()
          .eq('driver_id', driverId)
          .eq('is_taken', true)
          .order('seat_number', ascending: true);

      final List<dynamic> seatsData = response;

      if (seatsData.isEmpty) {
        emit(const PassengerListSuccess([]));
        return;
      }

      // Extract student IDs to fetch their names and phones
      final List<String> studentIds = seatsData
          .map((e) => e['student_id']?.toString())
          .where((id) => id != null)
          .cast<String>()
          .toList();

      final Map<String, dynamic> profilesMap = {};
      
      if (studentIds.isNotEmpty) {
        final profilesResponse = await Supabase.instance.client
            .from('profiles')
            .select('id, full_name, phone')
            .inFilter('id', studentIds);
            
        for (var profile in profilesResponse as List<dynamic>) {
          profilesMap[profile['id']] = profile;
        }
      }

      final List<PassengerModel> passengers = [];
      
      for (var seat in seatsData) {
        final studentId = seat['student_id']?.toString();
        final profile = studentId != null ? profilesMap[studentId] : null;
        
        passengers.add(PassengerModel(
          id: studentId ?? seat['seat_number'].toString(), // fallback ID
          name: profile?['full_name'] ?? 'Unknown Passenger',
          seatNumber: seat['seat_number'] as int,
          gender: seat['student_gender']?.toString() ?? 'unknown',
          phoneNumber: profile?['phone'] ?? 'No phone provided',
        ));
      }

      emit(PassengerListSuccess(passengers));
    } catch (e) {
      emit(PassengerListError('Failed to load passengers: ${e.toString()}'));
    }
  }
}
