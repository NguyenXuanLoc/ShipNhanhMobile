// @dart = 2.9
import 'dart:convert';

OrderDetailData orderDetailDataFromJson(String str) =>
    OrderDetailData.fromJson(json.decode(str));

String orderDetailDataToJson(OrderDetailData data) =>
    json.encode(data.toJson());

class OrderDetailData {
  OrderDetailData({
    this.orderDetail,
  });

  OrderDetail orderDetail;

  factory OrderDetailData.fromJson(Map<String, dynamic> json) {
    return OrderDetailData(
      orderDetail: OrderDetail.fromJson(json['OrderDetail']),
    );
  }

  Map<String, dynamic> toJson() => {
        'OrderDetail': orderDetail.toJson(),
      };
}

class OrderDetail {
  OrderDetail({
    this.acceptedTime,
    this.brokenBy,
    this.brokenTime,
    this.shipperLng,
    this.shipperLat,
    this.privateStatus,
    this.shipperType,
    this.isShipperRate,
    this.isSellerRate,
    this.isVerified,
    this.canceledReason,
    this.shippers,
    this.totalRecords,
    this.childShipper,
    this.takingShipper,
    this.returnShipper,
    this.shipperNumber,
    this.shopNumber,
    this.idOrder,
    this.orderId,
    this.toAddress,
    this.fromAddress,
    this.description,
    this.deadline,
    this.amount,
    this.status,
    this.deliveryFee,
    this.createdTime,
    this.idCategory,
    this.categoryId,
    this.category,
    this.pictureUrl,
    this.receiverName,
    this.receiverPhone,
    this.fromLat,
    this.toLat,
    this.fromLng,
    this.toLng,
    this.views,
    this.waittings,
    this.shopOrderId,
    this.showTo,
    this.sharingUrl,
    this.hasVerifyImage,
    this.verifyImageUrl,
    this.brokenReason,
    this.favoriteType,
    this.favoriteTypeName,
    this.qrCode,
    this.notesAmount,
    this.notes,
    this.notesType,
    this.returnAmount,
    this.returnNotes,
    this.returnType,
    this.idForwardShipper,
    this.forwardPrice,
    this.forwardName,
    this.forwardPhone,
    this.forwardUrl,
    this.forwardNumber,
    this.forwardRate,
    this.idTakeShipper,
    this.takePrice,
    this.takeName,
    this.takePhone,
    this.takeUrl,
    this.takeNumber,
    this.takeRate,
    this.hub,
    this.hubLng,
    this.hubLat,
    this.idReturnShipper,
    this.returnPrice,
    this.returnName,
    this.returnPhone,
    this.returnUrl,
    this.returnNumber,
    this.returnRate,
    this.returnHub,
    this.returnHubLng,
    this.returnHubLat,
    this.shipperPictureUrl,
    this.shipperName,
    this.shipperEmail,
    this.shipperPhone,
    this.shipperRate,
    this.shipperId,
    this.sellerId,
    this.sellerName,
    this.sellerEmail,
    this.sellerPhone,
    this.sellerPictureUrl,
    this.sellerRate,
    this.sellerNumber,
    this.IsFbOrder,
    this.fbShopName,
    this.fbShopPhoneNumber,
    this.b2BEmail,
    this.b2BPhone,
    this.b2BId,
    this.shopGroupType,
    this.idShopMall
  });

