// @dart = 2.9
// To parse this JSON data, do
//
//     final shipAreasResponse = shipAreasResponseFromJson(jsonString);

import 'dart:convert';

ShipAreasResponse shipAreasResponseFromJson(String str) => ShipAreasResponse.fromJson(json.decode(str));

String shipAreasResponseToJson(ShipAreasResponse data) => json.encode(data.toJson());

class ShipAreasResponse {
  ShipAreasResponse({
    this.appB2BConfigs,
  });

  List<AppB2BConfig> appB2BConfigs;

  factory ShipAreasResponse.fromJson(Map<String, dynamic> json) => ShipAreasResponse(
    appB2BConfigs: json["AppB2BConfigs"] == null ? null : List<AppB2BConfig>.from(json["AppB2BConfigs"].map((x) => AppB2BConfig.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "AppB2BConfigs": appB2BConfigs == null ? null : List<dynamic>.from(appB2BConfigs.map((x) => x.toJson())),
  };
}

class AppB2BConfig {
  AppB2BConfig({
    this.name,
    this.phoneNumber,
    this.email,
    this.description,
    this.pictureUrl,
    this.code,
    this.allowCalcShipFeeDistance,
    this.baseDistance,
    this.baseShipFee,
    this.extraShipFee,
    this.isRealAmount,
    this.appKey,
    this.termsAndConditions,
    this.instruction,
  });

  String name;
  String phoneNumber;
  String email;
  dynamic description;
  String pictureUrl;
  String code;
  bool allowCalcShipFeeDistance;
  double baseDistance;
  double baseShipFee;
  double extraShipFee;
  bool isRealAmount;
  String appKey;
  String termsAndConditions;
  String instruction;

  factory AppB2BConfig.fromJson(Map<String, dynamic> json) => AppB2BConfig(
    name: json["Name"] == null ? null : json["Name"],
    phoneNumber: json["PhoneNumber"] == null ? null : json["PhoneNumber"],
    email: json["Email"] == null ? null : json["Email"],
    description: json["Description"],
    pictureUrl: json["PictureUrl"] == null ? null : json["PictureUrl"],
    code: json["Code"] == null ? null : json["Code"],
    allowCalcShipFeeDistance: json["AllowCalcShipFeeDistance"] == null ? null : json["AllowCalcShipFeeDistance"],
    baseDistance: json["BaseDistance"] == null ? null : json["BaseDistance"].toDouble(),
    baseShipFee: json["BaseShipFee"] == null ? null : json["BaseShipFee"],
    extraShipFee: json["ExtraShipFee"] == null ? null : json["ExtraShipFee"],
    isRealAmount: json["IsRealAmount"] == null ? null : json["IsRealAmount"],
    appKey: json["AppKey"] == null ? null : json["AppKey"],
    termsAndConditions: json["TermsAndConditions"] == null ? null : json["TermsAndConditions"],
    instruction: json["Instruction"] == null ? null : json["Instruction"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name == null ? null : name,
    "PhoneNumber": phoneNumber == null ? null : phoneNumber,
    "Email": email == null ? null : email,
    "Description": description,
    "PictureUrl": pictureUrl == null ? null : pictureUrl,
    "Code": code == null ? null : code,
    "AllowCalcShipFeeDistance": allowCalcShipFeeDistance == null ? null : allowCalcShipFeeDistance,
    "BaseDistance": baseDistance == null ? null : baseDistance,
    "BaseShipFee": baseShipFee == null ? null : baseShipFee,
    "ExtraShipFee": extraShipFee == null ? null : extraShipFee,
    "IsRealAmount": isRealAmount == null ? null : isRealAmount,
    "AppKey": appKey == null ? null : appKey,
    "TermsAndConditions": termsAndConditions == null ? null : termsAndConditions,
    "Instruction": instruction == null ? null : instruction,
  };
}
