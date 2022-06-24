// @dart = 2.9
// To parse this JSON data, do
//
//     final orderListData = orderListDataFromJson(jsonString);

import 'dart:convert';

OrderListData orderListDataFromJson(String str) => OrderListData.fromJson(json.decode(str));

String orderListDataToJson(OrderListData data) => json.encode(data.toJson());

class OrderListData {
  OrderListData({
    this.orders,
    this.totalRecords,
  });

  List<Order> orders;
  int totalRecords;

  factory OrderListData.fromJson(Map<String, dynamic> json) => OrderListData(
    orders: json['Orders'] == null ? null : List<Order>.from(json['Orders'].map((x) => Order.fromJson(x))),
    totalRecords: json['TotalRecords'],
  );

  Map<String, dynamic> toJson() => {
    'Orders': orders == null ? null : List<dynamic>.from(orders.map((x) => x.toJson())),
    'TotalRecords': totalRecords,
  };
}

class Order {
  Order({
    this.rowIndex,
//    this.acceptedTime,
//    this.shippedTime,
//    this.deliverredTime,
//    this.brokenTime,
//    this.totalMinutes,
//    this.idOrder,
    this.orderId,
    this.toAddress,
    this.fromAddress,
    this.description,
    this.deadline,
    this.amount,
    this.status,
    this.deliveryFee,
//    this.createdTime,
//    this.idCategory,
    this.categoryId,
    this.category,
    this.pictureUrl,
    this.receiverName,
    this.receiverPhone,
    this.fromLat,
    this.toLat,
    this.fromLng,
    this.toLng,
    this.fromAddDetail,
    this.toAddDetail,
    this.distance,
//    this.views,
//    this.waittings,
//    this.bidPrice,
//    this.shopOrderId,
//    this.isFbOrder,
//    this.fbUId,
//    this.isBot,
//    this.showTo,
//    this.sharingUrl,
//    this.hasVerifyImage,
//    this.verifyImageUrl,
//    this.brokenReason,
//    this.favoriteType,
//    this.favoriteTypeName,
//    this.qrCode,
    this.notesAmount,
    this.notes,
    this.notesType,
//    this.returnAmount,
//    this.returnNotes,
//    this.returnType,
//    this.idForwardShipper,
//    this.forwardPrice,
//    this.forwardName,
//    this.forwardPhone,
//    this.forwardUrl,
//    this.forwardNumber,
//    this.forwardRate,
    this.idTakeShipper,
    this.takePrice,
    this.takeName,
    this.takePhone,
    this.takeUrl,
    this.takeNumber,
    this.takeRate,
//    this.hub,
//    this.hubLng,
//    this.hubLat,
//    this.idReturnShipper,
//    this.returnPrice,
//    this.returnName,
//    this.returnPhone,
//    this.returnUrl,
//    this.returnNumber,
//    this.returnRate,
//    this.returnHub,
//    this.returnHubLng,
//    this.returnHubLat,
    this.shipperPictureUrl,
    this.shipperName,
    this.shipperEmail,
    this.shipperPhone,
    this.shipperRate,
    this.shipperId,
    this.shipperNumber,
//    this.sellerId,
//    this.sellerName,
//    this.sellerEmail,
//    this.sellerPhone,
//    this.sellerPictureUrl,
//    this.sellerRate,
//    this.sellerNumber,
//    this.fbShopName,
//    this.fbShopPhoneNumber,
//    this.isReturnedGood,
//    this.returnGoodType,
//    this.returnGoodTypeTime,
//    this.b2BEmail,
//    this.b2BPhone,
//    this.b2BId,
//    this.weight,
//    this.prepay,
//    this.isRealAmount,
//    this.paidBy,
//    this.warehouseStatus,
//    this.warehouseChangeTime,
//    this.shipperGroupType,
//    this.shopGroupType,
//    this.idShopMall,
  });

