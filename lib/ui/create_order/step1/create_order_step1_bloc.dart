// @dart = 2.9
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/shipper_model.dart';
import 'package:smartship_partner/data/repository/order_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/eventbus/create_order_event.dart';
import 'package:smartship_partner/ui/create_order/create_order_event.dart';
import 'package:smartship_partner/ui/create_order/create_order_state.dart';
import 'package:smartship_partner/util/utils.dart';

class CreateOrderStep1Bloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  UserRepository userRepository = UserRepository.get(PrefsManager.get);
  OrderRepository _orderRepository;

  CreateOrderStep1Bloc(CreateOrderState initialState) : super(initialState) {
    _orderRepository = OrderRepository.get(userRepository);
  }

  @override
  Stream<CreateOrderState> mapEventToState(CreateOrderEvent event) async* {
    switch (event.runtimeType) {
      case CreateOrderStep1StartEvent:
        await _loadDefaultAddress();
        await _loadShippersNearby();
        return;
      case CreateOrderTypeChangeEvent:
        await _loadDefaultAddress();
        return;
    }
  }

  Future _loadDefaultAddress() async {
    var data = await _orderRepository.getOrderDefaultData();
    print('load default address: $data');
    if (data != null) {
      Utils.eventBus.fire(CreateOrderAutoFillEvent(data));
    }
  }

  Future _loadShippersNearby() async {
    print('load shippers nearby');
    var response = await _orderRepository.getShippersNearby();
    print('load success: ' + (response.isSuccess.toString()));
    if (response != null && response.isSuccess) {
      Utils.eventBus
          .fire(NearbyShipperLoadedEBEvent(response.dataResponse.shippers));
    }
  }
}
