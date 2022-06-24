// @dart = 2.9
// To parse this JSON data, do
//
//     final loginData = loginDataFromJson(jsonString);

import 'dart:convert';

LoginData loginDataFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginDataToJson(LoginData data) => json.encode(data.toJson());

class LoginData {
  LoginData({
    this.user,
    this.isFirstLogin,
    this.isMissingUserInfo,
    this.notifications,
    this.accounts,
  });

  User user;
  bool isFirstLogin;
  bool isMissingUserInfo;
  List<Notification> notifications;
  List<Account> accounts;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    user: json["User"] == null ? null : User.fromJson(json["User"]),
    isFirstLogin: json["IsFirstLogin"] == null ? null : json["IsFirstLogin"],
    isMissingUserInfo: json["IsMissingUserInfo"] == null ? null : json["IsMissingUserInfo"],
    notifications: json["Notifications"] == null ? null : List<Notification>.from(json["Notifications"].map((x) => Notification.fromJson(x))),
    accounts: json["Accounts"] == null ? null : List<Account>.from(json["Accounts"].map((x) => Account.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "User": user == null ? null : user.toJson(),
    "IsFirstLogin": isFirstLogin == null ? null : isFirstLogin,
    "IsMissingUserInfo": isMissingUserInfo == null ? null : isMissingUserInfo,
    "Notifications": notifications == null ? null : List<dynamic>.from(notifications.map((x) => x.toJson())),
    "Accounts": accounts == null ? null : List<dynamic>.from(accounts.map((x) => x.toJson())),
  };
}

class Account {
  Account({
    this.epartnerType,
    this.loginUrl,
    this.authToken,
    this.isRegister,
  });

  int epartnerType;
  String loginUrl;
  String authToken;
  bool isRegister;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    epartnerType: json["EpartnerType"] == null ? null : json["EpartnerType"],
    loginUrl: json["LoginUrl"] == null ? null : json["LoginUrl"],
    authToken: json["AuthToken"] == null ? null : json["AuthToken"],
    isRegister: json["IsRegister"] == null ? null : json["IsRegister"],
  );

  Map<String, dynamic> toJson() => {
    "EpartnerType": epartnerType == null ? null : epartnerType,
    "LoginUrl": loginUrl == null ? null : loginUrl,
    "AuthToken": authToken == null ? null : authToken,
    "IsRegister": isRegister == null ? null : isRegister,
  };
}

class Notification {
  Notification({
    this.message,
    this.messageType,
    this.orderId,
    this.createdDate,
  });

  String message;
  int messageType;
  int orderId;
  DateTime createdDate;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    message: json["Message"] == null ? null : json["Message"],
    messageType: json["MessageType"] == null ? null : json["MessageType"],
    orderId: json["OrderId"] == null ? null : json["OrderId"],
    createdDate: json["CreatedDate"] == null ? null : DateTime.parse(json["CreatedDate"]),
  );

  Map<String, dynamic> toJson() => {
    "Message": message == null ? null : message,
    "MessageType": messageType == null ? null : messageType,
    "OrderId": orderId == null ? null : orderId,
    "CreatedDate": createdDate == null ? null : createdDate.toIso8601String(),
  };
}

