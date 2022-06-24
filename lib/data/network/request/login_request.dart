// @dart = 2.9
// To parse this JSON data, do
//
//     final loginRequest = loginRequestFromJson(jsonString);

import 'dart:convert';

LoginRequest loginRequestFromJson(String str) =>
    LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  LoginRequest({
    this.uId,
    this.phoneNumber,
    this.userType,
  });

  String uId;
  String phoneNumber;
  String authToken;
  int userType;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
      uId: json['UId'],
      phoneNumber: json['PhoneNumber'],
      userType: json['UserType ']);

  Map<String, dynamic> toJson() => {
        'UId': uId,
        'PhoneNumber': phoneNumber,
        'UserType ': userType,
      };
}
