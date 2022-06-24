import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/model/user_info.dart';

class SettingState extends Equatable{
  @override
  List<Object> get props => [];
}

class SettingStartState extends SettingState{}
class SettingUserLoadedState extends SettingState{
  UserInfoModel user;
  String areaName;
  SettingUserLoadedState(this.user, this.areaName);
  @override
  List<Object> get props => [user, this.areaName];
}