class User {
  User({
    this.authToken,
    this.number,
    this.displayName,
    this.email,
    this.phone,
    this.rate,
    this.userType,
    this.shipperType,
    this.onlineTime,
    this.offlineTime,
    this.workingAddress,
    this.workAddress,
    this.pictureUrl,
    this.userId,
    this.totalRates,
    this.totalOrders,
    this.description,
    this.isAdministrator,
    this.adminRole,
    this.creditUnit,
    this.vndUnit,
    this.isMissigInfo,
    this.isVerifiedEmail,
    this.isVerifiedPhone,
    this.isLinkedFacebook,
    this.isLinkedEmail,
    this.isInGroup,
    this.faceName,
    this.shortDesc,
    this.shipAdminName,
    this.shipAdminPhone,
    this.shipAdminPic,
    this.shipAdminId,
    this.shopAdminName,
    this.shopAdminPhone,
    this.shopAdminPic,
    this.shopAdminId,
    this.credit,
    this.lastChangeCredit,
    this.eventCode,
    this.canChargeEventCode,
    this.supportedBanks,
    this.supportedBudgets,
    this.fbGroups,
    this.fbGroupPairs,
    this.fbBlockUsers,
    this.cancelReasons,
    this.versionCodeNo,
    this.hotLine,
    this.supportId,
    this.accounts,
    this.preferLanguage,
    this.isPrivateGroup,
    this.lat,
    this.lng,
    this.shopAdminFee,
    this.shipFee,
    this.isRealAmount,
    this.showNewOrder,
    this.whAddress,
    this.whLat,
    this.whLng,
    this.shopNotes,
    this.supportShipperId,
    this.supportShipperName,
    this.supportShipperPhone,
    this.allowShipperCreateOrder,
    this.allowWarehouseStatus,
    this.paidUser,
    this.purchasedDate,
    this.expiredPaidUserDate,
    this.allowCalcShipFeeDistance,
    this.baseDistance,
    this.baseShipFee,
    this.extraShipFee,
    this.termCondition,
    this.guideUrl
  });

  String authToken;
  String number;
  String displayName;
  String email;
  String phone;
  double rate;
  int userType;
  int shipperType;
  String onlineTime;
  String offlineTime;
  String workingAddress;
  String workAddress;
  String pictureUrl;
  int userId;
  int totalRates;
  int totalOrders;
  String description;
  bool isAdministrator;
  int adminRole;
  double creditUnit;
  double vndUnit;
  bool isMissigInfo;
  bool isVerifiedEmail;
  bool isVerifiedPhone;
  bool isLinkedFacebook;
  bool isLinkedEmail;
  bool isInGroup;
  String faceName;
  String shortDesc;
  String shipAdminName;
  String shipAdminPhone;
  String shipAdminPic;
  int shipAdminId;
  String shopAdminName;
  String shopAdminPhone;
  String shopAdminPic;
  int shopAdminId;
  double credit;
  DateTime lastChangeCredit;
  String eventCode;
  bool canChargeEventCode;
  List<dynamic> supportedBanks;
  List<dynamic> supportedBudgets;
  List<dynamic> fbGroups;
  List<dynamic> fbGroupPairs;
  List<dynamic> fbBlockUsers;
  List<String> cancelReasons;
  int versionCodeNo;
  String hotLine;
  String supportId;
  List<Account> accounts;
  String preferLanguage;
  bool isPrivateGroup;
  double lat;
  double lng;
  double shopAdminFee;
  double shipFee;
  bool isRealAmount;
  bool showNewOrder;
  String whAddress;
  double whLat;
  double whLng;
  String shopNotes;
  int supportShipperId;
  String supportShipperName;
  String supportShipperPhone;
  bool allowShipperCreateOrder;
  bool allowWarehouseStatus;
  int paidUser;
  DateTime purchasedDate;
  DateTime expiredPaidUserDate;
  bool allowCalcShipFeeDistance;
  double baseDistance;
  double baseShipFee;
  double extraShipFee;
  String termCondition;
  String guideUrl;

