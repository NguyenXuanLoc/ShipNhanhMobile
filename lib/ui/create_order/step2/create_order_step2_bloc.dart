// @dart = 2.9
import 'dart:convert';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/order/new_order.dart';
import 'package:smartship_partner/data/network/request/order/create_update_order_request.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/network/response/order/new_order_response.dart';
import 'package:smartship_partner/data/repository/order_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/eventbus/create_order_event.dart';
import 'package:smartship_partner/util/utils.dart';

import '../create_order_event.dart';
import '../create_order_state.dart';

class CreateOrderStep2Bloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  final UserRepository _userRepository = UserRepository.get(PrefsManager.get);
  OrderRepository _orderRepository;

  CreateOrderStep2Bloc(initialState) : super(initialState) {
    _orderRepository = OrderRepository.get(_userRepository);
  }

  @override
  Stream<CreateOrderState> mapEventToState(CreateOrderEvent event) async* {
    switch (event.runtimeType) {
      case CreateOrderStep2StartEvent:
        await _loadShipFeeData();
        return;
      case CreateOrderStep2Event:
        var order = (event as CreateOrderStep2Event).order;
        var file = (event as CreateOrderStep2Event).file;
        if (order != null) {
          var response = await _requestCreateOrder(file, order);
          return;
        }
    }
  }

  Future _loadShipFeeData() async {
    var user = await UserRepository.get(PrefsManager.get).getUserInfo();
    var event = CreateOrderShipFeeEvent(
        user.baseShipFee, user.baseDistance, user.extraShipFee);
    Utils.eventBus.fire(event);
  }

  Future _requestCreateOrder(File file, NewOrder order) async {
    try {
      var token = await _userRepository.getUserAuthToken();
      var request = NewOrderRequest(newOrder: order, authToken: token);
      BaseResponse<NewOrderResposne> response;
      if (file == null) {
        response = await _orderRepository.createOrder(request);
      } else {
        response = await _orderRepository.createOrderWithImage(file, request);
      }
      if (response != null && response.isSuccess) {
        Utils.eventBus.fire(CreateOrderResultEvent(true));
      } else {
        Utils.eventBus.fire(CreateOrderResultEvent(
            false, response != null ? response?.message ?? '' : ''));
      }
    } catch (error) {
      Utils.eventBus.fire(CreateOrderResultEvent(false, ''));
    }
  }
}
