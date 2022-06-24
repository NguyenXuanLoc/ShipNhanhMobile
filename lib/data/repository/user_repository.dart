// @dart = 2.9
import 'dart:io';

import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/user_info.dart';
import 'package:smartship_partner/data/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:smartship_partner/data/network/request/device/register_device_request.dart';
import 'package:smartship_partner/data/network/request/feedback/feedback_request.dart';
import 'package:smartship_partner/data/network/request/login_request.dart';
import 'package:smartship_partner/data/network/request/logout/logout_request.dart';
import 'package:smartship_partner/data/network/request/user_profile/update_user_profile_request.dart';
import 'package:smartship_partner/data/network/response/area/ship_areas_response.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/network/response/login/login_response.dart';
import 'package:smartship_partner/data/network/response/user_profile/user_profile_data.dart';
import 'package:smartship_partner/data/network/response/user_profile/user_response.dart';
import 'package:smartship_partner/data/repository/base_service_repository.dart';
import 'package:smartship_partner/main.dart';

class UserRepository extends BaseServiceRepository {
  ApiClient _apiClient;

  PrefsManager prefs;
  static UserRepository _instance;

  static UserRepository get(PrefsManager prefs) {
    _instance ??= UserRepository(prefs);

    return _instance;
  }

  UserRepository(PrefsManager prefs) {
    this.prefs = prefs;
    var dio = Dio();
    _apiClient = ApiClient(dio);
  }

  Future<BaseResponse<LoginData>> login(LoginRequest request) async {
    return await _apiClient.login(await getAppKeyHeader(), request);
  }

  Future<BaseResponse<LoginData>> getUserAppLogin(String token) async {
    return await _apiClient.getUserAppLogin(await getAppKeyHeader(), token);
  }

  Future<BaseResponse<UserProfileData>> updateUserProfile(
      UpdateUserRequest request) async{
    return _apiClient.updateUserProfile(await getAppKeyHeader(), request);
  }

  Future<BaseResponse<UserProfileData>> updateUserProfileWithAvatar(
      File file, UpdateUserRequest request) async{
    return _apiClient.updateUserProfileWithAvatar(await getAppKeyHeader(), file, request);
  }

  Future<UserInfoModel> getUserInfo() async {
    return prefs.getUserInfo();
  }


  Future<String> getUserAuthToken() async {
    return prefs.getAuthToken();
  }

  Future<void> clearAllData() async {
    //TODO: need to remove the database
    await prefs.clearAllData();
  }

  void saveUserInfo(UserInfoModel userInfoModel) {
    prefs.saveUserInfo(userInfoModel);
  }

  Future<BaseResponse<UserResponse>> loadUserInfoRemote(
      String authToken, int userId, int pageIndex) async {
    return await _apiClient.getUserInfo( authToken, userId, pageIndex, await getAppKeyHeader(),);
  }

  Future<BaseResponse<dynamic>> sendFeedback(FeedbackRequest request) async {
    return await _apiClient.sendFeedback(await getAppKeyHeader(), request);
  }

  Future<BaseResponse<dynamic>> sendFeedbackWithImage(File file ,FeedbackRequest request) async {
    return await _apiClient.sendFeedbackWithImage(await getAppKeyHeader(), file, request);
  }

  Future<BaseResponse<dynamic>> registerDevice(
      RegisterDeviceRequest request) async {
    return await _apiClient.registerDevice(await getAppKeyHeader(), request);
  }

  Future<BaseResponse<dynamic>> logout(LogoutRequest request) async {
    return await _apiClient.logout(await getAppKeyHeader(), request);
  }

  Future<BaseResponse<ShipAreasResponse>> loadShipAreas() async {
    return await _apiClient.getShipAreas(1); //TODO: release branch need to change to 1
  }
}