  factory User.fromJson(Map<String, dynamic> json) => User(
    authToken: json["AuthToken"] == null ? null : json["AuthToken"],
    number: json["Number"] == null ? null : json["Number"],
    displayName: json["DisplayName"] == null ? null : json["DisplayName"],
    email: json["Email"] == null ? null : json["Email"],
    phone: json["Phone"] == null ? null : json["Phone"],
    rate: json["Rate"] == null ? null : json["Rate"].toDouble(),
    userType: json["UserType"] == null ? null : json["UserType"],
    shipperType: json["ShipperType"] == null ? null : json["ShipperType"],
    onlineTime: json["OnlineTime"] == null ? null : json["OnlineTime"],
    offlineTime: json["OfflineTime"] == null ? null : json["OfflineTime"],
    workingAddress: json["WorkingAddress"] == null ? null : json["WorkingAddress"],
    workAddress: json["WorkAddress"] == null ? null : json["WorkAddress"],
    pictureUrl: json["PictureUrl"] == null ? null : json["PictureUrl"],
    userId: json["UserId"] == null ? null : json["UserId"],
    totalRates: json["TotalRates"] == null ? null : json["TotalRates"],
    totalOrders: json["TotalOrders"] == null ? null : json["TotalOrders"],
    description: json["Description"] == null ? null : json["Description"],
    isAdministrator: json["IsAdministrator"] == null ? null : json["IsAdministrator"],
    adminRole: json["AdminRole"] == null ? null : json["AdminRole"],
    creditUnit: json["CreditUnit"] == null ? null : json["CreditUnit"].toDouble(),
    vndUnit: json["VndUnit"] == null ? null : json["VndUnit"].toDouble(),
    isMissigInfo: json["IsMissigInfo"] == null ? null : json["IsMissigInfo"],
    isVerifiedEmail: json["IsVerifiedEmail"] == null ? null : json["IsVerifiedEmail"],
    isVerifiedPhone: json["IsVerifiedPhone"] == null ? null : json["IsVerifiedPhone"],
    isLinkedFacebook: json["IsLinkedFacebook"] == null ? null : json["IsLinkedFacebook"],
    isLinkedEmail: json["IsLinkedEmail"] == null ? null : json["IsLinkedEmail"],
    isInGroup: json["IsInGroup"] == null ? null : json["IsInGroup"],
    faceName: json["FaceName"] == null ? null : json["FaceName"],
    shortDesc: json["ShortDesc"] == null ? null : json["ShortDesc"],
    shipAdminName: json["ShipAdminName"] == null ? null : json["ShipAdminName"],
    shipAdminPhone: json["ShipAdminPhone"] == null ? null : json["ShipAdminPhone"],
    shipAdminPic: json["ShipAdminPic"] == null ? null : json["ShipAdminPic"],
    shipAdminId: json["ShipAdminId"] == null ? null : json["ShipAdminId"],
    shopAdminName: json["ShopAdminName"] == null ? null : json["ShopAdminName"],
    shopAdminPhone: json["ShopAdminPhone"] == null ? null : json["ShopAdminPhone"],
    shopAdminPic: json["ShopAdminPic"] == null ? null : json["ShopAdminPic"],
    shopAdminId: json["ShopAdminId"] == null ? null : json["ShopAdminId"],
    credit: json["Credit"] == null ? null : json["Credit"].toDouble(),
    lastChangeCredit: json["LastChangeCredit"] == null ? null : DateTime.parse(json["LastChangeCredit"]),
    eventCode: json["EventCode"] == null ? null : json["EventCode"],
    canChargeEventCode: json["CanChargeEventCode"] == null ? null : json["CanChargeEventCode"],
    supportedBanks: json["SupportedBanks"] == null ? null : List<dynamic>.from(json["SupportedBanks"].map((x) => x)),
    supportedBudgets: json["SupportedBudgets"] == null ? null : List<dynamic>.from(json["SupportedBudgets"].map((x) => x)),
    fbGroups: json["FbGroups"] == null ? null : List<dynamic>.from(json["FbGroups"].map((x) => x)),
    fbGroupPairs: json["FbGroupPairs"] == null ? null : List<dynamic>.from(json["FbGroupPairs"].map((x) => x)),
    fbBlockUsers: json["FbBlockUsers"] == null ? null : List<dynamic>.from(json["FbBlockUsers"].map((x) => x)),
    cancelReasons: json["CancelReasons"] == null ? null : List<String>.from(json["CancelReasons"].map((x) => x)),
    versionCodeNo: json["VersionCodeNo"] == null ? null : json["VersionCodeNo"],
    hotLine: json["HotLine"] == null ? null : json["HotLine"],
    supportId: json["SupportId"] == null ? null : json["SupportId"],
    accounts: json["Accounts"] == null ? null : List<Account>.from(json["Accounts"].map((x) => Account.fromJson(x))),
    preferLanguage: json["PreferLanguage"] == null ? null : json["PreferLanguage"],
    isPrivateGroup: json["IsPrivateGroup"] == null ? null : json["IsPrivateGroup"],
    lat: json["Lat"] == null ? null : json["Lat"].toDouble(),
    lng: json["Lng"] == null ? null : json["Lng"].toDouble(),
    shopAdminFee: json["ShopAdminFee"] == null ? null : json["ShopAdminFee"].toDouble(),
    shipFee: json["ShipFee"] == null ? null : json["ShipFee"].toDouble(),
    isRealAmount: json["IsRealAmount"] == null ? null : json["IsRealAmount"],
    showNewOrder: json["ShowNewOrder"] == null ? null : json["ShowNewOrder"],
    whAddress: json["WhAddress"] == null ? null : json["WhAddress"],
    whLat: json["WhLat"] == null ? null : json["WhLat"].toDouble(),
    whLng: json["WhLng"] == null ? null : json["WhLng"].toDouble(),
    shopNotes: json["ShopNotes"] == null ? null : json["ShopNotes"],
    supportShipperId: json["SupportShipperId"] == null ? null : json["SupportShipperId"],
    supportShipperName: json["SupportShipperName"] == null ? null : json["SupportShipperName"],
    supportShipperPhone: json["SupportShipperPhone"] == null ? null : json["SupportShipperPhone"],
    allowShipperCreateOrder: json["AllowShipperCreateOrder"] == null ? null : json["AllowShipperCreateOrder"],
    allowWarehouseStatus: json["AllowWarehouseStatus"] == null ? null : json["AllowWarehouseStatus"],
    paidUser: json["PaidUser"] == null ? null : json["PaidUser"],
    purchasedDate: json["PurchasedDate"] == null ? null : DateTime.parse(json["PurchasedDate"]),
    expiredPaidUserDate: json["ExpiredPaidUserDate"] == null ? null : DateTime.parse(json["ExpiredPaidUserDate"]),
    allowCalcShipFeeDistance: json["AllowCalcShipFeeDistance"] == null ? null : json["AllowCalcShipFeeDistance"],
    baseDistance: json["BaseDistance"] == null ? null : json["BaseDistance"],
    baseShipFee: json["BaseShipFee"] == null ? null : json["BaseShipFee"],
    extraShipFee: json["ExtraShipFee"] == null ? null : json["ExtraShipFee"],
    termCondition:  json["TermConditionUrl"] == null ? null : json["TermConditionUrl"],
    guideUrl: json["GuideUrl"] == null ? null : json["GuideUrl"],
  );

