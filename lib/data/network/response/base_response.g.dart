// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse<T> _$BaseResponseFromJson<T>(Map<String, dynamic> json) {
  return BaseResponse<T>(
    isSuccess: json['IsSuccess'] as bool?,
    message: json['Message'] as String?,
    isLogout: json['IsLogout'] as bool?,
    data: json['Data'],
  );
}

Map<String, dynamic> _$BaseResponseToJson<T>(BaseResponse<T> instance) =>
    <String, dynamic>{
      'Data': instance.data,
      'IsSuccess': instance.isSuccess,
      'Message': instance.message,
      'IsLogout': instance.isLogout,
    };
