// @dart = 2.9
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/network/response/user_profile/user_response.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/ui/driver_info/drive_info_event.dart';
import 'package:smartship_partner/ui/driver_info/drive_info_state.dart';
import 'package:smartship_partner/util/utils.dart';

class DriveInfoBloc extends Bloc<DriveInfoEvent, DriveInfoState> {
  DriveInfoBloc(DriveInfoState initialState) : super(initialState);
  UserRepository _userRepository = UserRepository.get(PrefsManager.get);
  StreamController<UserResponse> _controller = StreamController<UserResponse>();

  Stream<UserResponse> get userStream => _controller.stream;

  @override
  Stream<DriveInfoState> mapEventToState(DriveInfoEvent event) async* {
    switch (event.runtimeType) {
      case LoadDriveInfoEvent:
        var temp = event as LoadDriveInfoEvent;
        var response = await _loadDriveData(temp.userId, temp.pageIndex);
        yield DriveDataLoadedState(
            response, temp.pageIndex, temp.pageIndex == 1);
    }
  }

  Future<UserResponse> _loadDriveData(int userId, int pageIndex) async {
    var token = await _userRepository.getUserAuthToken();
    BaseResponse<UserResponse> response =
        await _userRepository.loadUserInfoRemote(token, userId, pageIndex);
    if (response != null) {
      if (response.isSuccess) {
        return response.dataResponse;
      } else {
        Utils.eventBus.fire(LoadDriveFailedEBEvent(response.message));
      }
    }
    return null;
  }
}
