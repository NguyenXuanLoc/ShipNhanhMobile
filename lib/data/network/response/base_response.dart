
import 'package:json_annotation/json_annotation.dart';
import 'package:smartship_partner/data/network/response/response_mapper.dart';

part 'base_response.g.dart';

/// Base response,
/// For every T response class, need to declare in [ResponseMapper]
@JsonSerializable()
class BaseResponse<T> {
  @JsonKey(name: 'Data')
  dynamic data;
  @JsonKey(name: 'IsSuccess')
  bool? isSuccess;
  @JsonKey(name: 'Message')
  String? message;
  @JsonKey(name: 'IsLogout')
  bool? isLogout;

  BaseResponse({this.isSuccess, this.message, this.isLogout, this.data});

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson<T>(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);

  T get dataResponse {
    return ResponseMapper.dataFromJson(data);
  }
}

//T _dataFromJson<T>(Map<String, dynamic> input) => ResponseMapper.dataFromJson(input);
//
//Map<String, dynamic> _dataToJson<T>(T input) => ResponseMapper.dataToJson(input);

T? _dataFromJson<T>(Map<String, dynamic> input) => input['Data'] as T?;

Map<String, dynamic> _dataToJson<T>(T input) => {'Data': input};
