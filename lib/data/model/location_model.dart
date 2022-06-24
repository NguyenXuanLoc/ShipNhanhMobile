
// @dart = 2.9
import 'dart:convert';

LocationModel userInfoModelFromJson(String str) =>
    LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  double lat;
  double lng;
  String address;

  LocationModel({
  this.lat = 0,
  this.lng = 0,
  this.address});


  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    lat: json['lat'],
    lng: json['lng'],
    address: json['address'],
  );

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
    'address': address,
  };
}