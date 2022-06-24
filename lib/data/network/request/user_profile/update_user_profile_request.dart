// @dart = 2.9
// To parse this JSON data, do
//
//     final updateUserRequest = updateUserRequestFromJson(jsonString);

import 'dart:convert';

UpdateUserRequest updateUserRequestFromJson(String str) => UpdateUserRequest.fromJson(json.decode(str));

String updateUserRequestToJson(UpdateUserRequest data) => json.encode(data.toJson());

class UpdateUserRequest {
  UpdateUserRequest({
    this.newProfile,
    this.authToken,
  });

  NewProfile newProfile;
  String authToken;

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => UpdateUserRequest(
    newProfile: json["NewProfile"] == null ? null : NewProfile.fromJson(json["NewProfile"]),
    authToken: json["AuthToken"] == null ? null : json["AuthToken"],
  );

  Map<String, dynamic> toJson() => {
    "NewProfile": newProfile == null ? null : newProfile.toJson(),
    "AuthToken": authToken == null ? null : authToken,
  };
}

class NewProfile {
  NewProfile({
    this.userId,
    this.displayName,
    this.email,
    this.phone,
    this.description,
    this.shortDesc,
  });

  int userId;
  String displayName;
  String email;
  String phone;
  String description;
  String shortDesc;

  factory NewProfile.fromJson(Map<String, dynamic> json) => NewProfile(
    userId: json["UserId"] == null ? null : json["UserId"],
    displayName: json["DisplayName"] == null ? null : json["DisplayName"],
    email: json["Email"] == null ? null : json["Email"],
    phone: json["Phone"] == null ? null : json["Phone"],
    description: json["Description"] == null ? null : json["Description"],
    shortDesc: json["ShortDesc"] == null ? null : json["ShortDesc"],
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId == null ? null : userId,
    "DisplayName": displayName == null ? null : displayName,
    "Email": email == null ? null : email,
    "Phone": phone == null ? null : phone,
    "Description": description == null ? null : description,
    "ShortDesc": shortDesc == null ? null : shortDesc,
  };
}