  int rowIndex;
//  DateTime acceptedTime;
//  DateTime shippedTime;
//  DateTime deliverredTime;
//  DateTime brokenTime;
//  int totalMinutes;
//  int idOrder;
  int orderId;
  String toAddress;
  String fromAddress;
  String description;
  DateTime deadline;
  double amount;
  int status;
  double deliveryFee;
  DateTime createdTime;
//  int idCategory;
  int categoryId;
  String category;
  String pictureUrl;
  String receiverName;
  String receiverPhone;
  double fromLat;
  double toLat;
  double fromLng;
  double toLng;
  String fromAddDetail;
  String toAddDetail;
  double distance;
//  int views;
//  int waittings;
//  double bidPrice;
//  String shopOrderId;
//  bool isFbOrder;
//  String fbUId;
//  bool isBot;
//  int showTo;
//  String sharingUrl;
//  bool hasVerifyImage;
//  String verifyImageUrl;
//  String brokenReason;
//  int favoriteType;
//  String favoriteTypeName;
//  String qrCode;
  double notesAmount;
  String notes;
  int notesType;
//  double returnAmount;
//  String returnNotes;
//  int returnType;
//  int idForwardShipper;
//  double forwardPrice;
//  String forwardName;
//  String forwardPhone;
//  String forwardUrl;
//  String forwardNumber;
//  double forwardRate;
  int idTakeShipper;
  double takePrice;
  String takeName;
  String takePhone;
  String takeUrl;
  String takeNumber;
  double takeRate;
//  String hub;
//  double hubLng;
//  double hubLat;
//  int idReturnShipper;
//  double returnPrice;
//  String returnName;
//  String returnPhone;
//  String returnUrl;
//  String returnNumber;
//  double returnRate;
//  String returnHub;
//  double returnHubLng;
//  double returnHubLat;
  String shipperPictureUrl;
  String shipperName;
  String shipperEmail;
  String shipperPhone;
  double shipperRate;
  int shipperId;
  String shipperNumber;
//  int sellerId;
//  String sellerName;
//  String sellerEmail;
//  String sellerPhone;
//  String sellerPictureUrl;
//  double sellerRate;
//  String sellerNumber;
//  String fbShopName;
//  String fbShopPhoneNumber;
//  bool isReturnedGood;
//  int returnGoodType;
//  DateTime returnGoodTypeTime;
//  String b2BEmail;
//  String b2BPhone;
//  int b2BId;
//  double weight;
//  double prepay;
//  bool isRealAmount;
//  int paidBy;
//  int warehouseStatus;
//  DateTime warehouseChangeTime;
//  int shipperGroupType;
//  int shopGroupType;
//  int idShopMall;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    rowIndex: json['RowIndex'],
//    acceptedTime: json['AcceptedTime'] == null ? null : DateTime.parse(json['AcceptedTime']),
//    shippedTime: json['ShippedTime'] == null ? null : DateTime.parse(json['ShippedTime']),
//    deliverredTime: json['DeliverredTime'] == null ? null : DateTime.parse(json['DeliverredTime']),
//    brokenTime: json['BrokenTime'] == null ? null : DateTime.parse(json['BrokenTime']),
//    totalMinutes: json['TotalMinutes'] == null ? null : json['TotalMinutes'],
//    idOrder: json['IdOrder'] == null ? null : json['IdOrder'],
    orderId: json['OrderId'],
    toAddress: json['ToAddress'],
    fromAddress: json['FromAddress'],
    description: json['Description'],
    deadline: json['Deadline'] == null ? null : DateTime.parse(json['Deadline']),
    amount: json['Amount'],
    status: json['Status'],
    deliveryFee: json['DeliveryFee'],
//    createdTime: json['CreatedTime'] == null ? null : DateTime.parse(json['CreatedTime']),
//    idCategory: json['IdCategory'] == null ? null : json['IdCategory'],
    categoryId: json['CategoryId'],
    category: json['Category'],
    pictureUrl: json['PictureUrl'],
    receiverName: json['ReceiverName'],
    receiverPhone: json['ReceiverPhone'],
    fromLat: json['FromLat'],
    toLat: json['ToLat'],
    fromLng: json['FromLng'],
    toLng: json['ToLng'],
    fromAddDetail: json['FromAddDetail'],
    toAddDetail: json['ToAddDetail'],
    distance: json['Distance'],
//    views: json['Views'] == null ? null : json['Views'],
//    waittings: json['Waittings'] == null ? null : json['Waittings'],
//    bidPrice: json['BidPrice'] == null ? null : json['BidPrice'],
//    shopOrderId: json['ShopOrderId'] == null ? null : json['ShopOrderId'],
//    isFbOrder: json['IsFbOrder'] == null ? null : json['IsFbOrder'],
//    fbUId: json['FbUId'] == null ? null : json['FbUId'],
//    isBot: json['IsBot'] == null ? null : json['IsBot'],
//    showTo: json['ShowTo'] == null ? null : json['ShowTo'],
//    sharingUrl: json['SharingUrl'] == null ? null : json['SharingUrl'],
//    hasVerifyImage: json['HasVerifyImage'] == null ? null : json['HasVerifyImage'],
//    verifyImageUrl: json['VerifyImageUrl'] == null ? null : json['VerifyImageUrl'],
//    brokenReason: json['BrokenReason'] == null ? null : json['BrokenReason'],
//    favoriteType: json['FavoriteType'] == null ? null : json['FavoriteType'],
//    favoriteTypeName: json['FavoriteTypeName'] == null ? null : json['FavoriteTypeName'],
//    qrCode: json['QrCode'] == null ? null : json['QrCode'],
    notesAmount: json['NotesAmount'],
    notes: json['Notes'],
    notesType: json['NotesType'],
//    returnAmount: json['ReturnAmount'] == null ? null : json['ReturnAmount'],
//    returnNotes: json['ReturnNotes'] == null ? null : json['ReturnNotes'],
//    returnType: json['ReturnType'] == null ? null : json['ReturnType'],
//    idForwardShipper: json['IdForwardShipper'] == null ? null : json['IdForwardShipper'],
//    forwardPrice: json['ForwardPrice'] == null ? null : json['ForwardPrice'],
//    forwardName: json['ForwardName'] == null ? null : json['ForwardName'],
//    forwardPhone: json['ForwardPhone'] == null ? null : json['ForwardPhone'],
//    forwardUrl: json['ForwardUrl'] == null ? null : json['ForwardUrl'],
//    forwardNumber: json['ForwardNumber'] == null ? null : json['ForwardNumber'],
//    forwardRate: json['ForwardRate'] == null ? null : json['ForwardRate'],
    idTakeShipper: json['IdTakeShipper'],
    takePrice: json['TakePrice'],
    takeName: json['TakeName'],
    takePhone: json['TakePhone'],
    takeUrl: json['TakeUrl'],
    takeNumber: json['TakeNumber'],
    takeRate: json['TakeRate'],
//    hub: json['Hub'] == null ? null : json['Hub'],
//    hubLng: json['HubLng'] == null ? null : json['HubLng'],
//    hubLat: json['HubLat'] == null ? null : json['HubLat'],
//    idReturnShipper: json['IdReturnShipper'] == null ? null : json['IdReturnShipper'],
//    returnPrice: json['ReturnPrice'] == null ? null : json['ReturnPrice'],
//    returnName: json['ReturnName'] == null ? null : json['ReturnName'],
//    returnPhone: json['ReturnPhone'] == null ? null : json['ReturnPhone'],
//    returnUrl: json['ReturnUrl'] == null ? null : json['ReturnUrl'],
//    returnNumber: json['ReturnNumber'] == null ? null : json['ReturnNumber'],
//    returnRate: json['ReturnRate'] == null ? null : json['ReturnRate'],
//    returnHub: json['ReturnHub'] == null ? null : json['ReturnHub'],
//    returnHubLng: json['ReturnHubLng'] == null ? null : json['ReturnHubLng'],
//    returnHubLat: json['ReturnHubLat'] == null ? null : json['ReturnHubLat'],
    shipperPictureUrl: json['ShipperPictureUrl'],
    shipperName: json['ShipperName'],
    shipperEmail: json['ShipperEmail'],
    shipperPhone: json['ShipperPhone'],
    shipperRate: json['ShipperRate'],
    shipperId: json['ShipperId'],
    shipperNumber: json['ShipperNumber'],
//    sellerId: json['SellerId'] == null ? null : json['SellerId'],
//    sellerName: json['SellerName'] == null ? null : json['SellerName'],
//    sellerEmail: json['SellerEmail'] == null ? null : json['SellerEmail'],
//    sellerPhone: json['SellerPhone'] == null ? null : json['SellerPhone'],
//    sellerPictureUrl: json['SellerPictureUrl'] == null ? null : json['SellerPictureUrl'],
//    sellerRate: json['SellerRate'] == null ? null : json['SellerRate'],
//    sellerNumber: json['SellerNumber'] == null ? null : json['SellerNumber'],
//    fbShopName: json['FbShopName'] == null ? null : json['FbShopName'],
//    fbShopPhoneNumber: json['FbShopPhoneNumber'] == null ? null : json['FbShopPhoneNumber'],
//    isReturnedGood: json['IsReturnedGood'] == null ? null : json['IsReturnedGood'],
//    returnGoodType: json['ReturnGoodType'] == null ? null : json['ReturnGoodType'],
//    returnGoodTypeTime: json['ReturnGoodTypeTime'] == null ? null : DateTime.parse(json['ReturnGoodTypeTime']),
//    b2BEmail: json['B2bEmail'] == null ? null : json['B2bEmail'],
//    b2BPhone: json['B2bPhone'] == null ? null : json['B2bPhone'],
//    b2BId: json['B2bId'] == null ? null : json['B2bId'],
//    weight: json['Weight'] == null ? null : json['Weight'],
//    prepay: json['Prepay'] == null ? null : json['Prepay'],
//    isRealAmount: json['IsRealAmount'] == null ? null : json['IsRealAmount'],
//    paidBy: json['PaidBy'] == null ? null : json['PaidBy'],
//    warehouseStatus: json['WarehouseStatus'] == null ? null : json['WarehouseStatus'],
//    warehouseChangeTime: json['WarehouseChangeTime'] == null ? null : DateTime.parse(json['WarehouseChangeTime']),
//    shipperGroupType: json['ShipperGroupType'] == null ? null : json['ShipperGroupType'],
//    shopGroupType: json['ShopGroupType'] == null ? null : json['ShopGroupType'],
//    idShopMall: json['IdShopMall'] == null ? null : json['IdShopMall'],
  );

  Map<String, dynamic> toJson() => {
    'RowIndex': rowIndex,
//    'AcceptedTime': acceptedTime == null ? null : acceptedTime.toIso8601String(),
//    'ShippedTime': shippedTime == null ? null : shippedTime.toIso8601String(),
//    'DeliverredTime': deliverredTime == null ? null : deliverredTime.toIso8601String(),
//    'BrokenTime': brokenTime == null ? null : brokenTime.toIso8601String(),
//    'TotalMinutes': totalMinutes == null ? null : totalMinutes,
//    'IdOrder': idOrder == null ? null : idOrder,
    'OrderId': orderId,
    'ToAddress': toAddress == null,
    'FromAddress': fromAddress,
    'Description': description,
    'Deadline': deadline == null ? null : deadline.toIso8601String(),
    'Amount': amount,
    'Status': status,
    'DeliveryFee': deliveryFee,
//    'CreatedTime': createdTime == null ? null : createdTime.toIso8601String(),
//    'IdCategory': idCategory == null ? null : idCategory,
    'CategoryId': categoryId,
    'Category': category,
    'PictureUrl': pictureUrl,
    'ReceiverName': receiverName,
    'ReceiverPhone': receiverPhone,
    'FromLat': fromLat,
    'ToLat': toLat,
    'FromLng': fromLng,
    'ToLng': toLng,
    'FromAddDetail': fromAddDetail,
    'ToAddDetail': toAddDetail,
    'Distance': distance,
//    'Views': views == null ? null : views,
//    'Waittings': waittings == null ? null : waittings,
//    'BidPrice': bidPrice == null ? null : bidPrice,
//    'ShopOrderId': shopOrderId == null ? null : shopOrderId,
//    'IsFbOrder': isFbOrder == null ? null : isFbOrder,
//    'FbUId': fbUId == null ? null : fbUId,
//    'IsBot': isBot == null ? null : isBot,
//    'ShowTo': showTo == null ? null : showTo,
//    'SharingUrl': sharingUrl == null ? null : sharingUrl,
//    'HasVerifyImage': hasVerifyImage == null ? null : hasVerifyImage,
//    'VerifyImageUrl': verifyImageUrl == null ? null : verifyImageUrl,
//    'BrokenReason': brokenReason == null ? null : brokenReason,
//    'FavoriteType': favoriteType == null ? null : favoriteType,
//    'FavoriteTypeName': favoriteTypeName == null ? null : favoriteTypeName,
//    'QrCode': qrCode == null ? null : qrCode,
    'NotesAmount': notesAmount,
    'Notes': notes,
    'NotesType': notesType,
//    'ReturnAmount': returnAmount == null ? null : returnAmount,
//    'ReturnNotes': returnNotes == null ? null : returnNotes,
//    'ReturnType': returnType == null ? null : returnType,
//    'IdForwardShipper': idForwardShipper == null ? null : idForwardShipper,
//    'ForwardPrice': forwardPrice == null ? null : forwardPrice,
//    'ForwardName': forwardName == null ? null : forwardName,
//    'ForwardPhone': forwardPhone == null ? null : forwardPhone,
//    'ForwardUrl': forwardUrl == null ? null : forwardUrl,
//    'ForwardNumber': forwardNumber == null ? null : forwardNumber,
//    'ForwardRate': forwardRate == null ? null : forwardRate,
    'IdTakeShipper': idTakeShipper,
    'TakePrice': takePrice,
    'TakeName': takeName,
    'TakePhone': takePhone,
    'TakeUrl': takeUrl,
    'TakeNumber': takeNumber,
    'TakeRate': takeRate,
//    'Hub': hub == null ? null : hub,
//    'HubLng': hubLng == null ? null : hubLng,
//    'HubLat': hubLat == null ? null : hubLat,
//    'IdReturnShipper': idReturnShipper == null ? null : idReturnShipper,
//    'ReturnPrice': returnPrice == null ? null : returnPrice,
//    'ReturnName': returnName == null ? null : returnName,
//    'ReturnPhone': returnPhone == null ? null : returnPhone,
//    'ReturnUrl': returnUrl == null ? null : returnUrl,
//    'ReturnNumber': returnNumber == null ? null : returnNumber,
//    'ReturnRate': returnRate == null ? null : returnRate,
//    'ReturnHub': returnHub == null ? null : returnHub,
//    'ReturnHubLng': returnHubLng == null ? null : returnHubLng,
//    'ReturnHubLat': returnHubLat == null ? null : returnHubLat,
//    'ShipperPictureUrl': shipperPictureUrl == null ? null : shipperPictureUrl,
//    'ShipperName': shipperName == null ? null : shipperName,
//    'ShipperEmail': shipperEmail == null ? null : shipperEmail,
//    'ShipperPhone': shipperPhone == null ? null : shipperPhone,
//    'ShipperRate': shipperRate == null ? null : shipperRate,
//    'ShipperId': shipperId == null ? null : shipperId,
//    'ShipperNumber': shipperNumber == null ? null : shipperNumber,
//    'SellerId': sellerId == null ? null : sellerId,
//    'SellerName': sellerName == null ? null : sellerName,
//    'SellerEmail': sellerEmail == null ? null : sellerEmail,
//    'SellerPhone': sellerPhone == null ? null : sellerPhone,
//    'SellerPictureUrl': sellerPictureUrl == null ? null : sellerPictureUrl,
//    'SellerRate': sellerRate == null ? null : sellerRate,
//    'SellerNumber': sellerNumber == null ? null : sellerNumber,
//    'FbShopName': fbShopName == null ? null : fbShopName,
//    'FbShopPhoneNumber': fbShopPhoneNumber == null ? null : fbShopPhoneNumber,
//    'IsReturnedGood': isReturnedGood == null ? null : isReturnedGood,
//    'ReturnGoodType': returnGoodType == null ? null : returnGoodType,
//    'ReturnGoodTypeTime': returnGoodTypeTime == null ? null : returnGoodTypeTime.toIso8601String(),
//    'B2bEmail': b2BEmail == null ? null : b2BEmail,
//    'B2bPhone': b2BPhone == null ? null : b2BPhone,
//    'B2bId': b2BId == null ? null : b2BId,
//    'Weight': weight == null ? null : weight,
//    'Prepay': prepay == null ? null : prepay,
//    'IsRealAmount': isRealAmount == null ? null : isRealAmount,
//    'PaidBy': paidBy == null ? null : paidBy,
//    'WarehouseStatus': warehouseStatus == null ? null : warehouseStatus,
//    'WarehouseChangeTime': warehouseChangeTime == null ? null : warehouseChangeTime.toIso8601String(),
//    'ShipperGroupType': shipperGroupType == null ? null : shipperGroupType,
//    'ShopGroupType': shopGroupType == null ? null : shopGroupType,
//    'IdShopMall': idShopMall == null ? null : idShopMall,
  };
}
