// @dart = 2.9
// To parse this JSON data, do
//
//     final userProfileData = userProfileDataFromJson(jsonString);

import 'dart:convert';

UserProfileData userProfileDataFromJson(String str) => UserProfileData.fromJson(json.decode(str));

String userProfileDataToJson(UserProfileData data) => json.encode(data.toJson());

class UserProfileData {
  UserProfileData({
    this.newProfile,
  });

  NewProfile newProfile;

  factory UserProfileData.fromJson(Map<String, dynamic> json) => UserProfileData(
    newProfile: json['NewProfile'] == null ? null : NewProfile.fromJson(json['NewProfile']),
  );

  Map<String, dynamic> toJson() => {
    'NewProfile': newProfile == null ? null : newProfile.toJson(),
  };
}

class NewProfile {
  NewProfile({
    this.userId,
    this.displayName,
    this.email,
    this.phone,
    this.description,
    this.onlineTime,
    this.offlineTime,
    this.workingAddress,
    this.pictureUrl,
    this.shortDesc,
    this.isVerifiedEmail,
    this.isVerifiedPhone,
    this.isLinkedFacebook,
    this.isLinkedEmail,
    this.isInGroup,
    this.faceName,
    this.webUrl,
    this.colorCode,
    this.shipFee,
    this.hasAvatar,
  });

  int userId;
  String displayName;
  String email;
  String phone;
  String description;
  String onlineTime;
  String offlineTime;
  String workingAddress;
  String pictureUrl;
  String shortDesc;
  bool isVerifiedEmail;
  bool isVerifiedPhone;
  bool isLinkedFacebook;
  bool isLinkedEmail;
  bool isInGroup;
  String faceName;
  String webUrl;
  String colorCode;
  int shipFee;
  bool hasAvatar;

  factory NewProfile.fromJson(Map<String, dynamic> json) => NewProfile(
    userId: json['UserId'],
    displayName: json['DisplayName'],
    email: json['Email'],
    phone: json['Phone'],
    description: json['Description'],
    onlineTime: json['OnlineTime'],
    offlineTime: json['OfflineTime'],
    workingAddress: json['WorkingAddress'],
    pictureUrl: json['PictureUrl'],
    shortDesc: json['ShortDesc'],
    isVerifiedEmail: json['IsVerifiedEmail'],
    isVerifiedPhone: json['IsVerifiedPhone'],
    isLinkedFacebook: json['IsLinkedFacebook'],
    isLinkedEmail: json['IsLinkedEmail'],
    isInGroup: json['IsInGroup'],
    faceName: json['FaceName'],
    webUrl: json['WebUrl'],
    colorCode: json['ColorCode'],
    shipFee: json['ShipFee'],
    hasAvatar: json['HasAvatar'],
  );

  Map<String, dynamic> toJson() => {
    'UserId': userId,
    'DisplayName': displayName,
    'Email': email,
    'Phone': phone,
    'Description': description,
    'OnlineTime': onlineTime,
    'OfflineTime': offlineTime,
    'WorkingAddress': workingAddress,
    'PictureUrl': pictureUrl,
    'ShortDesc': shortDesc,
    'IsVerifiedEmail': isVerifiedEmail,
    'IsVerifiedPhone': isVerifiedPhone,
    'IsLinkedFacebook': isLinkedFacebook,
    'IsLinkedEmail': isLinkedEmail,
    'IsInGroup': isInGroup,
    'FaceName': faceName,
    'WebUrl': webUrl,
    'ColorCode': colorCode,
    'ShipFee': shipFee,
    'HasAvatar': hasAvatar,
  };
}
