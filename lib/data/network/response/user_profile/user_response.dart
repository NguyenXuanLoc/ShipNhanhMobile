// @dart = 2.9
// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  UserResponse({
    this.userInfo,
    this.totalRecords,
  });

  UserInfo userInfo;
  int totalRecords;

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    userInfo: json["UserInfo"] == null ? null : UserInfo.fromJson(json["UserInfo"]),
    totalRecords: json["TotalRecords"] == null ? null : json["TotalRecords"],
  );

  Map<String, dynamic> toJson() => {
    "UserInfo": userInfo == null ? null : userInfo.toJson(),
    "TotalRecords": totalRecords == null ? null : totalRecords,
  };
}

class UserInfo {
  UserInfo({
    this.userId,
    this.shipperType,
    this.name,
    this.number,
    this.pictureUrl,
    this.phone,
    this.email,
    this.description,
    this.userType,
    this.totalOrders,
    this.rateHistories,
    this.totalRates,
    this.rate,
    this.isVerifiedEmail,
    this.isVerifiedPhone,
    this.isLinkedFacebook,
    this.facebookLink,
    this.shortDesc,
    this.workingAddress,
    this.isInGroup,
    this.isAdministrator,
    this.adminRole,
    this.shipAdminName,
    this.shipAdminPic,
    this.shipAdminId,
    this.shopAdminName,
    this.shopAdminPic,
    this.shopAdminId,
    this.fullName,
    this.preferLanguage,
    this.webUrl,
    this.colorCode,
    this.shipFee,
  });

