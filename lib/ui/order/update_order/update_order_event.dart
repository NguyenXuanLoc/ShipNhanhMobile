// @dart = 2.9
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/model/order/new_order.dart';
import 'package:smartship_partner/data/model/order_type.dart';

abstract class UpdateOrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateOrderStep1StartEvent extends UpdateOrderEvent {
  int orderStatus;
  OrderType orderType;

  UpdateOrderStep1StartEvent({this.orderStatus, this.orderType});
}

class UpdateOrderTypeChangeEvent extends UpdateOrderEvent {
  OrderType type;

  UpdateOrderTypeChangeEvent(this.type);
}

/// Event to create Request
class UpdateOrderStep2Event extends UpdateOrderEvent {
  NewOrder order;
  File file;

  UpdateOrderStep2Event(this.order, [this.file]);
}

class UpdateOrderStep2StartEvent extends UpdateOrderEvent {
  UpdateOrderStep2StartEvent();
}