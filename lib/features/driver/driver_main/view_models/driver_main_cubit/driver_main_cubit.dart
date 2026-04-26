import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bus_system/features/driver/driver_main/view_models/driver_main_cubit/driver_main_state.dart';

class DriverMainCubit extends Cubit<DriverMainState> {
  DriverMainCubit() : super(const DriverMainInitial());

  void changeTab(int index) {
    if (state.currentIndex == index) return;
    emit(DriverMainTabChanged(index));
  }
}
