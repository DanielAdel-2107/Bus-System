import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/features/student/subscriptions/models/subscriptions_plan_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(const SubscriptionInitial(selectedPlanName: "Yearly"));

  void selectPlan(String planName) {
    emit(SubscriptionInitial(selectedPlanName: planName));
  }

  Future<void> subscribe({
    required SubscriptionPlan plan,
  }) async {
    emit(const SubscriptionLoading());

    try {
      final supabase = Supabase.instance.client;

      final startDate = DateTime.now();
      final endDate = startDate.add(Duration(days: plan.durationMonths * 30));
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      await supabase.from('subscriptions').insert({
        'student_id': getIt<SupabaseClient>().auth.currentUser!.id,
        'start_date': startDate.toIso8601String().split('T')[0],
        'end_date': endDate.toIso8601String().split('T')[0],
        'is_active': true,
        'payment_status': 'paid',
        'amount': double.tryParse(plan.price) ?? 0,
        'created_at': DateTime.now().toIso8601String(),
      });

      emit(SubscriptionSuccess(planName: plan.name));
    } catch (e) {
      log('Subscription error: $e');
      emit(SubscriptionFailure(error: e.toString()));
    }
  }
}