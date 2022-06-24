// @dart = 2.9
import 'package:equatable/equatable.dart';

abstract class SettingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingStartEvent extends SettingEvent {
  int value;

  SettingStartEvent() {
    value = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  List<Object> get props => [value];
}

class SettingLogoutEvent extends SettingEvent {}

class SettingHelpEvent extends SettingEvent {
  int value;

  SettingHelpEvent() {
    value = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  List<Object> get props => [value];
}

class SettingInstructionEvent extends SettingEvent {
  int value;

  SettingHelpEvent() {
    value = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  List<Object> get props => [value];
}

///***************Event Bus*****************/
class SettingLogoutResultEBEvent {
  bool isLoggedOut;

  SettingLogoutResultEBEvent(this.isLoggedOut);
}
