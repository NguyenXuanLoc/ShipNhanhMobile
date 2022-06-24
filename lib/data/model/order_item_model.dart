// @dart = 2.9
import 'order_status.dart';
import 'order_type.dart';

class OrderItemModel {
  final orderId;
  final OrderStatus orderStatus;
  final OrderType orderType;
  final String addFrom;
  final String addTo;
  final String description;
  final double orderPrice;
  final double deliverFee;
  final DateTime deliverDate;
  final String orderUrl;



  OrderItemModel({this.orderUrl, this.orderId, this.orderStatus,
    this.orderType, this.addFrom, this.addTo,
    this.orderPrice, this.deliverFee, this.deliverDate,
    this.description});
}