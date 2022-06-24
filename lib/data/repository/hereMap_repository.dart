// @dart = 2.9
import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartship_partner/constant/api_constants.dart';
import 'package:smartship_partner/data/network/api_client.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/network/request/hereMap/accessToken_request.dart';
import 'package:smartship_partner/data/network/response/area/ship_areas_response.dart';
import 'package:smartship_partner/data/network/response/here_map/HereAuth_Response.dart';
import 'package:smartship_partner/data/network/response/here_map/hereRoute_response.dart';
import 'package:smartship_partner/data/network/response/here_map/nearbyPlace_response.dart';
import 'package:smartship_partner/data/network/response/here_map/searchPlace_response.dart';
import 'package:smartship_partner/data/repository/base_service_repository.dart';

class HereMapRepository extends BaseServiceRepository {
  PrefsManager prefs;
  ApiClient _routeApiClient;
  ApiClient _searchApiClient;
  ApiClient _nearbyApiClient;
  ApiClient _authApiClient;
  static HereMapRepository _instance;
  String hereAccessToken;

  static HereMapRepository get() {
    _instance ??= HereMapRepository();
    return _instance;
  }

  HereMapRepository() {
    var dio = Dio();
    _routeApiClient = ApiClient(dio,baseUrl: HM_BaseRouteUrl);
    _searchApiClient = ApiClient(dio,baseUrl: HM_BaseSearchUrl);
    _nearbyApiClient = ApiClient(dio,baseUrl: HM_BaseNearbyUrl);
    _authApiClient = ApiClient(dio,baseUrl: HM_BaseAuthUrl);

  }

  Future<HereRoute> getRouteInfo(
       LatLng startLoc, LatLng endLoc) async {
    var wayPoint0 = 'geo!${startLoc.latitude},${startLoc.longitude}';
    var wayPoint1 = 'geo!${endLoc.latitude},${endLoc.longitude}';
    return _routeApiClient.getRoute(HM_APIKEY, wayPoint0, wayPoint1, 'fastest;car;traffic:disabled','ri').catchError((onError) {
      print('error, getRouteInfo: $onError');
    });
  }

  Future<NearbyPlace> getNearbyPlace(
      LatLng nearbyLoc) async {
    var _in = '${nearbyLoc.latitude},${nearbyLoc.longitude};r=100';
    return _nearbyApiClient.getNearbyPlaces(HM_APIKEY, _in, true).catchError((onError) {
      print('error, getNearbyPlaces: $onError');
    });
  }

  Future<SearchPlace> searchPlace(
      LatLng searchLoc,String query) async {
    var at = '${searchLoc.latitude},${searchLoc.longitude}';
    return _searchApiClient.getSearchPlaces(HM_APIKEY,at,5,'vi','VN',query).catchError((onError) {
      print('error, getSearchPlaces: $onError');
    });
  }




  Future<String> getAccessToken() async {

    var accessTokenRequest = AccessTokenRequest(grant_type: 'client_credentials',client_id: HM_AUTH_CLIENT_ID,client_secret: HM_AUTH_CLIENT_SECRET);

    await _authApiClient.getAccessToken(accessTokenRequest).catchError((onError) {
      print('error, getAccessToken: $onError');
    }).then((HereAuthResponse _response){
      print('getAccessToken ${_response}');
      if(_response!= null &&
          _response.error==null &&
          _response.accessToken != null)
        {
          HereMapRepository.get().hereAccessToken = _response.accessToken;
        }
      else{
        HereMapRepository.get().hereAccessToken = null;
      }
    });
    return HereMapRepository.get().hereAccessToken;
  }
}
