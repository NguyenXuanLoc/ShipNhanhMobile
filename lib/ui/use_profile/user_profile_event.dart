// @dart = 2.9
import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/network/request/user_profile/update_user_profile_request.dart';
import 'package:smartship_partner/data/network/response/area/ship_areas_response.dart';
import 'package:smartship_partner/data/network/response/login/login_response.dart';

abstract class UserProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUserProfileEvent extends UserProfileEvent {}

class UpdateUserProfileEvent extends UserProfileEvent {
  UpdateUserRequest request;
  String avatarPath;
  AppB2BConfig area;
  UpdateUserProfileEvent(this.request, this.area, [this.avatarPath]);
}

class ShowTermOfUseEvent extends UserProfileEvent{
  @override
  List<Object> get props => [DateTime.now().millisecondsSinceEpoch];
}