  Map<String, dynamic> toJson() => {
    "AuthToken": authToken == null ? null : authToken,
    "Number": number == null ? null : number,
    "DisplayName": displayName == null ? null : displayName,
    "Email": email == null ? null : email,
    "Phone": phone == null ? null : phone,
    "Rate": rate == null ? null : rate,
    "UserType": userType == null ? null : userType,
    "ShipperType": shipperType == null ? null : shipperType,
    "OnlineTime": onlineTime == null ? null : onlineTime,
    "OfflineTime": offlineTime == null ? null : offlineTime,
    "WorkingAddress": workingAddress == null ? null : workingAddress,
    "WorkAddress": workAddress == null ? null : workAddress,
    "PictureUrl": pictureUrl == null ? null : pictureUrl,
    "UserId": userId == null ? null : userId,
    "TotalRates": totalRates == null ? null : totalRates,
    "TotalOrders": totalOrders == null ? null : totalOrders,
    "Description": description == null ? null : description,
    "IsAdministrator": isAdministrator == null ? null : isAdministrator,
    "AdminRole": adminRole == null ? null : adminRole,
    "CreditUnit": creditUnit == null ? null : creditUnit,
    "VndUnit": vndUnit == null ? null : vndUnit,
    "IsMissigInfo": isMissigInfo == null ? null : isMissigInfo,
    "IsVerifiedEmail": isVerifiedEmail == null ? null : isVerifiedEmail,
    "IsVerifiedPhone": isVerifiedPhone == null ? null : isVerifiedPhone,
    "IsLinkedFacebook": isLinkedFacebook == null ? null : isLinkedFacebook,
    "IsLinkedEmail": isLinkedEmail == null ? null : isLinkedEmail,
    "IsInGroup": isInGroup == null ? null : isInGroup,
    "FaceName": faceName == null ? null : faceName,
    "ShortDesc": shortDesc == null ? null : shortDesc,
    "ShipAdminName": shipAdminName == null ? null : shipAdminName,
    "ShipAdminPhone": shipAdminPhone == null ? null : shipAdminPhone,
    "ShipAdminPic": shipAdminPic == null ? null : shipAdminPic,
    "ShipAdminId": shipAdminId == null ? null : shipAdminId,
    "ShopAdminName": shopAdminName == null ? null : shopAdminName,
    "ShopAdminPhone": shopAdminPhone == null ? null : shopAdminPhone,
    "ShopAdminPic": shopAdminPic == null ? null : shopAdminPic,
    "ShopAdminId": shopAdminId == null ? null : shopAdminId,
    "Credit": credit == null ? null : credit,
    "LastChangeCredit": lastChangeCredit == null ? null : lastChangeCredit.toIso8601String(),
    "EventCode": eventCode == null ? null : eventCode,
    "CanChargeEventCode": canChargeEventCode == null ? null : canChargeEventCode,
    "SupportedBanks": supportedBanks == null ? null : List<dynamic>.from(supportedBanks.map((x) => x)),
    "SupportedBudgets": supportedBudgets == null ? null : List<dynamic>.from(supportedBudgets.map((x) => x)),
    "FbGroups": fbGroups == null ? null : List<dynamic>.from(fbGroups.map((x) => x)),
    "FbGroupPairs": fbGroupPairs == null ? null : List<dynamic>.from(fbGroupPairs.map((x) => x)),
    "FbBlockUsers": fbBlockUsers == null ? null : List<dynamic>.from(fbBlockUsers.map((x) => x)),
    "CancelReasons": cancelReasons == null ? null : List<dynamic>.from(cancelReasons.map((x) => x)),
    "VersionCodeNo": versionCodeNo == null ? null : versionCodeNo,
    "HotLine": hotLine == null ? null : hotLine,
    "SupportId": supportId == null ? null : supportId,
    "Accounts": accounts == null ? null : List<dynamic>.from(accounts.map((x) => x.toJson())),
    "PreferLanguage": preferLanguage == null ? null : preferLanguage,
    "IsPrivateGroup": isPrivateGroup == null ? null : isPrivateGroup,
    "Lat": lat == null ? null : lat,
    "Lng": lng == null ? null : lng,
    "ShopAdminFee": shopAdminFee == null ? null : shopAdminFee,
    "ShipFee": shipFee == null ? null : shipFee,
    "IsRealAmount": isRealAmount == null ? null : isRealAmount,
    "ShowNewOrder": showNewOrder == null ? null : showNewOrder,
    "WhAddress": whAddress == null ? null : whAddress,
    "WhLat": whLat == null ? null : whLat,
    "WhLng": whLng == null ? null : whLng,
    "ShopNotes": shopNotes == null ? null : shopNotes,
    "SupportShipperId": supportShipperId == null ? null : supportShipperId,
    "SupportShipperName": supportShipperName == null ? null : supportShipperName,
    "SupportShipperPhone": supportShipperPhone == null ? null : supportShipperPhone,
    "AllowShipperCreateOrder": allowShipperCreateOrder == null ? null : allowShipperCreateOrder,
    "AllowWarehouseStatus": allowWarehouseStatus == null ? null : allowWarehouseStatus,
    "PaidUser": paidUser == null ? null : paidUser,
    "PurchasedDate": purchasedDate == null ? null : purchasedDate.toIso8601String(),
    "ExpiredPaidUserDate": expiredPaidUserDate == null ? null : expiredPaidUserDate.toIso8601String(),
    "AllowCalcShipFeeDistance": allowCalcShipFeeDistance == null ? null : allowCalcShipFeeDistance,
    "BaseDistance": baseDistance == null ? null : baseDistance,
    "BaseShipFee": baseShipFee == null ? null : baseShipFee,
    "ExtraShipFee": extraShipFee == null ? null : extraShipFee,
    'TermConditionUrl':termCondition == null ? null : termCondition,
    'GuideUrl':guideUrl == null ? null : guideUrl,
  };
}
