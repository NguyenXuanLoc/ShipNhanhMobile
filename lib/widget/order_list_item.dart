// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/data/model/order_item_model.dart';
import 'package:smartship_partner/data/model/order_status.dart';
import 'package:smartship_partner/data/model/order_type.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/order_info_element.dart';
import 'package:smartship_partner/widget/order_status_bar.dart';

class OrderListItem extends StatelessWidget {
  OrderItemModel orderItem;
  Function(OrderItemModel) onOrderItemClicked;

  OrderListItem({this.orderItem, this.onOrderItemClicked});

  @override
  Widget build(BuildContext context) {

    String addLabel;
    String addContent;
    String orderPrice;
    String deliverFee;
    String deliverDate;

    if (orderItem.orderStatus == OrderStatus.OPEN) {
      addLabel = AppTranslations.of(context).text('address_from');
      addContent = orderItem.addFrom;
    } else {
      addLabel = AppTranslations.of(context).text('address_to');
      addContent = orderItem.addTo;
    }

    orderPrice = '${Utils.formatCurrency(context).format(orderItem.orderPrice.toInt())}';
    deliverFee = '${Utils.formatCurrency(context).format(orderItem.deliverFee.toInt())}';
//    var dt = orderItem.deliverDate;
//    var formatter = DateFormat('dd/MM/yyy - HH:mm');
//    deliverDate = formatter.format(dt);
    
    return InkWell(
      onTap: () {
        onOrderItemClicked(orderItem);
      },
      child: Card(
        elevation: 3,
        child: Column(
          children: <Widget>[
            OrderStatusBar(orderStatus: orderItem.orderStatus),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Column(
                children: <Widget>[
                  OrderInfoElement(
                    label: '#${orderItem.orderId}',
                    delimiter: '-',
                    content: '${orderItem.orderType.name(context)}',
                  ),
                  OrderInfoElement(
                    label: '$addLabel',
                    delimiter: ':',
                    content: addContent,
                  ),
                  OrderInfoElement(
                    label: AppTranslations.of(context).text('order_amount'),
                    delimiter: ':',
                    content: orderPrice,
                  ),
                  OrderInfoElement(
                    label: AppTranslations.of(context).text('deliver_fee'),
                    delimiter: ':',
                    content: deliverFee,
                  ),
//                  OrderInfoElement(
//                    label: AppTranslations.of(context).text('deliver_date'),
//                    delimiter: ':',
//                    content: deliverDate,
//                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
