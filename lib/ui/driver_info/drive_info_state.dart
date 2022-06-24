import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/network/response/user_profile/user_response.dart';

abstract class DriveInfoState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitDriveInfoState extends DriveInfoState {}

class DriveDataLoadedState extends DriveInfoState {
  UserResponse data;
  bool isRefresh;
  int pageIndex;
  DriveDataLoadedState(this.data, this.pageIndex, [this.isRefresh = false]);

  @override
  List<Object> get props => [data];
}
