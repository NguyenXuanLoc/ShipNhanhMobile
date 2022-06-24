// @dart = 2.9
// To parse this JSON data, do
//
//     final registerDeviceRequest = registerDeviceRequestFromJson(jsonString);

import 'dart:convert';

RegisterDeviceRequest registerDeviceRequestFromJson(String str) => RegisterDeviceRequest.fromJson(json.decode(str));

String registerDeviceRequestToJson(RegisterDeviceRequest data) => json.encode(data.toJson());

class RegisterDeviceRequest {
  RegisterDeviceRequest({
    this.deviceType,
    this.deviceId,
    this.oldDeviceId,
    this.authToken,
  });

  int deviceType;
  String deviceId;
  String oldDeviceId;
  String authToken;

  factory RegisterDeviceRequest.fromJson(Map<String, dynamic> json) => RegisterDeviceRequest(
    deviceType: json["DeviceType"] == null ? null : json["DeviceType"],
    deviceId: json["DeviceId"] == null ? null : json["DeviceId"],
    oldDeviceId: json["OldDeviceId"] == null ? null : json["OldDeviceId"],
    authToken: json["AuthToken"] == null ? null : json["AuthToken"],
  );

  Map<String, dynamic> toJson() => {
    "DeviceType": deviceType == null ? null : deviceType,
    "DeviceId": deviceId == null ? null : deviceId,
    "OldDeviceId": oldDeviceId == null ? null : oldDeviceId,
    "AuthToken": authToken == null ? null : authToken,
  };
}
