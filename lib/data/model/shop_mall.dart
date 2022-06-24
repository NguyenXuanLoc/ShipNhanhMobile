// @dart = 2.9
// To parse this JSON data, do
//
//     final shopMall = shopMallFromJson(jsonString);

import 'dart:convert';

ShopMall shopMallFromJson(String str) => ShopMall.fromJson(json.decode(str));

String shopMallToJson(ShopMall data) => json.encode(data.toJson());

class ShopMall {
  ShopMall({
    this.id,
    this.idB2B,
    this.address,
    this.lat,
    this.lng,
    this.contactName,
    this.contactPhone,
    this.isActive,
    this.description,
    this.pictures
  });

  int id;
  int idB2B;
  String address;
  double lat;
  double lng;
  String contactName;
  String contactPhone;
  bool isActive;
  String description;
  List<Picture> pictures;

  factory ShopMall.fromJson(Map<String, dynamic> json) => ShopMall(
    id: json["Id"] == null ? null : json["Id"],
    idB2B: json["IdB2b"] == null ? null : json["IdB2b"],
    address: json["Address"] == null ? null : json["Address"],
    lat: json["Lat"] == null ? null : json["Lat"],
    lng: json["Lng"] == null ? null : json["Lng"],
    contactName: json["ContactName"] == null ? null : json["ContactName"],
    contactPhone: json["ContactPhone"] == null ? null : json["ContactPhone"],
    isActive: json["IsActive"] == null ? null : json["IsActive"],
    description: json["Description"] == null ? null : json["Description"],
    pictures: List<Picture>.from(json["Pictures"].map((x) => Picture.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Id": id == null ? null : id,
    "IdB2b": idB2B == null ? null : idB2B,
    "Address": address == null ? null : address,
    "Lat": lat == null ? null : lat,
    "Lng": lng == null ? null : lng,
    "ContactName": contactName == null ? null : contactName,
    "ContactPhone": contactPhone == null ? null : contactPhone,
    "IsActive": isActive == null ? null : isActive,
    "Description": description == null ? null : description,
    "Pictures": pictures == null ? null : pictures,
    "Pictures": List<dynamic>.from(pictures.map((x) => x.toJson())),
  };
}

class Picture {
  Picture({
    this.id,
    this.fileName,
    this.createdTime,
    this.idShopMall,
    this.pictureUrl,
  });

  int id;
  String fileName;
  DateTime createdTime;
  int idShopMall;
  String pictureUrl;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    id: json["Id"],
    fileName: json["FileName"],
    createdTime: DateTime.parse(json["CreatedTime"]),
    idShopMall: json["IdShopMall"],
    pictureUrl: json["PictureUrl"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "FileName": fileName,
    "CreatedTime": createdTime.toIso8601String(),
    "IdShopMall": idShopMall,
    "PictureUrl": pictureUrl,
  };
}
