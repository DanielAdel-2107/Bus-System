import 'package:flutter/material.dart';

@immutable
abstract class DriverRegisterState {}

class DriverRegisterInitial extends DriverRegisterState {}

class DriverRegisterLoading extends DriverRegisterState {}

class DriverRegisterSuccess extends DriverRegisterState {}

class DriverRegisterFailure extends DriverRegisterState {
  final String errorMessage;

  DriverRegisterFailure({required this.errorMessage});
}

