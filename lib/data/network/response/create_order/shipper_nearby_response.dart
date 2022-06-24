// @dart = 2.9
// To parse this JSON data, do
//
//     final shipperNearByResponse = shipperNearByResponseFromJson(jsonString);

import 'dart:convert';

import 'package:smartship_partner/data/model/shipper_model.dart';

ShipperNearbyResponse shipperNearByResponseFromJson(String str) =>
    ShipperNearbyResponse.fromJson(json.decode(str));

String shipperNearByResponseToJson(ShipperNearbyResponse data) =>
    json.encode(data.toJson());

class ShipperNearbyResponse {
  ShipperNearbyResponse({
    this.shippers,
  });

  List<ShipperModel> shippers;

  factory ShipperNearbyResponse.fromJson(Map<String, dynamic> json) =>
      ShipperNearbyResponse(
        shippers: json["Shippers"] == null
            ? null
            : List<ShipperModel>.from(
                json["Shippers"].map((x) => ShipperModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Shippers": shippers == null
            ? null
            : List<dynamic>.from(shippers.map((x) => x.toJson())),
      };
}
