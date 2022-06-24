// @dart = 2.9
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/constant/api_constants.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/order_item_model.dart';
import 'package:smartship_partner/data/model/order_status.dart';
import 'package:smartship_partner/data/model/order_type.dart';
import 'package:smartship_partner/data/repository/order_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/ui/order/order_list/order_list_event.dart';
import 'package:smartship_partner/ui/order/order_list/order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  OrderRepository orderRepository;
  int _orderTotal = 0;

  OrderListBloc() : super(OrderListUninitialized()) {
    final userRepository = UserRepository.get(PrefsManager.get);
    orderRepository = OrderRepository.get(userRepository);
  }

  @override
  Stream<OrderListState> mapEventToState(OrderListEvent event) async* {
    final currentState = state;
    switch (event.runtimeType) {
      case OrderListStarted:
        yield OrderListUninitialized();
        var orderList = await _getOrderList(
            1, ORDER_PAGE_LIMIT, (event as OrderListStarted).initialStatus);
        yield OrderListLoaded(
            orderList: orderList,
            hasReachedMax: orderList.length < ORDER_PAGE_LIMIT,
            orderTotal: _orderTotal,
            pageIndex: 1,
            currentOrderStatus: (event as OrderListStarted).initialStatus);
        break;
      case OrderListFetch:
        if (currentState is OrderListLoaded && !_hasReachedMax(currentState)) {

          final newOrderList = await _getOrderList(
              currentState.pageIndex + 1,
              ORDER_PAGE_LIMIT,
              currentState.currentOrderStatus);
          yield newOrderList.length < ORDER_PAGE_LIMIT
              ? currentState.copyWith(hasReachedMax: true)
              : OrderListLoaded(
                  orderList: currentState.orderList + newOrderList,
                  hasReachedMax: false);
        }
        break;
      case ChangeOrderStatus:
        var orderStatus = (event as ChangeOrderStatus).newOrderStatus;
        if ((currentState as OrderListLoaded).currentOrderStatus ==
            orderStatus) {
          return;
        }
        this..add(OrderListStarted(initialStatus: orderStatus));
        break;
      case EndOfListOrder:
        break;
      case OrderListRefresh:
        this..add(OrderListStarted(initialStatus: (currentState as OrderListLoaded).currentOrderStatus));
        break;
    }
  }

  bool _hasReachedMax(OrderListState state) =>
      state is OrderListLoaded && state.hasReachedMax;

  Future<List<OrderItemModel>> _getOrderList(
      int index, int limit, OrderStatus orderStatus) async {
    var orderListResponse =
        await orderRepository.getOrderList(index, limit, orderStatus.value);
    var orderListItem = <OrderItemModel>[];
    if (orderListResponse != null && orderListResponse.isSuccess && !orderListResponse.isLogout) {
      _orderTotal = orderListResponse.dataResponse.totalRecords;
      orderListItem = orderListResponse.dataResponse.orders.map((orderRes) {
        var orderType = OrderType.NORMAL;
        for (var type in OrderType.values) {
          if (type.value == orderRes.categoryId) {
            orderType = type;
            break;
          }
        }
        return OrderItemModel(
            orderId: orderRes.orderId,
            orderStatus: OrderStatus.values[orderRes.status],
            orderType: orderType,
            addFrom: orderRes.fromAddress,
            addTo: orderRes.toAddress,
            orderPrice: orderRes.amount,
            deliverFee: orderRes.deliveryFee,
            deliverDate: orderRes.deadline);
      }).toList();
    }
    return orderListItem;
  }
}
