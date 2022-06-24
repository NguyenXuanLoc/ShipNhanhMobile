// @dart = 2.9
import 'dart:convert';

CancelOrderRequest loginRequestFromJson(String str) =>
    CancelOrderRequest.fromJson(json.decode(str));

String loginRequestToJson(CancelOrderRequest data) =>
    json.encode(data.toJson());

class CancelOrderRequest {
  CancelOrderRequest({this.orderId, this.reason, this.authToken});

  int orderId;
  String reason;
  String authToken;

  factory CancelOrderRequest.fromJson(Map<String, dynamic> json) =>
      CancelOrderRequest(
          orderId: json['OrderId'],
          reason: json['Reason'],
          authToken: json['AuthToken']);

  Map<String, dynamic> toJson() =>
      {'OrderId': orderId, 'Feedback': reason ?? '', 'AuthToken': authToken};
}