  int userId;
  int shipperType;
  String name;
  String number;
  String pictureUrl;
  String phone;
  String email;
  String description;
  int userType;
  int totalOrders;
  List<RateHistory> rateHistories;
  int totalRates;
  double rate;
  bool isVerifiedEmail;
  bool isVerifiedPhone;
  bool isLinkedFacebook;
  String facebookLink;
  String shortDesc;
  String workingAddress;
  bool isInGroup;
  bool isAdministrator;
  int adminRole;
  String shipAdminName;
  String shipAdminPic;
  int shipAdminId;
  String shopAdminName;
  String shopAdminPic;
  int shopAdminId;
  String fullName;
  String preferLanguage;
  String webUrl;
  String colorCode;
  double shipFee;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    userId: json["UserId"] == null ? null : json["UserId"],
    shipperType: json["ShipperType"] == null ? null : json["ShipperType"],
    name: json["Name"] == null ? null : json["Name"],
    number: json["Number"] == null ? null : json["Number"],
    pictureUrl: json["PictureUrl"] == null ? null : json["PictureUrl"],
    phone: json["Phone"] == null ? null : json["Phone"],
    email: json["Email"] == null ? null : json["Email"],
    description: json["Description"] == null ? null : json["Description"],
    userType: json["UserType"] == null ? null : json["UserType"],
    totalOrders: json["TotalOrders"] == null ? null : json["TotalOrders"],
    rateHistories: json["RateHistories"] == null ? null : List<RateHistory>.from(json["RateHistories"].map((x) => RateHistory.fromJson(x))),
    totalRates: json["TotalRates"] == null ? null : json["TotalRates"],
    rate: json["Rate"] == null ? null : json["Rate"].toDouble(),
    isVerifiedEmail: json["IsVerifiedEmail"] == null ? null : json["IsVerifiedEmail"],
    isVerifiedPhone: json["IsVerifiedPhone"] == null ? null : json["IsVerifiedPhone"],
    isLinkedFacebook: json["IsLinkedFacebook"] == null ? null : json["IsLinkedFacebook"],
    facebookLink: json["FacebookLink"] == null ? null : json["FacebookLink"],
    shortDesc: json["ShortDesc"] == null ? null : json["ShortDesc"],
    workingAddress: json["WorkingAddress"] == null ? null : json["WorkingAddress"],
    isInGroup: json["IsInGroup"] == null ? null : json["IsInGroup"],
    isAdministrator: json["IsAdministrator"] == null ? null : json["IsAdministrator"],
    adminRole: json["AdminRole"] == null ? null : json["AdminRole"],
    shipAdminName: json["ShipAdminName"] == null ? null : json["ShipAdminName"],
    shipAdminPic: json["ShipAdminPic"] == null ? null : json["ShipAdminPic"],
    shipAdminId: json["ShipAdminId"] == null ? null : json["ShipAdminId"],
    shopAdminName: json["ShopAdminName"] == null ? null : json["ShopAdminName"],
    shopAdminPic: json["ShopAdminPic"] == null ? null : json["ShopAdminPic"],
    shopAdminId: json["ShopAdminId"] == null ? null : json["ShopAdminId"],
    fullName: json["FullName"] == null ? null : json["FullName"],
    preferLanguage: json["PreferLanguage"] == null ? null : json["PreferLanguage"],
    webUrl: json["WebUrl"] == null ? null : json["WebUrl"],
    colorCode: json["ColorCode"] == null ? null : json["ColorCode"],
    shipFee: json["ShipFee"] == null ? null : json["ShipFee"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId == null ? null : userId,
    "ShipperType": shipperType == null ? null : shipperType,
    "Name": name == null ? null : name,
    "Number": number == null ? null : number,
    "PictureUrl": pictureUrl == null ? null : pictureUrl,
    "Phone": phone == null ? null : phone,
    "Email": email == null ? null : email,
    "Description": description == null ? null : description,
    "UserType": userType == null ? null : userType,
    "TotalOrders": totalOrders == null ? null : totalOrders,
    "RateHistories": rateHistories == null ? null : List<dynamic>.from(rateHistories.map((x) => x.toJson())),
    "TotalRates": totalRates == null ? null : totalRates,
    "Rate": rate == null ? null : rate,
    "IsVerifiedEmail": isVerifiedEmail == null ? null : isVerifiedEmail,
    "IsVerifiedPhone": isVerifiedPhone == null ? null : isVerifiedPhone,
    "IsLinkedFacebook": isLinkedFacebook == null ? null : isLinkedFacebook,
    "FacebookLink": facebookLink == null ? null : facebookLink,
    "ShortDesc": shortDesc == null ? null : shortDesc,
    "WorkingAddress": workingAddress == null ? null : workingAddress,
    "IsInGroup": isInGroup == null ? null : isInGroup,
    "IsAdministrator": isAdministrator == null ? null : isAdministrator,
    "AdminRole": adminRole == null ? null : adminRole,
    "ShipAdminName": shipAdminName == null ? null : shipAdminName,
    "ShipAdminPic": shipAdminPic == null ? null : shipAdminPic,
    "ShipAdminId": shipAdminId == null ? null : shipAdminId,
    "ShopAdminName": shopAdminName == null ? null : shopAdminName,
    "ShopAdminPic": shopAdminPic == null ? null : shopAdminPic,
    "ShopAdminId": shopAdminId == null ? null : shopAdminId,
    "FullName": fullName == null ? null : fullName,
    "PreferLanguage": preferLanguage == null ? null : preferLanguage,
    "WebUrl": webUrl == null ? null : webUrl,
    "ColorCode": colorCode == null ? null : colorCode,
    "ShipFee": shipFee == null ? null : shipFee,
  };
}

class RateHistory {
  RateHistory({
    this.rate,
    this.userId,
    this.createdDate,
    this.name,
    this.phone,
    this.email,
    this.pictureUrl,
    this.feedback,
  });

  int rate;
  int userId;
  String createdDate;
  String name;
  String phone;
  String email;
  String pictureUrl;
  String feedback;

  factory RateHistory.fromJson(Map<String, dynamic> json) => RateHistory(
    rate: json["Rate"] == null ? null : json["Rate"],
    userId: json["UserId"] == null ? null : json["UserId"],
    createdDate: json["CreatedDate"] == null ? null : json["CreatedDate"],
    name: json["Name"] == null ? null : json["Name"],
    phone: json["Phone"] == null ? null : json["Phone"],
    email: json["Email"] == null ? null : json["Email"],
    pictureUrl: json["PictureUrl"] == null ? null : json["PictureUrl"],
    feedback: json["Feedback"] == null ? null : json["Feedback"],
  );

  Map<String, dynamic> toJson() => {
    "Rate": rate == null ? null : rate,
    "UserId": userId == null ? null : userId,
    "CreatedDate": createdDate == null ? null : createdDate,
    "Name": name == null ? null : name,
    "Phone": phone == null ? null : phone,
    "Email": email == null ? null : email,
    "PictureUrl": pictureUrl == null ? null : pictureUrl,
    "Feedback": feedback == null ? null : feedback,
  };
}
