// @dart = 2.9
import 'dart:convert';

NoteListData noteListDataFromJson(String str) => NoteListData.fromJson(json.decode(str));

String noteListDataToJson(NoteListData data) => json.encode(data.toJson());

class NoteListData {
  NoteListData({
    this.orderLogs,
  });

  List<OrderLog> orderLogs;

  factory NoteListData.fromJson(Map<String, dynamic> json) => NoteListData(
    orderLogs: List<OrderLog>.from(json["OrderLogs"].map((x) => OrderLog.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "OrderLogs": List<dynamic>.from(orderLogs.map((x) => x.toJson())),
  };
}

class OrderLog {
  OrderLog({
    this.oldAmount,
    this.newAmount,
    this.notes,
    this.orderId,
    this.creatorId,
    this.creatorName,
    this.createdOn,
    this.orderLogType,
    this.subLogType,
    this.userRole,
  });

  double oldAmount;
  double newAmount;
  String notes;
  int orderId;
  int creatorId;
  String creatorName;
  DateTime createdOn;
  int orderLogType;
  int subLogType;
  int userRole;

  factory OrderLog.fromJson(Map<String, dynamic> json) => OrderLog(
    oldAmount: json["OldAmount"],
    newAmount: json["NewAmount"],
    notes: json["Notes"],
    orderId: json["OrderId"],
    creatorId: json["CreatorId"],
    creatorName: json["CreatorName"],
    createdOn: DateTime.parse(json["CreatedOn"]),
    orderLogType: json["OrderLogType"],
    subLogType: json["SubLogType"],
    userRole: json["UserRole"],
  );

  Map<String, dynamic> toJson() => {
    "OldAmount": oldAmount,
    "NewAmount": newAmount,
    "Notes": notes,
    "OrderId": orderId,
    "CreatorId": creatorId,
    "CreatorName": creatorName,
    "CreatedOn": createdOn.toIso8601String(),
    "OrderLogType": orderLogType,
    "SubLogType": subLogType,
    "UserRole": userRole,
  };
}