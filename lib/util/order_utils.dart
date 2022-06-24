import 'package:flutter/cupertino.dart';

class OrderUtil {
  static double calculateShipFee(double baseShipFee, double baseDistance,
      double distance, double extraShipFee) {
    debugPrint(
        'calculate ship fee-- BaseShipFee: $baseShipFee baseDistance: $baseDistance distance: $distance extraShipFee: $extraShipFee');
    if (distance < baseDistance) return 10000;
    var fee = baseShipFee + (distance - baseDistance).ceil() * extraShipFee;
    if (fee < 0) return 10000;
    return formatShipFee(fee);
  }

  static double formatShipFee(double value) {
    var feeInt = value.toInt();
    var temp = feeInt ~/ 1000;
    var thousand = feeInt % 1000;
    if (thousand > 500) {
      thousand = 1000;
    } else if (thousand < 500) {
      thousand = 0;
    }
    var result = (temp * 1000).toDouble() + thousand;
    return result;
  }

  static String formatDistance(double value) {
    if (value == 0) return 'Không sẵn có';
    return '${value.toStringAsFixed(1)}km';
  }
}
