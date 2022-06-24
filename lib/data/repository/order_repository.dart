// @dart = 2.9
import 'dart:convert';

import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/create_order_contact.dart';
import 'package:smartship_partner/data/model/order_info.dart';
import 'dart:io';

import 'package:smartship_partner/data/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:smartship_partner/data/network/request/cancel_order_request.dart';
import 'package:smartship_partner/data/network/request/order/create_update_order_request.dart';
import 'package:smartship_partner/data/network/request/rate_order_request.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/network/response/order/order_detail_reponse.dart';
import 'package:smartship_partner/data/network/response/create_order/shop_mall_response.dart';
import 'package:smartship_partner/data/network/response/order/new_order_response.dart';
import 'package:smartship_partner/data/network/response/order/order_list_response.dart';
import 'package:smartship_partner/data/network/response/statistic/statistic_response.dart';
import 'package:smartship_partner/data/repository/base_service_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/data/network/response/create_order/shipper_nearby_response.dart';

class OrderRepository extends BaseServiceRepository {
  ApiClient _apiClient;
  UserRepository userRepository;
  static OrderRepository _instance;
  PrefsManager _pref;

  static OrderRepository get(UserRepository userRepository) {
    _instance ??= OrderRepository(userRepository);

    return _instance;
  }

  OrderRepository(UserRepository userRepository) {
    this.userRepository = userRepository;
    _pref = PrefsManager.get;
    var dio = Dio();
    _apiClient = ApiClient(dio);
  }

  Future<BaseResponse<OrderListData>> getOrderList(
      int pageIndex, int pageSize, int status) async {
    var token = await userRepository.getUserAuthToken();
    return _apiClient
        .getOrderList(await getAppKeyHeader(), pageIndex, pageSize, '', status, token)
        .catchError((onError) {});
  }

  Future<BaseResponse<OrderDetailData>> getOrder(int orderId) async {
    var token = await userRepository.getUserAuthToken();
    return await _apiClient.getOrderDetail(await getAppKeyHeader(), orderId, token);
  }

  Future<BaseResponse<Object>> rateOrder(
      int orderId, int rate, String feedBack) async {
    var token = await userRepository.getUserAuthToken();
    return await _apiClient.rateOrder(await getAppKeyHeader(), RateOrderRequest(
        orderId: orderId, rate: rate, feedback: feedBack, authToken: token));
  }

  Future<BaseResponse<ShipperNearbyResponse>> getShippersNearby() async {
    var token = await userRepository.getUserAuthToken();
    return _apiClient.getShippersNearby(await getAppKeyHeader(), token);
  }

  Future<BaseResponse<ShopMallResponse>> getShopMalls() async {
    var token = await userRepository.getUserAuthToken();
    return _apiClient.getShopMalls(await getAppKeyHeader(), token);
  }

  Future<BaseResponse<NewOrderResposne>> createOrder(
      NewOrderRequest request) async {
    return _apiClient.createOrder(await getAppKeyHeader(), request);
  }

  Future<BaseResponse<NewOrderResposne>> createOrderWithImage(
      File file, NewOrderRequest request) async {
    return _apiClient.createOrderWithImage(await getAppKeyHeader(), file, request);
  }

  /// Create order with multi images
  Future<BaseResponse<NewOrderResposne>> createOrderWithImages(
      List<File> files, NewOrderRequest request) async {
    return _apiClient.createOrderWithImages(await getAppKeyHeader(), files, request);
  }

  Future<BaseResponse<NewOrderResposne>> updateOrder(
      NewOrderRequest request) async {
    return _apiClient.updateOrder(await getAppKeyHeader(), request);
  }

  Future<BaseResponse<NewOrderResposne>> updateOrderWithImage(
      File file, NewOrderRequest request) async {
    return _apiClient.updateOrderWithImage(await getAppKeyHeader(), file, request);
  }

  Future<BaseResponse<Object>> cancelOrder(CancelOrderRequest request) async {
    return _apiClient.cancelOrder(await getAppKeyHeader(), request);
  }

  Future<BaseResponse<StatisticResponse>> getStatistic(
      int pageIndex, String fromUtc, String toUtc) async {
    var token = await userRepository.getUserAuthToken();
    return _apiClient.getStatistic(await getAppKeyHeader(), token, pageIndex, fromUtc, toUtc);
  }

  Future saveOrderDefaultData(CreateOrderContact data) async {
    return _pref.setString(
        PrefsManager.PREF_DEFAULT_ORDER_ADDRESS, json.encode(data));
  }

  Future<CreateOrderContact> getOrderDefaultData() async {
    String dataString =
        await _pref.getString(PrefsManager.PREF_DEFAULT_ORDER_ADDRESS, '');
    if (dataString.isEmpty) return null;
    return CreateOrderContact.fromJson(json.decode(dataString));
  }
}
