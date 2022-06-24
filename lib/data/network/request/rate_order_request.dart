// @dart = 2.9
import 'dart:convert';

RateOrderRequest loginRequestFromJson(String str) =>
    RateOrderRequest.fromJson(json.decode(str));

String loginRequestToJson(RateOrderRequest data) => json.encode(data.toJson());

class RateOrderRequest {
  RateOrderRequest({
    this.orderId,
    this.rate,
    this.feedback,
    this.authToken
  });

  int orderId;
  int rate;
  String feedback;
  String authToken;

  factory RateOrderRequest.fromJson(Map<String, dynamic> json) => RateOrderRequest(
      orderId: json['OrderId'],
      rate: json['Rate'],
      feedback: json['Feedback']);

  Map<String, dynamic> toJson() => {
    'OrderId': orderId,
    'Rate': rate,
    'Feedback': feedback ?? '',
    'AuthToken': authToken
  };
}