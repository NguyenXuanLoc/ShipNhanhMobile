
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

/// Thông tin lấy/giao hàng

part 'create_order_contact.g.dart';

 @JsonSerializable()
class CreateOrderContact {
  String? address;
  String? userName;
  String? phone;
  double? lat;
  double? long;
  int? shopMallId;
  bool? fromOtherPlace; // Select place from other place (no lat, lon)
  String? note;
  CreateOrderContact(
      {this.address,
      this.userName,
      this.phone,
      this.lat=0,
      this.long=0,
      this.shopMallId = 0,
      this.fromOtherPlace = false,
      this.note});

  bool isLocationValid() {
    return lat != null && long != null && lat! >= 0 && long! >= 0;
  }

  LatLng getLocation() {
    return LatLng(lat!, long!);
  }

  // A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory CreateOrderContact.fromJson(Map<String, dynamic> json) => _$CreateOrderContactFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CreateOrderContactToJson(this);
}
