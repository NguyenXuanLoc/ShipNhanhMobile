// @dart = 2.9
// To parse this JSON data, do
//
//     final logoutRequest = logoutRequestFromJson(jsonString);

import 'dart:convert';

LogoutRequest logoutRequestFromJson(String str) => LogoutRequest.fromJson(json.decode(str));

String logoutRequestToJson(LogoutRequest data) => json.encode(data.toJson());

class LogoutRequest {
  LogoutRequest({
    // this.deviceType,
    // this.deviceId,
    this.authToken,
  });

  // int deviceType;
  // String deviceId;
  String authToken;

  factory LogoutRequest.fromJson(Map<String, dynamic> json) => LogoutRequest(
    // deviceType: json["DeviceType"] == null ? null : json["DeviceType"],
    // deviceId: json["DeviceId"] == null ? null : json["DeviceId"],
    authToken: json["AuthToken"] == null ? null : json["AuthToken"],
  );

  Map<String, dynamic> toJson() => {
    // "DeviceType": deviceType == null ? null : deviceType,
    // "DeviceId": deviceId == null ? null : deviceId,
    "AuthToken": authToken == null ? null : authToken,
  };
}
