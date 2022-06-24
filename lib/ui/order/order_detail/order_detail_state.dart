// @dart = 2.9
import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/model/order_info.dart';

abstract class OrderInfoState extends Equatable {

  @override
  List<Object> get props => [];
}

class OrderInfoUninitialized extends OrderInfoState {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'OrderInfoUninitialized';
}

class OrderInfoError extends OrderInfoState {
  @override
  String toString() => 'OrderListError';
}

class OrderInfoLoaded extends OrderInfoState {
  OrderInfoModel orderInfo;

  @override
  List<Object> get props => [orderInfo];

  OrderInfoLoaded({this.orderInfo});

  @override
  String toString() =>
      'OrderInfoPageLoaded';
}

class RatedOrder extends OrderInfoState {
  @override
  List<Object> get props => [];

  @override
  String toString() =>
      'OrderInfoPageRated';
}

class CanceledOrder extends OrderInfoState {
  @override
  List<Object> get props => [];

  @override
  String toString() =>
      'CanceledOrder';
}

class CancelOrderFail extends OrderInfoState {
  OrderInfoModel orderInfo;
  String message;

  @override
  List<Object> get props => [orderInfo, message];

  CancelOrderFail({this.orderInfo, this.message});

  @override
  String toString() =>
      'CancelOrderFail';
}