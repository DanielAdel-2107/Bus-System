part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpSuccess extends SignUpState {}

final class SignUpFailure extends SignUpState {
  final String errorMessage;

  SignUpFailure({required this.errorMessage});
}

final class PasswordDontMatch extends SignUpState {}

//
final class ChangeTermsAndPolicy extends SignUpState {}

final class AcceptTermsAndPolicy extends SignUpState {}
//


final class PickUserImageSuccess extends SignUpState {}

final class PickUserImageFailure extends SignUpState {
  final String errorMessage;
  PickUserImageFailure({required this.errorMessage});
}

final class ImageRequired extends SignUpState {}