import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/network/response/area/ship_areas_response.dart';

abstract class UserProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserProfileStartState extends UserProfileState {}

class UserProfileLoadAreaConfigState extends UserProfileState{
  List<AppB2BConfig> areas;
  String areaName;

  UserProfileLoadAreaConfigState(this.areas, this.areaName);
}