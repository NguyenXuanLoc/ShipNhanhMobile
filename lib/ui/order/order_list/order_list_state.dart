// @dart = 2.9
import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/model/order_item_model.dart';
import 'package:smartship_partner/data/model/order_status.dart';

abstract class OrderListState extends Equatable {

  @override
  List<Object> get props => [];
}

class OrderListUninitialized extends OrderListState {

  OrderStatus currentOrderStatus;

  @override
  List<Object> get props => [currentOrderStatus];

  @override
  String toString() => 'Page loading';
}

class OrderListError extends OrderListState {
  @override
  String toString() => 'OrderListError';
}

class OrderListLoaded extends OrderListState {

  List<OrderItemModel> orderList;
  final bool hasReachedMax;
  final int orderTotal;
  final int pageIndex;
  OrderStatus currentOrderStatus;

  @override
  List<Object> get props => [orderList, orderTotal, currentOrderStatus];

  OrderListLoaded({this.orderList, this.hasReachedMax, this.orderTotal, this.pageIndex, this.currentOrderStatus});

  OrderListLoaded copyWith({
    List<OrderItemModel> orderList,
    bool hasReachedMax,
    int orderTotal,
    int pageIndex,
    OrderStatus orderStatus
  }) {
    return OrderListLoaded(
      orderList: orderList ?? this.orderList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      orderTotal:  orderTotal ?? this.orderTotal,
      pageIndex: pageIndex ?? this.pageIndex,
      currentOrderStatus: orderStatus ?? currentOrderStatus
    );
  }

  @override
  String toString() =>
      'OrderListPageLoaded { posts: ${orderList.length}, hasReachedMax: $hasReachedMax }';
}