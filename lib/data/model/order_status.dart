// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/data/network/response/order/order_list_response.dart';

enum OrderStatus {
  OPEN,
  READY_TO_DELIVER,
  DELIVERING,
  DELIVERED,
  DELETED,
  BREAK,
  ALL
}

extension OrderStatusExtension on OrderStatus {
  static const values = {
    OrderStatus.OPEN: 0,
    OrderStatus.READY_TO_DELIVER: 1,
    OrderStatus.DELIVERING: 2,
    OrderStatus.DELIVERED: 3,
    OrderStatus.DELETED: 4,
    OrderStatus.BREAK: 5,
    OrderStatus.ALL: -1,
  };

  int get value => values[this];

  String name(BuildContext context) {
    if (values[this] == 0) {
      return AppTranslations.of(context).text('new_order');
    } else if (values[this] == 1) {
      return AppTranslations.of(context).text('ready_to_deliver_order');
    } else if (values[this] == 2) {
      return AppTranslations.of(context).text('delivering_order');
    } else if (values[this] == 3) {
      return AppTranslations.of(context).text('delivered_order');
    } else if (values[this] == 4) {
      return AppTranslations.of(context).text('order_deleted');
    } else if (values[this] == 5) {
      return AppTranslations.of(context).text('order_break');
    } else {
      return AppTranslations.of(context).text('all');
    }
  }
}
