// @dart = 2.9
import 'dart:convert';

import 'order_status.dart';
import 'order_type.dart';
import 'person.dart';

OrderInfoModel orderInfoFromJson(String str) =>
    OrderInfoModel.fromJson(json.decode(str));

String orderInfoToJson(OrderInfoModel data) => json.encode(data.toJson());

class OrderInfoModel {
  final orderId;
  final OrderStatus orderStatus;
  final OrderType orderType;
  final double deliverFee;
  final double orderPrice;
  final String orderPicUrl;
  final String note;
  final String verifyPictureUrl;
  final String description;
  final bool rated;
  final String orderSharingUrl;

  final Person supplier;
  final Person receiver;
  final Person shipper;

  OrderInfoModel({this.orderId,
    this.orderStatus,
    this.orderType,
    this.orderPrice,
    this.deliverFee,
    this.supplier,
    this.receiver,
    this.note,
    this.verifyPictureUrl,
    this.description,
    this.shipper,
    this.orderPicUrl,
    this.rated,
  this.orderSharingUrl});

  factory OrderInfoModel.fromJson(Map<String, dynamic> json) {
    var orderStatusValue = json['orderStatus'];
    var os = OrderStatus.OPEN;
    for (var val in OrderStatus.values) {
      if (val.value == orderStatusValue) {
        os = val;
        break;
      }
    }

    var orderTypeValue = json['orderType'];
    var ot = OrderType.NORMAL;
    for (var val in OrderType.values) {
      if (val.value == orderTypeValue) {
        ot = val;
        break;
      }
    }

    return OrderInfoModel(
      orderId: json['orderId'],
      orderStatus: os,
      orderType: ot,
      orderPrice: json['orderPrice'],
      deliverFee: json['deliverFee'],
      supplier: Person.fromJson(json['supplier']),
      receiver: Person.fromJson(json['receiver']),
      note: json['note'],
      verifyPictureUrl: json['verifyPictureUrl'],
      description: json['description'],
      shipper: Person.fromJson(json['shipper']),
      orderPicUrl: json['orderPicUrl'],
      rated: json['rated'],
      orderSharingUrl: json['SharingUrl']
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderStatus': orderStatus.value,
      'orderType': orderType.value,
      'orderPrice': orderPrice,
      'deliverFee': deliverFee,
      'supplier': supplier.toJson(),
      'receiver': receiver.toJson(),
      'note': note,
      'verifyPictureUrl': verifyPictureUrl,
      'description': description,
      'shipper': shipper.toJson(),
      'orderPicUrl': orderPicUrl,
      'rated': rated,
      'SharingUrl': orderSharingUrl
    };
  }
}
