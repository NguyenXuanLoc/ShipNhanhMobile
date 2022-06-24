import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/constant/api_constants.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/location_model.dart';
import 'package:smartship_partner/data/network/request/cancel_order_request.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/network/response/order/order_detail_reponse.dart';
import 'package:smartship_partner/data/repository/order_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/ui/order/order_detail/order_detail.dart';
import 'package:smartship_partner/data/model/person.dart';
import 'package:smartship_partner/data/model/order_info.dart';
import 'package:smartship_partner/data/model/order_status.dart';
import 'package:smartship_partner/data/model/order_type.dart';

class OrderInfoBloc extends Bloc<OrderInfoEvent, OrderInfoState> {
  var orderRepository;
  final userRepository = UserRepository.get(PrefsManager.get);

  OrderInfoBloc({this.orderRepository}) : super(OrderInfoUninitialized()) {
    orderRepository = OrderRepository.get(userRepository);
  }

  @override
  Stream<OrderInfoState> mapEventToState(OrderInfoEvent event) async* {
    final currentState = state;

    if (event is Fetch) {
      var orderId = event.orderId;
      BaseResponse<OrderDetailData> orderDetailResponse =
          await orderRepository.getOrder(orderId);

      if (orderDetailResponse != null &&
          orderDetailResponse.isSuccess == true&&
          orderDetailResponse.isLogout == false) {
        var orderDetail = orderDetailResponse.dataResponse!.orderDetail;
        var orderInfo = _getOrderInfo(orderDetail);
        yield OrderInfoLoaded(orderInfo: orderInfo);
      } else {
        yield OrderInfoError();
      }
    } else if (event is RateOrder) {
      // rate order
      var orderId = event.orderId;
      var rate = event.rate;
      var feedback = event.feedback;
      BaseResponse<Object> response =
          await orderRepository.rateOrder(orderId, rate, feedback);
      if (response.isSuccess == true) {
        add(Fetch(orderId: orderId));
      }
    } else if (event is CancelOrder) {
      var token = await userRepository.getUserAuthToken();
      var cancelRequest = CancelOrderRequest(orderId: event.orderId, reason: event.reason, authToken: token);
      BaseResponse<Object> response =
      await orderRepository.cancelOrder(cancelRequest);

      if (response != null && response.isSuccess == true) {
        yield CanceledOrder();
      } else {
        var orderInfo;
        if (currentState is OrderInfoLoaded) {
          orderInfo = currentState.orderInfo;
        }

        yield CancelOrderFail(orderInfo: orderInfo, message: response.message);
      }
    }
  }

  OrderInfoModel _getOrderInfo(OrderDetail orderDetail) {
    var supplier = Person(
        userId: 0,
        number: '',
        displayName: orderDetail.fbShopName,
        phone: orderDetail.fbShopPhoneNumber,
        email: '',
        pictureUrl: '',
        totalRates: 0,
        location: LocationModel(
            lat: orderDetail.fromLat,
            lng: orderDetail.fromLng,
            address: orderDetail.fromAddress));

    final receiver = Person(
        displayName: orderDetail.receiverName,
        phone: orderDetail.receiverPhone,
        location: LocationModel(
            lat: orderDetail.toLat,
            lng: orderDetail.toLng,
            address: orderDetail.toAddress));

    final shipper = Person(
        userId: orderDetail.shipperId,
        displayName: orderDetail.shipperName,
        phone: orderDetail.shipperPhone,
        email: orderDetail.shipperEmail,
        pictureUrl: orderDetail.shipperPictureUrl,
        totalRates: orderDetail.shipperRate.toInt(),
        rate: orderDetail.shipperRate,
        location: LocationModel(
            lat: orderDetail.shipperLat,
            lng: orderDetail.shipperLng,
            address: ''));

    var orderType = OrderType.NORMAL;
    for (var type in OrderType.values) {
      if (type.value == orderDetail.categoryId) {
        orderType = type;
        break;
      }
    }
    return OrderInfoModel(
        orderId: orderDetail.idOrder,
        orderStatus: OrderStatus.values[orderDetail.status],
        orderType: orderType,
        orderPrice: orderDetail.amount,
        deliverFee: orderDetail.deliveryFee,
        supplier: supplier,
        receiver: receiver,
        note: orderDetail.notes ?? '',
        orderPicUrl: BASE_URL + 'order/image/${orderDetail.idOrder}',
        verifyPictureUrl: orderDetail.verifyImageUrl,
        description: orderDetail.description,
        shipper: shipper,
        rated: orderDetail.privateStatus == 2,
        orderSharingUrl: orderDetail.sharingUrl);
  }
}
