// @dart = 2.9
// To parse this JSON data, do
//
//     final shipperModel = shipperModelFromJson(jsonString);

import 'dart:convert';

ShipperModel shipperModelFromJson(String str) => ShipperModel.fromJson(json.decode(str));

String shipperModelToJson(ShipperModel data) => json.encode(data.toJson());

class ShipperModel {
  ShipperModel({
    this.userId,
    this.pictureUrl,
    this.fbId,
    this.isVerifiedEmail,
    this.isVerifiedPhone,
    this.isLinkedFacebook,
    this.displayName,
    this.isSsEmployee,
    this.distance,
    this.description,
    this.address,
    this.phoneNumber,
    this.shortDesc,
    this.rate,
    this.totalRates,
    this.latitude,
    this.longitude,
    this.totalOrders,
    this.updatedTime,
  });

  int userId;
  String pictureUrl;
  String fbId;
  bool isVerifiedEmail;
  bool isVerifiedPhone;
  bool isLinkedFacebook;
  String displayName;
  bool isSsEmployee;
  double distance;
  String description;
  String address;
  String phoneNumber;
  String shortDesc;
  double rate;
  int totalRates;
  double latitude;
  double longitude;
  int totalOrders;
  DateTime updatedTime;

  factory ShipperModel.fromJson(Map<String, dynamic> json) => ShipperModel(
    userId: json["UserId"] == null ? null : json["UserId"],
    pictureUrl: json["PictureUrl"] == null ? null : json["PictureUrl"],
    fbId: json["FbId"] == null ? null : json["FbId"],
    isVerifiedEmail: json["IsVerifiedEmail"] == null ? null : json["IsVerifiedEmail"],
    isVerifiedPhone: json["IsVerifiedPhone"] == null ? null : json["IsVerifiedPhone"],
    isLinkedFacebook: json["IsLinkedFacebook"] == null ? null : json["IsLinkedFacebook"],
    displayName: json["DisplayName"] == null ? null : json["DisplayName"],
    isSsEmployee: json["IsSsEmployee"] == null ? null : json["IsSsEmployee"],
    distance: json["Distance"] == null ? null : json["Distance"],
    description: json["Description"] == null ? null : json["Description"],
    address: json["Address"] == null ? null : json["Address"],
    phoneNumber: json["PhoneNumber"] == null ? null : json["PhoneNumber"],
    shortDesc: json["ShortDesc"] == null ? null : json["ShortDesc"],
    rate: json["Rate"] == null ? null : json["Rate"],
    totalRates: json["TotalRates"] == null ? null : json["TotalRates"],
    latitude: json["Latitude"] == null ? null : json["Latitude"],
    longitude: json["Longitude"] == null ? null : json["Longitude"],
    totalOrders: json["TotalOrders"] == null ? null : json["TotalOrders"],
    updatedTime: json["UpdatedTime"] == null ? null : DateTime.parse(json["UpdatedTime"]),
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId == null ? null : userId,
    "PictureUrl": pictureUrl == null ? null : pictureUrl,
    "FbId": fbId == null ? null : fbId,
    "IsVerifiedEmail": isVerifiedEmail == null ? null : isVerifiedEmail,
    "IsVerifiedPhone": isVerifiedPhone == null ? null : isVerifiedPhone,
    "IsLinkedFacebook": isLinkedFacebook == null ? null : isLinkedFacebook,
    "DisplayName": displayName == null ? null : displayName,
    "IsSsEmployee": isSsEmployee == null ? null : isSsEmployee,
    "Distance": distance == null ? null : distance,
    "Description": description == null ? null : description,
    "Address": address == null ? null : address,
    "PhoneNumber": phoneNumber == null ? null : phoneNumber,
    "ShortDesc": shortDesc == null ? null : shortDesc,
    "Rate": rate == null ? null : rate,
    "TotalRates": totalRates == null ? null : totalRates,
    "Latitude": latitude == null ? null : latitude,
    "Longitude": longitude == null ? null : longitude,
    "TotalOrders": totalOrders == null ? null : totalOrders,
    "UpdatedTime": updatedTime == null ? null : updatedTime.toIso8601String(),
  };
}
