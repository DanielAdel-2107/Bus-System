import 'package:bloc/bloc.dart';
import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'student_register_state.dart';

class StudentRegisterCubit extends Cubit<StudentRegisterState> {
  StudentRegisterCubit() : super(StudentRegisterInitial());

  final formKey = GlobalKey<FormState>();
  final facultyController = TextEditingController();
  final levelController = TextEditingController();
  final phoneController = TextEditingController();
  
  String? selectedGender;

  void selectGender(String? gender) {
    selectedGender = gender;
    if (gender != null) {
      emit(GenderSelectedState(gender: gender));
    }
  }

  Future<void> submitStudentInfo() async {
    if (formKey.currentState!.validate()) {
      if (selectedGender == null) {
        emit(StudentRegisterFailure(errorMessage: 'Please select your gender'));
        return;
      }

      emit(StudentRegisterLoading());
      try {
        final user = getIt<SupabaseClient>().auth.currentUser;
        if (user == null) {
          emit(StudentRegisterFailure(errorMessage: 'User not authenticated'));
          return;
        }

        // 1. Update Profile (Gender, Phone)
        final supabase = getIt<SupabaseClient>();
        await supabase.from('profiles').update({
          'gender': selectedGender,
          'phone': phoneController.text.trim(),
        }).eq('id', user.id);

        // 2. Add Student Info (Faculty, Level)
        await supabase.from('students').update({
          'faculty': facultyController.text.trim(),
          'level': int.parse(levelController.text.trim()),
        }).eq('id', user.id);
        
        emit(StudentRegisterSuccess());
      } catch (e) {
        emit(StudentRegisterFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    facultyController.dispose();
    levelController.dispose();
    phoneController.dispose();
    return super.close();
  }
}
