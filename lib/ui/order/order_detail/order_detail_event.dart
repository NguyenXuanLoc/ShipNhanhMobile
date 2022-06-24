// @dart = 2.9
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class OrderInfoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Fetch extends OrderInfoEvent {
  @override
  String toString() => 'Order Fetch';

  final int orderId;

  @override
  List<int> get props => [DateTime.now().millisecondsSinceEpoch]; // ensure each event is different

  Fetch({@required this.orderId}) : super();
}

class RateOrder extends OrderInfoEvent {
  @override
  String toString() => 'Rate Order';

  final int orderId;
  final int rate;
  final String feedback;

  @override
  List<Object> get props => [orderId, rate, feedback];

  RateOrder({@required this.orderId, this.rate, this.feedback}) : super();
}

class CancelOrder extends OrderInfoEvent {
  @override
  String toString() => 'Cancel Order';

  final int orderId;
  final String reason;

  @override
  List<Object> get props => [orderId, reason];

  CancelOrder({@required this.orderId, @required this.reason}) : super();
}