  DateTime acceptedTime;
  int brokenBy;
  dynamic brokenTime;
  double shipperLng;
  double shipperLat;
  int privateStatus;
  int shipperType;
  bool isShipperRate;
  bool isSellerRate;
  bool isVerified;
  String canceledReason;
  dynamic shippers;
  int totalRecords;
  dynamic childShipper;
  dynamic takingShipper;
  dynamic returnShipper;
  String shipperNumber;
  String shopNumber;
  int idOrder;
  int orderId;
  String toAddress;
  String fromAddress;
  String description;
  DateTime deadline;
  double amount;
  int status;
  double deliveryFee;
  DateTime createdTime;
  int idCategory;
  int categoryId;
  String category;
  String pictureUrl;
  String receiverName;
  String receiverPhone;
  double fromLat;
  double toLat;
  double fromLng;
  double toLng;
  int views;
  int waittings;
  int shopOrderId;
  int showTo;
  String sharingUrl;
  bool hasVerifyImage;
  String verifyImageUrl;
  dynamic brokenReason;
  int favoriteType;
  String favoriteTypeName;
  dynamic qrCode;
  double notesAmount;
  String notes;
  int notesType;
  double returnAmount;
  String returnNotes;
  int returnType;
  int idForwardShipper;
  double forwardPrice;
  dynamic forwardName;
  dynamic forwardPhone;
  dynamic forwardUrl;
  dynamic forwardNumber;
  double forwardRate;
  int idTakeShipper;
  double takePrice;
  dynamic takeName;
  dynamic takePhone;
  dynamic takeUrl;
  dynamic takeNumber;
  double takeRate;
  dynamic hub;
  dynamic hubLng;
  dynamic hubLat;
  int idReturnShipper;
  double returnPrice;
  dynamic returnName;
  dynamic returnPhone;
  dynamic returnUrl;
  dynamic returnNumber;
  double returnRate;
  dynamic returnHub;
  dynamic returnHubLng;
  dynamic returnHubLat;
  String shipperPictureUrl;
  String shipperName;
  dynamic shipperEmail;
  String shipperPhone;
  double shipperRate;
  int shipperId;
  int sellerId;
  String sellerName;
  String sellerEmail;
  String sellerPhone;
  String sellerPictureUrl;
  double sellerRate;
  dynamic sellerNumber;
  bool IsFbOrder;
  String fbShopName;
  String fbShopPhoneNumber;
  bool isReturnedGood;
  int returnGoodType;
  dynamic returnGoodTypeTime;
  String b2BEmail;
  String b2BPhone;
  int b2BId;
  double weight;
  double prepay;
  bool isRealAmount;
  int paidBy;
  int warehouseStatus;
  dynamic warehouseChangeTime;
  int shipperGroupType;
  int shopGroupType;
  int idShopMall;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
      acceptedTime: json['AcceptedTime'] != null
          ? DateTime.parse(json['AcceptedTime'])
          : DateTime.now(),
      brokenBy: json['BrokenBy'],
      brokenTime: json['BrokenTime'],
      shipperLng: json['ShipperLng'].toDouble(),
      shipperLat: json['ShipperLat'].toDouble(),
      privateStatus: json['PrivateStatus'],
      shipperType: json['ShipperType'],
      isShipperRate: json['IsShipperRate'],
      isSellerRate: json['IsSellerRate'],
      isVerified: json['IsVerified'],
      canceledReason: json['CanceledReason'],
      shippers: json['Shippers'],
      totalRecords: json['TotalRecords'],
      childShipper: json['ChildShipper'],
      takingShipper: json['TakingShipper'],
      returnShipper: json['ReturnShipper'],
      shipperNumber: json['ShipperNumber'],
      shopNumber: json['ShopNumber'],
      idOrder: json['IdOrder'],
      orderId: json['OrderId'],
      toAddress: json['ToAddress'],
      fromAddress: json['FromAddress'],
      description: json['Description'],
      deadline: DateTime.parse(json['Deadline']),
      amount: json['Amount'],
      status: json['Status'],
      deliveryFee: json['DeliveryFee'],
      createdTime: DateTime.parse(json['CreatedTime']),
      idCategory: json['IdCategory'],
      categoryId: json['CategoryId'],
      category: json['Category'],
      pictureUrl: json['PictureUrl'],
      receiverName: json['ReceiverName'],
      receiverPhone: json['ReceiverPhone'],
      fromLat: json['FromLat'].toDouble(),
      toLat: json['ToLat'].toDouble(),
      fromLng: json['FromLng'].toDouble(),
      toLng: json['ToLng'].toDouble(),
      views: json['Views'],
      waittings: json['Waittings'],
      shopOrderId: json['ShopOrderId'],
      showTo: json['ShowTo'],
      sharingUrl: json['SharingUrl'],
      hasVerifyImage: json['HasVerifyImage'],
      verifyImageUrl: json['VerifyImageUrl'],
      brokenReason: json['BrokenReason'],
      favoriteType: json['FavoriteType'],
      favoriteTypeName: json['FavoriteTypeName'],
      qrCode: json['QrCode'],
      notesAmount: json['NotesAmount'],
      notes: json['Notes'],
      notesType: json['NotesType'],
      returnAmount: json['ReturnAmount'],
      returnNotes: json['ReturnNotes'],
      returnType: json['ReturnType'],
      idForwardShipper: json['IdForwardShipper'],
      forwardPrice: json['ForwardPrice'],
      forwardName: json['ForwardName'],
      forwardPhone: json['ForwardPhone'],
      forwardUrl: json['ForwardUrl'],
      forwardNumber: json['ForwardNumber'],
      forwardRate: json['ForwardRate'],
      idTakeShipper: json['IdTakeShipper'],
      takePrice: json['TakePrice'],
      takeName: json['TakeName'],
      takePhone: json['TakePhone'],
      takeUrl: json['TakeUrl'],
      takeNumber: json['TakeNumber'],
      takeRate: json['TakeRate'],
      hub: json['Hub'],
      hubLng: json['HubLng'],
      hubLat: json['HubLat'],
      idReturnShipper: json['IdReturnShipper'],
      returnPrice: json['ReturnPrice'],
      returnName: json['ReturnName'],
      returnPhone: json['ReturnPhone'],
      returnUrl: json['ReturnUrl'],
      returnNumber: json['ReturnNumber'],
      returnRate: json['ReturnRate'],
      returnHub: json['ReturnHub'],
      returnHubLng: json['ReturnHubLng'],
      returnHubLat: json['ReturnHubLat'],
      shipperPictureUrl: json['ShipperPictureUrl'],
      shipperName: json['ShipperName'],
      shipperEmail: json['ShipperEmail'],
      shipperPhone: json['ShipperPhone'],
      shipperRate: json['ShipperRate'],
      shipperId: json['ShipperId'],
      sellerId: json['SellerId'],
      sellerName: json['SellerName'],
      sellerEmail: json['SellerEmail'],
      sellerPhone: json['SellerPhone'],
      sellerPictureUrl: json['SellerPictureUrl'],
      sellerRate: json['SellerRate'],
      sellerNumber: json['SellerNumber'],
      IsFbOrder: json['IsFbOrder'],
      fbShopName: json['FbShopName'],
      fbShopPhoneNumber: json['FbShopPhoneNumber'],
      b2BEmail: json['B2bEmail'],
      b2BPhone: json['B2bPhone'],
      b2BId: json['B2bId'],
      shopGroupType: json['ShopGroupType'],
      idShopMall: json['IdShopMall']);

  Map<String, dynamic> toJson() => {
        'AcceptedTime': acceptedTime.toIso8601String(),
        'BrokenBy': brokenBy,
        'BrokenTime': brokenTime,
        'ShipperLng': shipperLng,
        'ShipperLat': shipperLat,
        'PrivateStatus': privateStatus,
        'ShipperType': shipperType,
        'IsShipperRate': isShipperRate,
        'IsSellerRate': isSellerRate,
        'IsVerified': isVerified,
        'CanceledReason': canceledReason,
        'Shippers': shippers,
        'TotalRecords': totalRecords,
        'ChildShipper': childShipper,
        'TakingShipper': takingShipper,
        'ReturnShipper': returnShipper,
        'ShipperNumber': shipperNumber,
        'ShopNumber': shopNumber,
        'IdOrder': idOrder,
        'OrderId': orderId,
        'ToAddress': toAddress,
        'FromAddress': fromAddress,
        'Description': description,
        'Deadline': deadline.toIso8601String(),
        'Amount': amount,
        'Status': status,
        'DeliveryFee': deliveryFee,
        'CreatedTime': createdTime.toIso8601String(),
        'IdCategory': idCategory,
        'CategoryId': categoryId,
        'Category': category,
        'PictureUrl': pictureUrl,
        'ReceiverName': receiverName,
        'ReceiverPhone': receiverPhone,
        'FromLat': fromLat,
        'ToLat': toLat,
        'FromLng': fromLng,
        'ToLng': toLng,
        'Views': views,
        'Waittings': waittings,
        'ShopOrderId': shopOrderId,
        'ShowTo': showTo,
        'SharingUrl': sharingUrl,
        'HasVerifyImage': hasVerifyImage,
        'VerifyImageUrl': verifyImageUrl,
        'BrokenReason': brokenReason,
        'FavoriteType': favoriteType,
        'FavoriteTypeName': favoriteTypeName,
        'QrCode': qrCode,
        'NotesAmount': notesAmount,
        'Notes': notes,
        'NotesType': notesType,
        'ReturnAmount': returnAmount,
        'ReturnNotes': returnNotes,
        'ReturnType': returnType,
        'IdForwardShipper': idForwardShipper,
        'ForwardPrice': forwardPrice,
        'ForwardName': forwardName,
        'ForwardPhone': forwardPhone,
        'ForwardUrl': forwardUrl,
        'ForwardNumber': forwardNumber,
        'ForwardRate': forwardRate,
        'IdTakeShipper': idTakeShipper,
        'TakePrice': takePrice,
        'TakeName': takeName,
        'TakePhone': takePhone,
        'TakeUrl': takeUrl,
        'TakeNumber': takeNumber,
        'TakeRate': takeRate,
        'Hub': hub,
        'HubLng': hubLng,
        'HubLat': hubLat,
        'IdReturnShipper': idReturnShipper,
        'ReturnPrice': returnPrice,
        'ReturnName': returnName,
        'ReturnPhone': returnPhone,
        'ReturnUrl': returnUrl,
        'ReturnNumber': returnNumber,
        'ReturnRate': returnRate,
        'ReturnHub': returnHub,
        'ReturnHubLng': returnHubLng,
        'ReturnHubLat': returnHubLat,
        'ShipperPictureUrl': shipperPictureUrl,
        'ShipperName': shipperName,
        'ShipperEmail': shipperEmail,
        'ShipperPhone': shipperPhone,
        'ShipperRate': shipperRate,
        'ShipperId': shipperId,
        'SellerId': sellerId,
        'SellerName': sellerName,
        'SellerEmail': sellerEmail,
        'SellerPhone': sellerPhone,
        'SellerPictureUrl': sellerPictureUrl,
        'SellerRate': sellerRate,
        'SellerNumber': sellerNumber,
        'IsFbOrder': IsFbOrder,
        'FbShopName': fbShopName,
        'FbShopPhoneNumber': fbShopPhoneNumber,
        'B2bEmail': b2BEmail,
        'B2bPhone': b2BPhone,
        'B2bId': b2BId,
        'ShopGroupType': shopGroupType,
        'IdShopMall': idShopMall
      };
}
