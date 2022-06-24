// @dart = 2.9
// To parse this JSON data, do
//
//     final newOrder = newOrderFromJson(jsonString);

import 'dart:convert';

NewOrder newOrderFromJson(String str) => NewOrder.fromJson(json.decode(str));

String newOrderToJson(NewOrder data) => json.encode(data.toJson());

class NewOrder {
  NewOrder(
      {this.notes,
      this.fromAddress,
      this.toAddress,
      this.receiverPhone,
      this.receiverName,
      this.amount,
      this.shipFee,
      this.prepay = 0,
      this.expectedTime = '',
      this.category,
      this.fromLat,
      this.toLat,
      this.fromLng,
      this.toLng,
      this.distance = 0,
      this.isOnbehalf,
      this.onbehalfName,
      this.onbehalfPhoneNumber,
      this.weight = 0,
      this.paidBy = 0,
      this.idShopMall=0,
      this.orderId,
      this.noteFee = ''});

  String notes;
  String fromAddress;
  String toAddress;
  String receiverPhone;
  String receiverName;
  double amount;
  double shipFee;
  double prepay;
  String expectedTime;
  int category;
  double fromLat;
  double toLat;
  double fromLng;
  double toLng;
  double distance;
  bool isOnbehalf;
  String onbehalfName;
  String onbehalfPhoneNumber;
  double weight = 0;
  int paidBy = 0;
  int idShopMall = 0;
  int orderId = 0;
  String noteFee ='';

  factory NewOrder.fromJson(Map<String, dynamic> json) => NewOrder(
      notes: json["Notes"] == null ? null : json["Notes"],
      fromAddress: json["FromAddress"] == null ? null : json["FromAddress"],
      toAddress: json["ToAddress"] == null ? null : json["ToAddress"],
      receiverPhone:
          json["ReceiverPhone"] == null ? null : json["ReceiverPhone"],
      receiverName: json["ReceiverName"] == null ? null : json["ReceiverName"],
      amount: json["Amount"] == null ? null : json["Amount"],
      shipFee: json["ShipFee"] == null ? null : json["ShipFee"],
      prepay: json["Prepay"] == null ? null : json["Prepay"],
      expectedTime: json["ExpectedTime"] == null ? null : json["ExpectedTime"],
      category: json["Category"] == null ? null : json["Category"],
      fromLat: json["FromLat"] == null ? null : json["FromLat"],
      toLat: json["ToLat"] == null ? null : json["ToLat"],
      fromLng: json["FromLng"] == null ? null : json["FromLng"],
      toLng: json["ToLng"] == null ? null : json["ToLng"],
      distance: json["Distance"] == null ? null : json["Distance"],
      isOnbehalf: json["IsOnbehalf"] == null ? null : json["IsOnbehalf"],
      onbehalfName: json["OnbehalfName"] == null ? null : json["OnbehalfName"],
      onbehalfPhoneNumber: json["OnbehalfPhoneNumber"] == null
          ? null
          : json["OnbehalfPhoneNumber"],
      weight: json["Weight"] == null ? null : json["Weight"],
      paidBy: json["PaidBy"] == null ? null : json["PaidBy"],
      idShopMall: json["IdShopMall"] == null ? null : json["IdShopMall"],
      orderId: json['Id']);

  Map<String, dynamic> toJson() => {
        "Notes": notes == null ? null : notes,
        "FromAddress": fromAddress == null ? null : fromAddress,
        "ToAddress": toAddress == null ? null : toAddress,
        "ReceiverPhone": receiverPhone == null ? null : receiverPhone,
        "ReceiverName": receiverName == null ? null : receiverName,
        "Amount": amount == null ? null : amount,
        "ShipFee": shipFee == null ? null : shipFee,
        "Prepay": prepay == null ? null : prepay,
        "ExpectedTime": expectedTime == null ? null : expectedTime,
        "Category": category == null ? null : category,
        "FromLat": fromLat == null ? null : fromLat,
        "ToLat": toLat == null ? null : toLat,
        "FromLng": fromLng == null ? null : fromLng,
        "ToLng": toLng == null ? null : toLng,
        "Distance": distance == null ? null : distance,
        "IsOnbehalf": isOnbehalf == null ? null : isOnbehalf,
        "OnbehalfName": onbehalfName == null ? null : onbehalfName,
        "OnbehalfPhoneNumber":
            onbehalfPhoneNumber == null ? null : onbehalfPhoneNumber,
        "Weight": weight == null ? null : weight,
        "PaidBy": paidBy == null ? null : paidBy,
        "IdShopMall": idShopMall == null ? null : idShopMall,
        'Id': orderId
      };
}
