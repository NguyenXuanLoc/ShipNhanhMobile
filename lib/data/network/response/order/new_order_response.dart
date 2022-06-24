// @dart = 2.9
// To parse this JSON data, do
//
//     final newOrderResposne = newOrderResposneFromJson(jsonString);

import 'dart:convert';

import 'package:smartship_partner/data/model/order/order_model.dart';

NewOrderResposne newOrderResposneFromJson(String str) => NewOrderResposne.fromJson(json.decode(str));

String newOrderResposneToJson(NewOrderResposne data) => json.encode(data.toJson());

class NewOrderResposne {
  NewOrderResposne({
    this.newOrder,
  });

  OrderModel newOrder;

  factory NewOrderResposne.fromJson(Map<String, dynamic> json) => NewOrderResposne(
    newOrder: json["NewOrder"] == null ? null : OrderModel.fromJson(json["NewOrder"]),
  );

  Map<String, dynamic> toJson() => {
    "NewOrder": newOrder == null ? null : newOrder.toJson(),
  };
}

