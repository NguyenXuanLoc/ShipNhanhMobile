// @dart = 2.9
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/shipper_model.dart';
import 'package:smartship_partner/data/repository/order_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/eventbus/create_order_event.dart';
import 'package:smartship_partner/eventbus/update_order_event.dart';
import 'package:smartship_partner/ui/create_order/create_order_event.dart';
import 'package:smartship_partner/ui/create_order/create_order_state.dart';
import 'package:smartship_partner/ui/order/update_order/update_order_event.dart';
import 'package:smartship_partner/ui/order/update_order/update_order_state.dart';
import 'package:smartship_partner/util/utils.dart';

class UpdateOrderStep1Bloc extends Bloc<UpdateOrderEvent, UpdateOrderState> {
  UserRepository userRepository = UserRepository.get(PrefsManager.get);
  OrderRepository _orderRepository;

  UpdateOrderStep1Bloc(UpdateOrderState initialState) : super(initialState) {
    _orderRepository = OrderRepository.get(userRepository);
  }

  @override
  Stream<UpdateOrderState> mapEventToState(UpdateOrderEvent event) async* {
    switch (event.runtimeType) {
      case UpdateOrderStep1StartEvent:
//        _loadUserInfo();
        await _loadShippersNearby();
        return;
      case UpdateOrderTypeChangeEvent:
        await _loadUserInfo();
        return;
    }
  }

  Future _loadUserInfo() async {
    var userModel = await userRepository.getUserInfo();
    if (userModel != null) {
      Utils.eventBus.fire(UpdateOrderUserEvent(userModel));
    }
  }

  Future _loadShippersNearby() async {
    print('load shippers nearby');
//    try {
    var response = await _orderRepository.getShippersNearby();
    print('load success: ' + (response.isSuccess.toString()));
    if (response != null && response.isSuccess) {
      Utils.eventBus.fire(NearbyShipperLoadedEBEvent(response.dataResponse.shippers));
    }
//    } catch (error) {
//      print('load Shipper nearby failed: $error');
//    }
  }
}
