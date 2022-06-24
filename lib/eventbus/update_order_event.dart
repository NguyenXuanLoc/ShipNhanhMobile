import 'package:smartship_partner/data/model/user_info.dart';

class UpdateOrderResultEvent {
  bool success;
  String message;

  UpdateOrderResultEvent([this.success = false, this.message = '']);
}

/* Event for loading user info in creating order */
class UpdateOrderUserEvent {
  UserInfoModel user;

  UpdateOrderUserEvent(this.user);
}

class UpdateOrderShipFeeEvent {
  double baseFee;
  double baseDistance;
  double extraFee;

  UpdateOrderShipFeeEvent(
      [this.baseFee = 10000, this.baseDistance = 2.2, this.extraFee = 5000]);
}
