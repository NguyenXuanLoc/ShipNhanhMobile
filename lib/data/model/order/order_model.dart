// @dart = 2.9
// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    this.description,
    this.fromAddress,
    this.toAddress,
    this.receiverPhone,
    this.receiverName,
    this.amount,
    this.deliveryFee,
    this.prepay,
    this.deadline,
    this.id,
    this.orderStatus,
    this.categoryId,
    this.fromLat,
    this.toLat,
    this.fromLng,
    this.toLng,
    this.fromAddDetail,
    this.toAddDetail,
    this.pictureUrl,
    this.distance,
    this.isAdminOrder,
    this.suggestName,
    this.isTemplate,
    this.favoriteType,
    this.isFbOrder,
    this.fbShopName,
    this.fbShopPhoneNumber,
    this.shipperId,
    this.barcode,
    this.shopId,
    this.isIncludedReturnGoods,
    this.weight,
    this.paidBy,
    this.idShopMall,
  });

  String description;
  String fromAddress;
  String toAddress;
  String receiverPhone;
  String receiverName;
  double amount;
  double deliveryFee;
  double prepay;
  DateTime deadline;
  int id;
  int orderStatus;
  int categoryId;
  double fromLat;
  double toLat;
  double fromLng;
  double toLng;
  String fromAddDetail;
  String toAddDetail;
  String pictureUrl;
  double distance;
  bool isAdminOrder;
  String suggestName;
  bool isTemplate;
  int favoriteType;
  bool isFbOrder;
  String fbShopName;
  String fbShopPhoneNumber;
  int shipperId;
  String barcode;
  int shopId;
  bool isIncludedReturnGoods;
  double weight;
  int paidBy;
  int idShopMall;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    description: json["Description"] == null ? null : json["Description"],
    fromAddress: json["FromAddress"] == null ? null : json["FromAddress"],
    toAddress: json["ToAddress"] == null ? null : json["ToAddress"],
    receiverPhone: json["ReceiverPhone"] == null ? null : json["ReceiverPhone"],
    receiverName: json["ReceiverName"] == null ? null : json["ReceiverName"],
    amount: json["Amount"] == null ? null : json["Amount"],
    deliveryFee: json["DeliveryFee"] == null ? null : json["DeliveryFee"],
    prepay: json["Prepay"] == null ? null : json["Prepay"],
    deadline: json["Deadline"] == null ? null : DateTime.parse(json["Deadline"]),
    id: json["Id"] == null ? null : json["Id"],
    orderStatus: json["OrderStatus"] == null ? null : json["OrderStatus"],
    categoryId: json["CategoryId"] == null ? null : json["CategoryId"],
    fromLat: json["FromLat"] == null ? null : json["FromLat"],
    toLat: json["ToLat"] == null ? null : json["ToLat"],
    fromLng: json["FromLng"] == null ? null : json["FromLng"],
    toLng: json["ToLng"] == null ? null : json["ToLng"],
    fromAddDetail: json["FromAddDetail"] == null ? null : json["FromAddDetail"],
    toAddDetail: json["ToAddDetail"] == null ? null : json["ToAddDetail"],
    pictureUrl: json["PictureUrl"] == null ? null : json["PictureUrl"],
    distance: json["Distance"] == null ? null : json["Distance"],
    isAdminOrder: json["IsAdminOrder"] == null ? null : json["IsAdminOrder"],
    suggestName: json["SuggestName"] == null ? null : json["SuggestName"],
    isTemplate: json["IsTemplate"] == null ? null : json["IsTemplate"],
    favoriteType: json["FavoriteType"] == null ? null : json["FavoriteType"],
    isFbOrder: json["IsFbOrder"] == null ? null : json["IsFbOrder"],
    fbShopName: json["FbShopName"] == null ? null : json["FbShopName"],
    fbShopPhoneNumber: json["FbShopPhoneNumber"] == null ? null : json["FbShopPhoneNumber"],
    shipperId: json["ShipperId"] == null ? null : json["ShipperId"],
    barcode: json["Barcode"] == null ? null : json["Barcode"],
    shopId: json["ShopId"] == null ? null : json["ShopId"],
    isIncludedReturnGoods: json["IsIncludedReturnGoods"] == null ? null : json["IsIncludedReturnGoods"],
    weight: json["Weight"] == null ? null : json["Weight"],
    paidBy: json["PaidBy"] == null ? null : json["PaidBy"],
    idShopMall: json["IdShopMall"] == null ? null : json["IdShopMall"],
  );

  Map<String, dynamic> toJson() => {
    "Description": description == null ? null : description,
    "FromAddress": fromAddress == null ? null : fromAddress,
    "ToAddress": toAddress == null ? null : toAddress,
    "ReceiverPhone": receiverPhone == null ? null : receiverPhone,
    "ReceiverName": receiverName == null ? null : receiverName,
    "Amount": amount == null ? null : amount,
    "DeliveryFee": deliveryFee == null ? null : deliveryFee,
    "Prepay": prepay == null ? null : prepay,
    "Deadline": deadline == null ? null : deadline.toIso8601String(),
    "Id": id == null ? null : id,
    "OrderStatus": orderStatus == null ? null : orderStatus,
    "CategoryId": categoryId == null ? null : categoryId,
    "FromLat": fromLat == null ? null : fromLat,
    "ToLat": toLat == null ? null : toLat,
    "FromLng": fromLng == null ? null : fromLng,
    "ToLng": toLng == null ? null : toLng,
    "FromAddDetail": fromAddDetail == null ? null : fromAddDetail,
    "ToAddDetail": toAddDetail == null ? null : toAddDetail,
    "PictureUrl": pictureUrl == null ? null : pictureUrl,
    "Distance": distance == null ? null : distance,
    "IsAdminOrder": isAdminOrder == null ? null : isAdminOrder,
    "SuggestName": suggestName == null ? null : suggestName,
    "IsTemplate": isTemplate == null ? null : isTemplate,
    "FavoriteType": favoriteType == null ? null : favoriteType,
    "IsFbOrder": isFbOrder == null ? null : isFbOrder,
    "FbShopName": fbShopName == null ? null : fbShopName,
    "FbShopPhoneNumber": fbShopPhoneNumber == null ? null : fbShopPhoneNumber,
    "ShipperId": shipperId == null ? null : shipperId,
    "Barcode": barcode == null ? null : barcode,
    "ShopId": shopId == null ? null : shopId,
    "IsIncludedReturnGoods": isIncludedReturnGoods == null ? null : isIncludedReturnGoods,
    "Weight": weight == null ? null : weight,
    "PaidBy": paidBy == null ? null : paidBy,
    "IdShopMall": idShopMall == null ? null : idShopMall,
  };
}
