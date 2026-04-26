import 'package:flutter/material.dart';

@immutable
abstract class StudentRegisterState {}

class StudentRegisterInitial extends StudentRegisterState {}

class StudentRegisterLoading extends StudentRegisterState {}

class StudentRegisterSuccess extends StudentRegisterState {}

class StudentRegisterFailure extends StudentRegisterState {
  final String errorMessage;

  StudentRegisterFailure({required this.errorMessage});
}

class GenderSelectedState extends StudentRegisterState {
  final String gender;

  GenderSelectedState({required this.gender});
}
