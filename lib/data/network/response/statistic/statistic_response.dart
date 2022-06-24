// @dart = 2.9
// To parse this JSON data, do
//
//     final statisticResponse = statisticResponseFromJson(jsonString);

import 'dart:convert';

StatisticResponse statisticResponseFromJson(String str) =>
    StatisticResponse.fromJson(json.decode(str));

String statisticResponseToJson(StatisticResponse data) =>
    json.encode(data.toJson());

class StatisticResponse {
  StatisticResponse({
    this.userHistory,
    this.totalAmount,
    this.totalShipFee,
    this.totalRecords,
    this.startTime,
    this.lastTime,
  });

  List<UserHistory> userHistory;
  double totalAmount = 0;
  double totalShipFee = 0;
  double totalRecords = 0;
  String startTime;
  String lastTime;

  factory StatisticResponse.fromJson(Map<String, dynamic> json) =>
      StatisticResponse(
        userHistory: json["UserHistory"] == null
            ? null
            : List<UserHistory>.from(
                json["UserHistory"].map((x) => UserHistory.fromJson(x))),
        totalAmount:
            json["TotalAmount"] == null ? null : json["TotalAmount"].toDouble(),
        totalShipFee: json["TotalShipFee"] == null
            ? null
            : json["TotalShipFee"].toDouble(),
        totalRecords: json["TotalRecords"] == null
            ? null
            : json["TotalRecords"].toDouble(),
        startTime: json["StartTime"] == null ? null : json["StartTime"],
        lastTime: json["LastTime"] == null ? null : json["LastTime"],
      );

  Map<String, dynamic> toJson() => {
        "UserHistory": userHistory == null
            ? null
            : List<dynamic>.from(userHistory.map((x) => x.toJson())),
        "TotalAmount": totalAmount == null ? null : totalAmount,
        "TotalShipFee": totalShipFee == null ? null : totalShipFee,
        "TotalRecords": totalRecords == null ? null : totalRecords,
        "StartTime": startTime == null ? null : startTime,
        "LastTime": lastTime == null ? null : lastTime,
      };
}

class UserHistory {
  UserHistory({
    this.orderId,
    this.amount = 0,
    this.shipFee = 0,
    this.shippedTime,
  });

  int orderId;
  double amount;
  double shipFee;
  String shippedTime;

  factory UserHistory.fromJson(Map<String, dynamic> json) => UserHistory(
        orderId: json["OrderId"] == null ? null : json["OrderId"],
        amount: json["Amount"] == null ? null : json["Amount"].toDouble(),
        shipFee: json["ShipFee"] == null ? null : json["ShipFee"].toDouble(),
        shippedTime: json["ShippedTime"] == null ? null : (json["ShippedTime"]),
      );

  Map<String, dynamic> toJson() => {
        "OrderId": orderId == null ? null : orderId,
        "Amount": amount == null ? null : amount,
        "ShipFee": shipFee == null ? null : shipFee,
        "ShippedTime": shippedTime == null ? null : shippedTime,
      };
}
