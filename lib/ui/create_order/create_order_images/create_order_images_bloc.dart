// @dart = 2.9
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/order/new_order.dart';
import 'package:smartship_partner/data/network/request/order/create_update_order_request.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/repository/order_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/eventbus/create_order_event.dart';
import 'package:smartship_partner/ui/create_order/create_order_images/create_order_images.dart';
import 'package:smartship_partner/ui/create_order/create_order_images/create_order_images_state.dart';
import 'package:smartship_partner/util/utils.dart';

class CreateOrderImagesBloc
    extends Bloc<CreateOrderImagesEvent, CreateOrderImagesState> {
  final UserRepository _userRepository = UserRepository.get(PrefsManager.get);
  OrderRepository _orderRepository;

  CreateOrderImagesBloc(CreateOrderImagesState initialState)
      : super(initialState) {
    _orderRepository = OrderRepository.get(_userRepository);
  }

  @override
  Stream<CreateOrderImagesState> mapEventToState(
      CreateOrderImagesEvent event) async* {
    switch (event.runtimeType) {
      case CreateOrderImagesStartEvent:
        await _loadDefaultAddress();
        return;
      case RequestCreateOrderImagesEvent:
        var order = (event as RequestCreateOrderImagesEvent).order;
        var files = (event as RequestCreateOrderImagesEvent).files;
        if (order != null && files != null && files.isNotEmpty) {
          for (var i = 0; i < files.length; i++) {
            debugPrint('create order: $i / ${files.length}');
            var result = await _requestCreateOrder(files[i], order);
            // update next value
            Utils.eventBus.fire(ProgressCreateOrderImagesEBEvent(
                index: i+1,
                total: files.length,
                success: result[0],
                message: result[1]
              )
            );
            await Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
              debugPrint('Just delay some second before create next order');
            });
          }
          return;
        }
    }
  }

  Future _loadDefaultAddress() async {
    var data = await _orderRepository.getOrderDefaultData();
    print('load default address: $data');
    if (data != null) {
      Utils.eventBus.fire(CreateOrderAutoFillEvent(data));
    }
  }

  Future<List<dynamic>> _requestCreateOrder(File file, NewOrder order) async {
    try {
      var token = await _userRepository.getUserAuthToken();
      var request = NewOrderRequest(newOrder: order, authToken: token);
      debugPrint('request: ${jsonEncode(request)}');
      BaseResponse<dynamic> response;
      response = await _orderRepository.createOrderWithImage(file, request);
      if (response != null && response.isSuccess) {
        return [true, ''];
      } else {
        return [false, response != null ? response.message ?? '' : ''];
      }
    } catch (error) {
      return [false, ''];
    }
  }
}
