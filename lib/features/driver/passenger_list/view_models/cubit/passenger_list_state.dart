import 'package:equatable/equatable.dart';
import 'package:bus_system/features/driver/passenger_list/models/passenger_model.dart';

abstract class PassengerListState extends Equatable {
  const PassengerListState();

  @override
  List<Object> get props => [];
}

class PassengerListInitial extends PassengerListState {}

class PassengerListLoading extends PassengerListState {}

class PassengerListSuccess extends PassengerListState {
  final List<PassengerModel> passengers;
  const PassengerListSuccess(this.passengers);

  @override
  List<Object> get props => [passengers];
}

class PassengerListError extends PassengerListState {
  final String message;
  const PassengerListError(this.message);

  @override
  List<Object> get props => [message];
}
