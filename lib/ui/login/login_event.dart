import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

enum LoginPageType{
  phonePage,
  otpPage,
}
class LoginPageNavigationEvent extends LoginEvent{
  LoginPageType pageType;

  LoginPageNavigationEvent({this.pageType = LoginPageType.phonePage});
}

class SendPhoneNumberEvent extends LoginEvent {
  final String phoneNumber;

  SendPhoneNumberEvent(this.phoneNumber);
}

class CodeSentEvent extends LoginEvent{}

class VerifyOtpEvent extends LoginEvent{
  final String otpNumber;
  VerifyOtpEvent(this.otpNumber);
}