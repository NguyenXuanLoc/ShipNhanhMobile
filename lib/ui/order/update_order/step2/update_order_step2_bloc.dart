// @dart = 2.9
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/order/new_order.dart';
import 'package:smartship_partner/data/network/request/order/create_update_order_request.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/network/response/order/new_order_response.dart';
import 'package:smartship_partner/data/repository/order_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/eventbus/create_order_event.dart';
import 'package:smartship_partner/eventbus/update_order_event.dart';
import 'package:smartship_partner/ui/order/update_order/update_order_event.dart';
import 'package:smartship_partner/ui/order/update_order/update_order_state.dart';
import 'package:smartship_partner/util/utils.dart';

class UpdateOrderStep2Bloc extends Bloc<UpdateOrderEvent, UpdateOrderState> {
  final UserRepository _userRepository = UserRepository.get(PrefsManager.get);
  OrderRepository _orderRepository;

  UpdateOrderStep2Bloc(initialState) : super(initialState) {
    _orderRepository = OrderRepository.get(_userRepository);
  }

  @override
  Stream<UpdateOrderState> mapEventToState(UpdateOrderEvent event) async* {
    switch (event.runtimeType) {
      case UpdateOrderStep2StartEvent:
        await _loadShipFeeData();
        return;
      case UpdateOrderStep2Event:
        var order = (event as UpdateOrderStep2Event).order;
        var file = (event as UpdateOrderStep2Event).file;
        if (order != null) {
          var response = await _requestUpdateOrder(file, order);
          return;
        }
    }
  }

  Future _loadShipFeeData() async {
    var user = await UserRepository.get(PrefsManager.get).getUserInfo();
    var event = UpdateOrderShipFeeEvent(
        user.baseShipFee, user.baseDistance, user.extraShipFee);
    Utils.eventBus.fire(event);
  }

  Future _requestUpdateOrder(File file, NewOrder order) async {
    try {
      var token = await _userRepository.getUserAuthToken();
      //TODO: cần thêm 1 số trường, nếu loại order khác ship
      var request = NewOrderRequest(newOrder: order, authToken: token);
      BaseResponse<NewOrderResposne> response;
      print('request update order: ' + json.encode(request));
      if (file == null) {
        response = await _orderRepository.updateOrder(request);
      } else {
        response = await _orderRepository.updateOrderWithImage(file, request);
      }
      if (response != null && response.isSuccess) {
        Utils.eventBus.fire(UpdateOrderResultEvent(true));
      } else {
        Utils.eventBus.fire(UpdateOrderResultEvent(
            false, response != null ? response.message ?? '' : ''));
      }
    } catch (error) {
      Utils.eventBus.fire(UpdateOrderResultEvent(false, ''));
    }
  }
}
