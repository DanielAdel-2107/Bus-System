part of 'subscription_cubit.dart';

sealed class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {
  final String selectedPlanName;
  final Map<String, dynamic>? activeSubscription;

  const SubscriptionInitial({
    required this.selectedPlanName,
    this.activeSubscription,
  });

  @override
  List<Object?> get props => [selectedPlanName, activeSubscription];
}

class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

class SubscriptionSuccess extends SubscriptionState {
  final String planName;

  const SubscriptionSuccess({required this.planName});

  @override
  List<Object?> get props => [planName];
}

class SubscriptionFailure extends SubscriptionState {
  final String error;

  const SubscriptionFailure({required this.error});

  @override
  List<Object?> get props => [error];
}