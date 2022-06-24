// @dart = 2.9
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartship_partner/data/model/user_info.dart';

class PrefsManager {
  static const PREF_USER_INFO = 'PREF_USER_INFO';
  static const PREF_AUTH_TOKEN = 'PREF_AUTH_TOKEN';
  static const PREF_DEFAULT_ORDER_ADDRESS = 'PREF_DEFAULT_ORDER_ADDRESS';
  static const PREF_TERM_OF_USE = 'PREF_TERM_OF_USE';
  static const PREF_INSTRUCTION = 'PREF_INSTRUCTION';

  static const PREF_GROUP_AREAS = 'PREF_GROUP_AREAS';
  static const PREF_GROUP_AREAS_LAST_SAVE_TIME = 'PREF_GROUP_AREAS_LAST_SAVE_TIME';
  static const PREF_X_APP_KEY='PREF_X_APP_KEY'; //The header of request for each area
  static const PREF_AREA_CONFIG_NAME ='PREF_AREA_CONFIG_NAME';
  SharedPreferences _prefs;

  Future<SharedPreferences> get prefs async {
    if (_prefs != null)
      return _prefs;
    else {
      _prefs = await SharedPreferences.getInstance();
      return _prefs;
    }
  }

  static final _instance = PrefsManager();
  static PrefsManager get = _instance;

  Future saveUserInfo(UserInfoModel userInfoModel) async {
    await saveAuthToken(userInfoModel);
    await (await prefs).setString(PREF_USER_INFO, jsonEncode(userInfoModel));
  }

  Future<UserInfoModel> getUserInfo() async {
    var userInfoStr = (await prefs).getString(PREF_USER_INFO);
    return userInfoModelFromJson(userInfoStr);
  }

  Future saveAuthToken(UserInfoModel userInfoModel) async {
    await (await prefs).setString(PREF_AUTH_TOKEN, userInfoModel.authToken);
  }

  Future<String> getAuthToken() async {
    return (await prefs).getString(PREF_AUTH_TOKEN);
  }

  Future<int> getUserId() async {
    var userInfo = await getUserInfo();
    return userInfo.userId;
  }

  Future<void> clearAllData() async {
    // clear userdata,
    var _pref = await prefs;
    await _pref.clear();
    return;
  }

  Future setString(String key, String value) async {
    await (await prefs).setString(key, value);
  }

  Future<String> getString(String key, [String defaultValue = '']) async {
    return await (await prefs).getString(key) ?? defaultValue;
  }

  Future setInt(String key, int value) async {
    await (await prefs).setInt(key, value);
  }

  Future<int> getInt(String key, [int defaultValue = 0]) async {
    return await (await prefs).getInt(key) ?? defaultValue;
  }

}
