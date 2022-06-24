// @dart = 2.9
import 'dart:convert';
import 'package:smartship_partner/data/model/location_model.dart';
import 'package:smartship_partner/data/network/response/login/login_response.dart';
import 'package:smartship_partner/data/network/response/user_profile/user_response.dart';

import 'person.dart';

UserInfoModel userInfoModelFromJson(String str) =>
    UserInfoModel.fromJson(json.decode(str));

String userInfoModelToJson(UserInfoModel data) => json.encode(data.toJson());

class UserInfoModel extends Person {
  double shopLat;
  double shopLng;
  String shopAddress;
  String address;
  String shopName;
  String shopPhone;
  String authToken;
  String shortDesc;
  bool allowCalcShipFeeDistance;
  double baseDistance;
  double baseShipFee;
  double extraShipFee;

  UserInfoModel({
    number,
    displayName,
    email,
    phone,
    pictureUrl,
    userId,
    totalRates,
    location,
    rate,
    this.authToken,
    this.shopLat,
    this.shopLng,
    this.shopAddress,
    this.address,
    this.shopName,
    this.shopPhone,
    this.shortDesc,
    this.allowCalcShipFeeDistance,
    this.baseDistance,
    this.baseShipFee,
    this.extraShipFee,
  }) : super(
            number: number,
            displayName: displayName,
            email: email,
            phone: phone,
            pictureUrl: pictureUrl,
            userId: userId,
            totalRates: totalRates,
            rate: rate ?? 0,
            location: location);

  /// constructor from [UserInfo]
  factory UserInfoModel.fromUserInfo(UserInfo user) {
    return UserInfoModel(
        shortDesc: user.shortDesc,
        number: user.number,
        displayName: user.name,
        email: user.email,
        phone: user.phone,
        pictureUrl: user.pictureUrl,
        userId: user.userId,
        totalRates: user.totalRates,
        location: LocationModel(lat: 0, lng: 0, address: user.workingAddress),
        shopName: user.shopAdminName,
        address: user.workingAddress,
        rate: user.rate);
  }

  /// constructor from [User]
  factory UserInfoModel.fromUser(User user) {
    return UserInfoModel(
      authToken: user.authToken,
      shortDesc: user.shortDesc,
      number: user.number,
      displayName: user.displayName,
      email: user.email,
      phone: user.phone,
      pictureUrl: user.pictureUrl,
      userId: user.userId,
      totalRates: user.totalRates,
      shopName: user.shopAdminName,
      shopPhone: user.shopAdminPhone,
      address: user.workingAddress,
      allowCalcShipFeeDistance: user.allowCalcShipFeeDistance ?? false,
      baseDistance: user.baseDistance ?? 0,
      baseShipFee: user.baseShipFee ?? 0,
      extraShipFee: user.extraShipFee ?? 0,
      rate: user.rate,
      location: LocationModel(
          lat: user.lat, lng: user.lng, address: user.workingAddress),
    );
  }

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    final person = Person.fromJson(json);
    final authToken = json['AuthToken'];

    return UserInfoModel(
        authToken: authToken,
        number: person.number,
        displayName: person.displayName,
        email: person.email,
        phone: person.phone,
        pictureUrl: person.pictureUrl,
        userId: person.userId,
        totalRates: person.totalRates,
        location: person.location,
        shopLat: json['shopLat'],
        shopLng: json['shopLng'],
        shopAddress: json['shopAddress'],
        address: json['address'],
        shopName: json['shopName'],
        shopPhone: json['shopPhone'],
        shortDesc: json['shortDesc' ?? ''],
        rate: json['Rate'] ?? 0.0,
        allowCalcShipFeeDistance: json['allowCalcShipFeeDistance'] ?? false,
        baseDistance: json['baseDistance'] ?? 0,
        baseShipFee: json['baseShipFee'] ?? 0,
        extraShipFee: json['extraShipFee'] ?? 0);
  }

  Map<String, dynamic> toJson() => {
        'AuthToken': authToken,
        'Number': number,
        'DisplayName': displayName,
        'Email': email,
        'Phone': phone,
        'PictureUrl': pictureUrl,
        'UserId': userId,
        'TotalRates': totalRates,
        'location': location.toJson(),
//        'ShortDesc': shortDesc,
        'shopLat': shopLat,
        'shopLng': shopLng,
        'shopAddress': shopAddress,
        'shopName': shopName,
        'shopPhone': shopPhone,
        'shortDesc': shortDesc,
        'allowCalcShipFeeDistance': allowCalcShipFeeDistance,
        'baseDistance': baseDistance,
        'baseShipFee': baseShipFee,
        'extraShipFee': extraShipFee,
        'Rate': rate
      };
}
