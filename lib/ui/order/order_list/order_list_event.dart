// @dart = 2.9
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:smartship_partner/data/model/order_status.dart';

abstract class OrderListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderListStarted extends OrderListEvent {
  @override
  String toString() => 'OrderListStarted';

  final OrderStatus initialStatus;

  @override
  List<OrderStatus> get props => [initialStatus];

  OrderListStarted({@required this.initialStatus}) : super();
}

class OrderListFetch extends OrderListEvent {
  @override
  String toString() => 'OrderListFetch';
}

class OrderListRefresh extends OrderListEvent {
  @override
  String toString() => 'OrderListRefresh';
}

class ChangeOrderStatus extends OrderListEvent {
  final OrderStatus newOrderStatus;

  @override
  List<OrderStatus> get props => [newOrderStatus];

  ChangeOrderStatus({@required this.newOrderStatus}) : super();
}

class EndOfListOrder extends OrderListEvent {

}