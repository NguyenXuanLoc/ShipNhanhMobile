import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/http.dart';
import 'package:smartship_partner/constant/api_constants.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/network/request/cancel_order_request.dart';
import 'package:smartship_partner/data/network/request/device/register_device_request.dart';
import 'package:smartship_partner/data/network/request/hereMap/accessToken_request.dart';
import 'package:smartship_partner/data/network/request/logout/logout_request.dart';
import 'package:smartship_partner/data/network/request/order/create_note_request.dart';
import 'package:smartship_partner/data/network/request/order/create_update_order_request.dart';
import 'package:smartship_partner/data/network/request/rate_order_request.dart';
import 'package:smartship_partner/data/network/request/user_profile/update_user_profile_request.dart';
import 'package:smartship_partner/data/network/response/area/ship_areas_response.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/network/response/create_order/shipper_nearby_response.dart';
import 'package:smartship_partner/data/network/response/here_map/HereAuth_Response.dart';
import 'package:smartship_partner/data/network/response/here_map/hereRoute_response.dart';
import 'package:smartship_partner/data/network/response/here_map/nearbyPlace_response.dart';
import 'package:smartship_partner/data/network/response/here_map/searchPlace_response.dart';
import 'package:smartship_partner/data/network/response/order/note_list_response.dart';
import 'package:smartship_partner/data/network/response/order/order_detail_reponse.dart';
import 'package:smartship_partner/data/network/response/order/order_list_response.dart';
import 'package:smartship_partner/data/network/response/statistic/statistic_response.dart';
import 'package:smartship_partner/data/network/response/user_profile/user_profile_data.dart';
import 'package:smartship_partner/data/network/response/user_profile/user_response.dart';
import 'package:smartship_partner/data/repository/config_repository.dart';

import 'request/feedback/feedback_request.dart';
import 'request/login_request.dart';
import 'response/create_order/shop_mall_response.dart';
import 'response/login/login_response.dart';
import 'response/order/new_order_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: BASE_URL)

abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) {
    dio.options = BaseOptions(
        receiveTimeout: 60000, connectTimeout: 60000, followRedirects: false);

    if (baseUrl == null)
      {
        dio.options.headers['x-Device'] = Platform.isAndroid ? 'android' : 'iOS';
        dio.options.headers['x-Version'] = Constants.app_version;
        dio.options.headers['x-Token'] = 'aHR0cDovL3d3dy5zbWFydHNoaXBhcHAuY29tDQo=';
      }

    // dio.options.headers['x-AppKey'] = 'jPdu4kyEIcc%3D';
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      var url = options.baseUrl;
      url.replaceAll('%25', '%');
      options.baseUrl = url;
      // Do something before request is sent
      debugPrint('url: ' + options.uri.toString());
      debugPrint('header: ' + options.headers.toString());
      debugPrint('body: ' + options.data.toString());
      handler.next(options);
    },
    onResponse: (response,handler) {
      // Do something with response data
      // Do something with response data
      debugPrint('responseCode: ' + response.statusCode.toString());

      debugPrint('response: ' + response.data.toString());
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: return `dio.reject(dioError)`
    },
      onError: (DioError e, handler) {
        debugPrint('Request error: ' + e.message);
        // Do something with response error
        return  handler.next(e);//continue
        // If you want to resolve the request with some custom data，
        // you can resolve a `Response` object eg: return `dio.resolve(response)`.
      }
    ));
    return _ApiClient(dio, baseUrl: baseUrl);
  }

  ////******************Config***********************************************//
  @GET(GROUP_CONFIG_PATH)
  Future<BaseResponse<ShipAreasResponse>> getShipAreas(
      [@Query('groupType') int groupType = 1]);

  ////***************************** user ********************************///
  @POST(LOGIN_PATH)
  Future<BaseResponse<LoginData>> login(
      @Header('x-AppKey') String xAppKey, @Body() LoginRequest request);

  @POST(UPDATE_USER_PATH)
  Future<BaseResponse<UserProfileData>> updateUserProfile(
      @Header('x-AppKey') String xAppKey, @Body() UpdateUserRequest request);

  @POST(UPDATE_USER_WITH_IMAGE_PATH)
  @MultiPart()
  Future<BaseResponse<UserProfileData>> updateUserProfileWithAvatar(
      @Header('x-AppKey') String xAppKey,
      @Part() File file,
      @Part(name: 'Data') UpdateUserRequest request);

  @GET(GET_USER_INFO_PATH)
  Future<BaseResponse<UserResponse>> getUserInfo(
      @Query('authToken') String authToken,
      @Query('userId') int userId,
      @Query('pageIndex') int pageIndex,
      @Header('x-AppKey') String xAppKey);

  @GET(GET_USER_APP_LOGIN_PATH)
  Future<BaseResponse<LoginData>> getUserAppLogin(
    @Header('x-AppKey') String xAppKey,
    @Query('authToken') String authToken,
  );

  @POST(SEND_FEEDBACK_PATH)
  Future<BaseResponse<dynamic>> sendFeedback(
      @Header('x-AppKey') String xAppKey, @Body() FeedbackRequest request);

  @POST(SEND_FEEDBACK_WITH_IMAGE_PATH)
  @MultiPart()
  Future<BaseResponse<dynamic>> sendFeedbackWithImage(
      @Header('x-AppKey') String xAppKey,
      @Part() File file,
      @Part(name: 'Data') FeedbackRequest request);

  @POST(REGISTER_DEVICE_PATH)
  Future<BaseResponse<dynamic>> registerDevice(
      @Header('x-AppKey') String xAppKey,
      @Body() RegisterDeviceRequest request);

  @POST(LOGOUT_PATH)
  Future<BaseResponse<dynamic>> logout(
      @Header('x-AppKey') String xAppKey, @Body() LogoutRequest request);

  ////***************************** user ********************************///

  ////***************************** order ********************************///
  @FormUrlEncoded()
  @GET(ORDER_LIST_PATH)
  Future<BaseResponse<OrderListData>> getOrderList(
    @Header('x-AppKey') String xAppKey,
    @Query('PageIndex') int pageIndex,
    @Query('PageSize') int pageSize,
    @Query('Keyword') String keyword,
    @Query('Status') int status,
    @Query('AuthToken', encoded: true) String authToken,
  );

  @GET(ORDER_DETAIL_PATH)
  Future<BaseResponse<OrderDetailData>> getOrderDetail(
    @Header('x-AppKey') String xAppKey,
    @Query('orderId') int orderId,
    @Query('AuthToken') String authToken,
  );

  @GET(SHIPPER_NEARBY_PATH)
  Future<BaseResponse<ShipperNearbyResponse>> getShippersNearby(
      @Header('x-AppKey') String xAppKey, @Query('authToken') String authToken);

  @GET(SHOP_MALL_PATH)
  Future<BaseResponse<ShopMallResponse>> getShopMalls(
      @Header('x-AppKey') String xAppKey, @Query('authToken') String authToken);

  @POST(CREATE_ORDER)
  Future<BaseResponse<NewOrderResposne>> createOrder(
      @Header('x-AppKey') String xAppKey, @Body() NewOrderRequest request);

  @POST(CREATE_ORDER_WITH_IMAGE_PATH)
  @MultiPart()
  Future<BaseResponse<NewOrderResposne>> createOrderWithImage(
      @Header('x-AppKey') String xAppKey,
      @Part() File file,
      @Part(name: 'Data') NewOrderRequest request);

  /// Create order with multi images
  @POST(CREATE_ORDER_WITH_IMAGE_PATH)
  @MultiPart()
  Future<BaseResponse<NewOrderResposne>> createOrderWithImages(
      @Header('x-AppKey') String xAppKey,
      @Part() List<File> file,
      @Part(name: 'Data') NewOrderRequest request);

  @POST(UPDATE_ORDER)
  Future<BaseResponse<NewOrderResposne>> updateOrder(
      @Header('x-AppKey') String xAppKey, @Body() NewOrderRequest request);

  @POST(UPDATE_ORDER_WITH_IMAGE_PATH)
  @MultiPart()
  Future<BaseResponse<NewOrderResposne>> updateOrderWithImage(
      @Header('x-AppKey') String xAppKey,
      @Part() File file,
      @Part(name: 'Data') NewOrderRequest request);

  @GET(NOTE_LIST_PATH)
  Future<BaseResponse<NoteListData>> getNoteList(
    @Header('x-AppKey') String xAppKey,
    @Query('orderId') int orderId,
    @Query('authToken') String authToken,
  );

  @POST(CREATE_NOTE_PATH)
  Future<BaseResponse<dynamic>> createNote(
      @Header('x-AppKey') String xAppKey, @Body() NewNoteRequest request);

////***************************** order ********************************///

  @POST(RATE_ORDER_PATH)
  Future<BaseResponse<Object>> rateOrder(@Header('x-AppKey') String xAppKey,
      @Body() RateOrderRequest rateOrderRequest);

  @POST(CANCEL_ORDER_PATH)
  Future<BaseResponse<Object>> cancelOrder(@Header('x-AppKey') String xAppKey,
      @Body() CancelOrderRequest cancelOrderRequest);

  @GET(STATISTIC_PATH)
  Future<BaseResponse<StatisticResponse>> getStatistic(
      @Header('x-AppKey') String xAppKey,
      @Query('authToken') String token,
      @Query('pageIndex') int pageIndex,
      @Query('from') String from,
      @Query('to') String to);

////***************************** order ********************************///

///*******************************heremap**********************************///
  @GET(HM_GET_ROUTE_PATH)
  Future<HereRoute> getRoute(
      @Query('apiKey') String apiKey,
      @Query('waypoint0') String waypoint0,
      @Query('waypoint1') String waypoint1,
      @Query('mode') String mode,
      @Query('routeattributes') String routeattributes);

  @GET(HM_NEARBY_PLACE_PATH)
  Future<NearbyPlace> getNearbyPlaces(
      @Query('apiKey') String apiKey,
      @Query('in') String _in,
      @Query('pretty') bool pretty);

  @GET(HM_SEARCH_PLACE_PATH)
  Future<SearchPlace> getSearchPlaces(
      @Query('apiKey') String apiKey,
      @Query('at') String at,
      @Query('limit') int limit,
      @Query('lang') String lang,
      @Query('countryCode') String countryCode,
      @Query('q') String query,);

  @POST(HM_AUTH_PATH)
  Future<HereAuthResponse> getAccessToken(
      @Body () AccessTokenRequest request);

///*******************************heremap**********************************///

}
