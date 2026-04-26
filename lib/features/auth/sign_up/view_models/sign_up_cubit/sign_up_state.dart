import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpState {
  final bool isLoading;
  final String? errorMessage;
  final User? user;

  const SignUpState({this.isLoading = false, this.errorMessage, this.user});

  SignUpState copyWith({bool? isLoading, String? errorMessage, User? user}) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
  bool get isSuccess => user != null && !isLoading && !hasError;
}
