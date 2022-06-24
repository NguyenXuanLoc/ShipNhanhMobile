// @dart = 2.9
class LoginSuccessEvent {
  bool missingUserInfo;
  bool loginSuccess;
  String message;
  LoginSuccessEvent({this.loginSuccess = true, this.missingUserInfo = false, this.message=''});
}

class LoginLoadingEvent{
  bool loading=false;

  LoginLoadingEvent({this.loading});
}