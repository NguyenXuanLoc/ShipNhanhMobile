// @dart = 2.9

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/data/model/order_status.dart';

class OrderStatusBar extends StatelessWidget {

  final OrderStatus orderStatus;

  OrderStatusBar({this.orderStatus});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String urlIcon;
    String textStr;
    Color textColor;
    switch (orderStatus) {

      case OrderStatus.OPEN:
        backgroundColor = AppColors.colorNewOrder;
        urlIcon = 'assets/images/phone/ic_new_order.svg';
        textStr = AppTranslations.of(context).text('new_order');
        textColor = AppColors.colorYellowDark;
        break;
      case OrderStatus.READY_TO_DELIVER:
        backgroundColor = AppColors.colorWaitingOrder;
        urlIcon = 'assets/images/phone/ic_waiting_order.svg';
        textStr = AppTranslations.of(context).text('ready_to_deliver_order');
        textColor = AppColors.colorTextWaitingOrder;
        break;
      case OrderStatus.DELIVERING:
        backgroundColor = AppColors.colorDeliveringOrder;
        urlIcon = 'assets/images/phone/ic_delivering_order.svg';
        textStr = AppTranslations.of(context).text('delivering_order');
        textColor = AppColors.colorTextHighLight;
        break;
      case OrderStatus.DELIVERED:
        backgroundColor = AppColors.colorDeliveredOrder;
        urlIcon = 'assets/images/phone/ic_delivered_order.svg';
        textStr = AppTranslations.of(context).text('delivered_order');
        textColor = AppColors.colorTextDeliveredOrder;
        break;

      case OrderStatus.BREAK:
        backgroundColor = AppColors.colorNewOrder;
        urlIcon = 'assets/images/phone/ic_delivered_order.svg';
        textStr = AppTranslations.of(context).text('order_break');
        textColor = AppColors.colorOrderBreak;
        break;

      default:
        backgroundColor = AppColors.colorNewOrder;
        urlIcon = 'assets/images/phone/ic_new_order.svg';
        textStr = AppTranslations.of(context).text('new_order');
        textColor = AppColors.colorTextHighLight;
    }

    return Container(
      padding: EdgeInsets.only(left: 10),
      height: 29,
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SvgPicture.asset(
            urlIcon,
          ),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text(
            textStr,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
          )
        ],
      ),
    );
  }
}