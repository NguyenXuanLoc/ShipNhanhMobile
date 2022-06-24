// @dart = 2.9
import 'package:flutter/cupertino.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';

enum OrderType{
  NORMAL, BULKY, DELIVER, EXPRESS, ORDER_FOR_SOMEONE, SHIPPER
}

extension OrderTypeExtension on OrderType {
  static const values = {
    OrderType.NORMAL: 4,
    OrderType.BULKY: 5,
    OrderType.DELIVER: 6, // Ship Hàng
    OrderType.EXPRESS: 7,
    OrderType.ORDER_FOR_SOMEONE: 8, // Mua hộ
    OrderType.SHIPPER: 9 // Xe ôm
  };

  int get value => values[this];

  String name(BuildContext context) {
    if (values[this] == OrderType.BULKY.value) {
      return AppTranslations.of(context).text('bulky_type');
    } else if (values[this] == OrderType.DELIVER.value){
      return AppTranslations.of(context).text('deliver_type');
    } else if (values[this] == OrderType.EXPRESS.value){
      return AppTranslations.of(context).text('express_type');
    } else if (values[this] == OrderType.ORDER_FOR_SOMEONE.value){
      return AppTranslations.of(context).text('order_for_someone_type');
    } else if (values[this] == OrderType.SHIPPER.value){
      return AppTranslations.of(context).text('shipper_type');
    } else {
      return AppTranslations.of(context).text('your_order_type');
    }
  }
}