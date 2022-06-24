// @dart = 2.9
// To parse this JSON data, do
//
//     final shopMallResponse = shopMallResponseFromJson(jsonString);

import 'dart:convert';

import 'package:smartship_partner/data/model/shop_mall.dart';

ShopMallResponse shopMallResponseFromJson(String str) => ShopMallResponse.fromJson(json.decode(str));

String shopMallResponseToJson(ShopMallResponse data) => json.encode(data.toJson());

class ShopMallResponse {
  ShopMallResponse({
    this.shopMalls,
  });

  List<ShopMall> shopMalls;

  factory ShopMallResponse.fromJson(Map<String, dynamic> json) => ShopMallResponse(
    shopMalls: json["ShopMalls"] == null ? null : List<ShopMall>.from(json["ShopMalls"].map((x) => ShopMall.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ShopMalls": shopMalls == null ? null : List<dynamic>.from(shopMalls.map((x) => x.toJson())),
  };
}
