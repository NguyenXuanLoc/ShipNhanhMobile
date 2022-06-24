// @dart = 2.9
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/user_info.dart';
import 'package:smartship_partner/data/network/request/logout/logout_request.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/network/response/user_profile/user_response.dart';
import 'package:smartship_partner/data/repository/config_repository.dart';
import 'package:smartship_partner/data/repository/db_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/ui/setting/setting.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  UserRepository _userRepository;
  ConfigRepository _configRepository;
  DatabaseRepository _databaseRepository = DatabaseRepository.get();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _auth = FirebaseAuth.instance;

  SettingBloc(SettingState initialState) : super(initialState) {
    _userRepository = UserRepository.get(PrefsManager.get);
    _configRepository = ConfigRepository.get();
  }

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    switch (event.runtimeType) {
      case SettingStartEvent:
        UserInfoModel user = await _loadUserInfo();
        String areaName = await _configRepository.getAreaConfigName();
        if (user != null) yield SettingUserLoadedState(user, areaName);
        return;
      case SettingInstructionEvent:
        await _loadInstruction();
        return;
      case SettingLogoutEvent:
        await _logout();
        return;

      case SettingHelpEvent:
        await _requestHelp();
        return;
    }
  }

  Future<UserInfoModel> _loadUserInfo() async {
    var user = await _userRepository.getUserInfo();

    if (user != null) {
      var userId = user.userId;
      var token = await _userRepository.getUserAuthToken();

      if (userId != null && token != null && token.isNotEmpty) {
        BaseResponse<UserResponse> response =
            await _userRepository.loadUserInfoRemote(token, userId, 1);
        print(
            'load user success: ${response.isSuccess} ${response.dataResponse.userInfo.shortDesc}');
        if (response != null && response.isSuccess) {
          var user = response.dataResponse.userInfo;
          if (user != null) {
            return UserInfoModel.fromUserInfo(user);
          }
        }
      }
    }
    return null;
  }

  Future<bool> _logout() async {
    print('request Logout');
    try {
      var fcmToken = await _firebaseMessaging.getToken();
      var authToken = await _userRepository.getUserAuthToken();
      var request = LogoutRequest(
          // deviceType: Platform.isAndroid ? 1 : 2,
          // deviceId: fcmToken,
          authToken: authToken);

      var response = await _userRepository.logout(request);
      if (response != null && response.isSuccess) {
        /* logout success, delete user info*/
        await _userRepository.clearAllData();
        await _databaseRepository.clearNotifications();
        await _auth.signOut();
        Utils.eventBus.fire(SettingLogoutResultEBEvent(true));
        return true;
      }
    } catch (error) {
      print('logout failed: $error');
    }
    Utils.eventBus.fire(SettingLogoutResultEBEvent(false));
    return false;
  }

  _requestHelp() async {
    var user = await _userRepository.getUserInfo();
    var shopPhone = user?.shopPhone;
    if (shopPhone != null && shopPhone.isNotEmpty) {
      if (await canLaunch('tel://${shopPhone}')) {
        await launch('tel://${shopPhone}');
      }
    }
  }

  _loadInstruction() async {
    var instruction = await _configRepository.getInstruction();
    print('load instruction: $instruction');
    if (await canLaunch(instruction)) {
      await launch(instruction);
    }
  }
}
