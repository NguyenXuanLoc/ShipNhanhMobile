import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

/// Login form
class LoginStartState extends LoginState {
  @override
  String toString() {
    return 'LoginStarted';
  }
}

/// Otp screen
class OtpState extends LoginState {}

class LoginSuccessState extends LoginState{}