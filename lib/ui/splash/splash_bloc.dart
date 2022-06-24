// @dart = 2.9
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/user_info.dart';
import 'package:smartship_partner/data/network/request/device/register_device_request.dart';
import 'package:smartship_partner/data/network/response/area/ship_areas_response.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/network/response/login/login_response.dart';
import 'package:smartship_partner/data/repository/config_repository.dart';
import 'package:smartship_partner/data/repository/db_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/eventbus/event_bus_splash_event.dart';
import 'package:smartship_partner/ui/splash/splash.dart';
import 'package:smartship_partner/util/utils.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  UserRepository _userRepository;
  ConfigRepository _configRepository;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  SplashBloc(SplashState initialState) : super(initialState) {
    _userRepository = UserRepository.get(PrefsManager.get);
    _configRepository = ConfigRepository.get();
  }

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    print('event: ' + event.runtimeType.toString());
    switch (event.runtimeType) {
      case SplashStartEvent:
        await DatabaseRepository.get().init(); // Init database
        var areasConfig = await _loadGroupAreas();
        await _checkAreaAppKey(areasConfig); //
        return;
      case SplashSelectedAreaEvent:

      /// Save xApp-Key, area Name and loading user info
        await _configRepository
            .saveXAppKey((event as SplashSelectedAreaEvent).area.appKey);
        await _configRepository
            .saveAreaConfigName((event as SplashSelectedAreaEvent).area.name);
        add(SplashLoadUserEvent());
        return;
      case SplashLoadUserEvent:
        var token = await _userRepository.getUserAuthToken();
        var loggedIn = token != null && token.isNotEmpty;
        var tasks = <Future<dynamic>>[];
        if (loggedIn) {
          tasks.add(_loadUserInfo(token));
          tasks.add(_registerDevice(token));
        }
        await Future.wait(tasks);
        Utils.eventBus.fire(SplashUserLoggedInEvent(loggedIn: loggedIn));
    }
  }

  Future<bool> _loadUserInfo(String token) async {
    print('loadUserInfo');
    var response = await _userRepository.getUserAppLogin(token);
    if (response != null && response.isSuccess) {
      var userData = response.dataResponse;
      if (userData != null && userData.user != null) {
        var userModel = UserInfoModel.fromUser(userData.user);
        print(
            'loadUserInfo success, saved user data ${json.encode(userModel)}');
        await _userRepository.saveUserInfo(userModel);
        var termOfUse = userData?.user?.termCondition ?? '';
        var instruction = userData?.user?.guideUrl ?? '';
        debugPrint('term: $termOfUse -- instruction: $instruction');

        /// If termOfUser or guid is Empty, load remoteConfig instead
        if (termOfUse.isEmpty || instruction.isEmpty) {
          await _loadRemoteConfig();
        } else {
          await _configRepository.saveTermOfUse(termOfUse);
          await _configRepository.saveInstruction(instruction);
        }
        return true;
      }
    }
    return false;
  }

  /// Register device to Server for receiving notification
  Future<void> _registerDevice(String authToken) async {
    try {
      var token = await _firebaseMessaging.getToken();
      print('FCM token: $token');
      if (token == null || token.isEmpty) {
        print("can't retrieve firebase token");
        return;
      }
      var request = RegisterDeviceRequest(
          authToken: authToken,
          deviceId: token,
          deviceType: Platform.isAndroid ? 1 : 2, // Android :1, iOS: 2
          oldDeviceId: '');
      var response = await _userRepository.registerDevice(request);
      if (response != null && response.isSuccess) {
        print('register device success : $token');
      } else {
        print('register device failed: ');
      }
    } catch (error) {
      print('register device faield: $error');
    }
  }

  Future _loadRemoteConfig() async {
    print('Load remote config: ');
    try {
      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      await remoteConfig.setDefaults(FirebaseConstants.DEFAULT_RMT_CONFIG);
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(hours: 5),
      ));
      await remoteConfig.fetchAndActivate();
      await _configRepository.saveTermOfUse(
          remoteConfig.getString(FirebaseConstants.KEY_TERM_OF_USE));
      await _configRepository.saveInstruction(
          remoteConfig.getString(FirebaseConstants.KEY_INSTRUCTION));
      print('save config success');
    } catch (error) {
      print('Load remote config error: $error');
    }
  }

  Future<List<AppB2BConfig>> _loadGroupAreas() async {
    debugPrint('_loadGroupAreas');
    var currentTime = DateTime
        .now()
        .millisecondsSinceEpoch;
    var configs = await _configRepository.getGroupAreasConfig();
    var expired = (currentTime - configs[1] ?? 0) > 8640000;
    if (configs[0] == null || configs[0].isEmpty || expired) {
      /// config not found or expired, reload
      try {
        var response = await _userRepository.loadShipAreas();
        if (response == null) {
          throw Exception('null response');
        } else {
          if (!response.isSuccess) {
            throw Exception(response.message);
          } else {
            var appB2bConfigs = response.dataResponse?.appB2BConfigs;
            if (appB2bConfigs == null || appB2bConfigs.isEmpty) {
              throw Exception('list area is empty');
            } else {
              /// When use default config, we will re-use the last time
              await _configRepository.setGroupAreasConfig(
                  appB2bConfigs, DateTime
                  .now()
                  .millisecondsSinceEpoch);
              return appB2bConfigs;
            }
          }
        }
      } catch (e) {
        debugPrint('load failed: $e');

        /// use default config
        var defaultConfigString =
        await rootBundle.loadString('assets/configs/ship_areas.json');
        Iterable iterable = jsonDecode(defaultConfigString);
        var areas = List<AppB2BConfig>.from(iterable.map(
                (e) => AppB2BConfig.fromJson(e as Map<String, dynamic>)))
            .toList();

        /// When use default config, we will re-use the last time
        await _configRepository.setGroupAreasConfig(areas, configs[1]);
        return areas;
      }
    } else {
      /// If data is not expired, do nothing...
      return configs[0];
    }
  }

  /// If user not select area, fire an event for choosing
  Future _checkAreaAppKey(List<AppB2BConfig> areasConfig) async {
    var appKey = await _configRepository.getXAppKey();
    if (appKey.isEmpty) {
      Utils.eventBus.fire(SplashNotSelectAreaEvent(areasConfig));
    } else {
      // if appKey exist, just continue the flow
      var token = await _userRepository.getUserAuthToken();
      var loggedIn = token != null && token.isNotEmpty;
      if (!loggedIn) {
        // If user not logged in, always reload app key
        Utils.eventBus.fire(SplashNotSelectAreaEvent(areasConfig));
      } else {
        add(SplashLoadUserEvent());
      }
    }
  }
}
