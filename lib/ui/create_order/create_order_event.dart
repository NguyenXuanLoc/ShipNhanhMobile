// @dart = 2.9
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/model/order/new_order.dart';
import 'package:smartship_partner/data/model/shipper_model.dart';

abstract class CreateOrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateOrderStep1StartEvent extends CreateOrderEvent {
  int orderStatus;
  int orderType;

  CreateOrderStep1StartEvent({this.orderStatus, this.orderType});
}

class CreateOrderTypeChangeEvent extends CreateOrderEvent {
  int type;

  CreateOrderTypeChangeEvent(this.type);
}

class CreateOrderStep2StartEvent extends CreateOrderEvent {
  CreateOrderStep2StartEvent();
}

/// Event to create Request
class CreateOrderStep2Event extends CreateOrderEvent {
  NewOrder order;
  File file;

  CreateOrderStep2Event(this.order, [this.file]);
}

///************Event bus event **************/
class NearbyShipperLoadedEBEvent {
  List<ShipperModel> data = [];

  NearbyShipperLoadedEBEvent([this.data]);
}
