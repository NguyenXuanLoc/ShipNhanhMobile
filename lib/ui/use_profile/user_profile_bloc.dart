// @dart = 2.9
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/network/request/user_profile/update_user_profile_request.dart';
import 'package:smartship_partner/data/network/response/area/ship_areas_response.dart';
import 'package:smartship_partner/data/repository/config_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/eventbus/udate_user_event.dart';
import 'package:smartship_partner/ui/use_profile/user_profile.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserRepository _userRepository;
  ConfigRepository _configRepository;

  UserProfileBloc(UserProfileState initialState) : super(initialState) {
    _userRepository = UserRepository.get(PrefsManager.get);
    _configRepository = ConfigRepository.get();
  }

  @override
  Stream<UserProfileState> mapEventToState(UserProfileEvent event) async* {
    switch (event.runtimeType) {
      case LoadUserProfileEvent:
        var areaName = await _configRepository.getAreaConfigName();
        var areas =
            await _configRepository.getGroupAreasConfig();
        yield UserProfileLoadAreaConfigState(areas[0], areaName);
        return;
      case UpdateUserProfileEvent:
        /// Must save area first;
        var area =  (event as UpdateUserProfileEvent).area;
        if(area!=null){
          await _configRepository.saveXAppKey(area.appKey);
          await _configRepository.saveAreaConfigName(area.name);
        }

        /// After save app key, update user
        await _updateUserProfile((event as UpdateUserProfileEvent).request,
            (event as UpdateUserProfileEvent).avatarPath);
        return;
      case ShowTermOfUseEvent:
        await _showTermOfUse();
        return;
    }
  }

  Future _updateUserProfile(UpdateUserRequest request, String filePath) async {
    try {
      File file;
      if (filePath != null && filePath.isNotEmpty) {
        file = File(filePath);
      }
      var userInfo = await _userRepository.getUserInfo();
      request.newProfile.userId = userInfo.userId;
      print('userId: ' + request.newProfile.userId.toString());
      request.authToken = userInfo.authToken;
      print('request: ' + json.encode(request));
      var response = file != null
          ? await _userRepository.updateUserProfileWithAvatar(file, request)
          : await _userRepository.updateUserProfile(request);
      if (response != null) {
        print('update user: ' + (response.isSuccess ? 'success' : 'failed'));

        ///Success, enter home
        Utils.eventBus.fire(UpdateUserEvent(
            updateSuccess: response.isSuccess, message: response.message));
      } else {
        Utils.eventBus.fire(UpdateUserEvent(updateSuccess: false));
      }
    } catch (error) {
      print('update user profile failed: $error');
    }
    Utils.eventBus.fire(UpdateUserEvent(updateSuccess: false));
  }

  _showTermOfUse() async {
    var termOfUse = await _configRepository.getTermOfUse();
    if (await canLaunch(termOfUse)) {
      await launch(termOfUse);
    }
  }
}
