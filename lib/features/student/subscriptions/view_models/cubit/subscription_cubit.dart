import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/features/student/subscriptions/models/subscriptions_plan_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(const SubscriptionInitial(selectedPlanName: "Yearly")) {
    fetchActiveSubscription();
  }

  Future<void> fetchActiveSubscription() async {
    try {
      final supabase = getIt<SupabaseClient>();
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final res = await supabase
          .from('subscriptions')
          .select()
          .eq('student_id', userId)
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (res != null) {
        if (state is SubscriptionInitial) {
          emit(SubscriptionInitial(
            selectedPlanName: (state as SubscriptionInitial).selectedPlanName,
            activeSubscription: res,
          ));
        } else {
          emit(SubscriptionInitial(
            selectedPlanName: "Yearly",
            activeSubscription: res,
          ));
        }
      }
    } catch (e) {
      log('Error fetching active sub: $e');
    }
  }

  void selectPlan(String planName) {
    if (state is SubscriptionInitial) {
      emit(SubscriptionInitial(
        selectedPlanName: planName,
        activeSubscription: (state as SubscriptionInitial).activeSubscription,
      ));
    } else {
      emit(SubscriptionInitial(selectedPlanName: planName));
    }
  }

  Future<void> subscribe({
    required SubscriptionPlan plan,
    required String paymentMethod,
  }) async {
    emit(const SubscriptionLoading());

    try {
      final supabase = Supabase.instance.client;

      final startDate = DateTime.now();
      final endDate = startDate.add(Duration(days: plan.durationMonths * 30));
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      
      // We will handle payment logic based on paymentMethod here if needed.
      // For now, we just log it and proceed with the subscription.
      log('Processing payment via: $paymentMethod');

      await supabase.from('subscriptions').insert({
        'student_id': getIt<SupabaseClient>().auth.currentUser!.id,
        'start_date': startDate.toIso8601String().split('T')[0],
        'end_date': endDate.toIso8601String().split('T')[0],
        'is_active': true,
        'payment_status': 'paid',
        'payment_method': paymentMethod, 
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