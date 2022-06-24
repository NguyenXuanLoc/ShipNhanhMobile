import 'package:smartship_partner/data/model/create_order_contact.dart';
import 'package:smartship_partner/data/model/user_info.dart';

class CreateOrderResultEvent {
  bool success;
  String message;

  CreateOrderResultEvent([this.success = false, this.message = '']);
}

/* Event for loading user info in creating order */
class CreateOrderAutoFillEvent {
  CreateOrderContact data;

  CreateOrderAutoFillEvent(this.data);
}

class CreateOrderShipFeeEvent {
  double baseFee;
  double baseDistance;
  double extraFee;

  CreateOrderShipFeeEvent(
      [this.baseFee = 10000, this.baseDistance = 2.2, this.extraFee = 5000]);
}
