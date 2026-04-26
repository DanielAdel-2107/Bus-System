import 'package:equatable/equatable.dart';

abstract class DriverMainState extends Equatable {
  final int currentIndex;
  const DriverMainState(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}

class DriverMainInitial extends DriverMainState {
  const DriverMainInitial() : super(0);
}

class DriverMainTabChanged extends DriverMainState {
  const DriverMainTabChanged(super.currentIndex);
}
