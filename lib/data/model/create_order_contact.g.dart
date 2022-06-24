// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderContact _$CreateOrderContactFromJson(Map<String, dynamic> json) {
  return CreateOrderContact(
    address: json['address'] as String?,
    userName: json['userName'] as String?,
    phone: json['phone'] as String?,
    lat: (json['lat'] as num?)?.toDouble(),
    long: (json['long'] as num?)?.toDouble(),
    shopMallId: json['shopMallId'] as int?,
    fromOtherPlace: json['fromOtherPlace'] as bool?,
    note: json['note'] as String?,
  );
}

Map<String, dynamic> _$CreateOrderContactToJson(CreateOrderContact instance) =>
    <String, dynamic>{
      'address': instance.address,
      'userName': instance.userName,
      'phone': instance.phone,
      'lat': instance.lat,
      'long': instance.long,
      'shopMallId': instance.shopMallId,
      'fromOtherPlace': instance.fromOtherPlace,
      'note': instance.note,
    };
