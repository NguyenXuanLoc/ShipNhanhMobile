// @dart = 2.9
// To parse this JSON data, do
//
//     final newOrderRequest = newOrderRequestFromJson(jsonString);

import 'dart:convert';

import 'package:smartship_partner/data/model/order/new_order.dart';

NewOrderRequest newOrderRequestFromJson(String str) =>
    NewOrderRequest.fromJson(json.decode(str));

String newOrderRequestToJson(NewOrderRequest data) =>
    json.encode(data.toJson());

class NewOrderRequest {
  NewOrderRequest({
    this.newOrder,
    this.authToken,
  });

  NewOrder newOrder;
  String authToken;

  factory NewOrderRequest.fromJson(Map<String, dynamic> json) =>
      NewOrderRequest(
        newOrder: json["NewOrder"] == null
            ? null
            : NewOrder.fromJson(json["NewOrder"]),
        authToken: json["AuthToken"] == null ? null : json["AuthToken"],
      );

  Map<String, dynamic> toJson() => {
        "NewOrder": newOrder == null ? null : newOrder.toJson(),
        "AuthToken": authToken == null ? null : authToken,
      };
}
