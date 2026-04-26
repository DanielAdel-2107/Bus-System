import 'package:equatable/equatable.dart';
import 'package:bus_system/features/profile/models/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

// Loading Data
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  const ProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}
class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

// Editing mode Toggle
class ProfileEditMode extends ProfileState {
  final ProfileModel profile;
  const ProfileEditMode(this.profile);
  @override
  List<Object?> get props => [profile];
}

// Updating Data
class ProfileUpdating extends ProfileState {}
class ProfileUpdateSuccess extends ProfileState {
  final ProfileModel profile;
  const ProfileUpdateSuccess(this.profile);
  @override
  List<Object?> get props => [profile];
}
class ProfileUpdateError extends ProfileState {
  final String message;
  const ProfileUpdateError(this.message);
  @override
  List<Object?> get props => [message];
}

// Logout
class ProfileLogoutLoading extends ProfileState {}
class ProfileLogoutSuccess extends ProfileState {}
class ProfileLogoutError extends ProfileState {
  final String message;
  const ProfileLogoutError(this.message);
  @override
  List<Object?> get props => [message];
}
