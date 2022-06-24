// @dart = 2.9
import 'dart:collection';
import 'dart:convert';

import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/network/response/area/ship_areas_response.dart';
import 'package:smartship_partner/data/repository/base_service_repository.dart';

class ConfigRepository extends BaseServiceRepository {
  PrefsManager prefs;
  static ConfigRepository _instance;

  static ConfigRepository get() {
    _instance ??= ConfigRepository(PrefsManager.get);
    return _instance;
  }

  ConfigRepository(PrefsManager prefs) {
    this.prefs = prefs;
  }

  Future saveTermOfUse(String value) async {
    return await prefs.setString(PrefsManager.PREF_TERM_OF_USE, value);
  }

  Future saveInstruction(String value) async {
    return await prefs.setString(PrefsManager.PREF_INSTRUCTION, value);
  }

  Future<String> getTermOfUse() async {
    return await prefs.getString(
        PrefsManager.PREF_TERM_OF_USE, FirebaseConstants.DEFAULT_TERM_OF_USE);
  }

  Future<String> getInstruction() async {
    return await prefs.getString(
        PrefsManager.PREF_INSTRUCTION, FirebaseConstants.DEFAULT_INSTRUCTION);
  }

  /// Load group areas config
  /// return 2 value:
  /// + List<AppB2BConfig>
  /// + The time of last save
  Future<List<dynamic>> getGroupAreasConfig() async {
    var configs = await prefs.getString(PrefsManager.PREF_GROUP_AREAS, '');
    if (configs.isNotEmpty) {
      Iterable configIterable = jsonDecode(configs);
      List<AppB2BConfig> areasConfig = List<AppB2BConfig>.from(configIterable
              .map((e) => AppB2BConfig.fromJson(e as Map<String, dynamic>)))
          .toList();

      /// Get the last save
      int lastSave =
          await prefs.getInt(PrefsManager.PREF_GROUP_AREAS_LAST_SAVE_TIME);
      return [areasConfig, lastSave];
    } else {
      return [[], 0];
    }
  }

  Future setGroupAreasConfig(List<AppB2BConfig> areasConfig, int time) async {
    await prefs.setString(
        PrefsManager.PREF_GROUP_AREAS, jsonEncode(areasConfig));
    await prefs.setInt(PrefsManager.PREF_GROUP_AREAS_LAST_SAVE_TIME, time);
  }

  Future<String> getXAppKey() async {
    return prefs.getString(PrefsManager.PREF_X_APP_KEY, '');
  }

  Future saveXAppKey(String key) async {
    await prefs.setString(PrefsManager.PREF_X_APP_KEY, key);
  }

  Future<String> getAreaConfigName() async {
    return prefs.getString(PrefsManager.PREF_AREA_CONFIG_NAME, '');
  }

  Future saveAreaConfigName(String key) async {
    await prefs.setString(PrefsManager.PREF_AREA_CONFIG_NAME, key);
  }

}
