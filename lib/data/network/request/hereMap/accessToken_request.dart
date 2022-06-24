// @dart = 2.9
import 'dart:convert';

AccessTokenRequest loginRequestFromJson(String str) =>
    AccessTokenRequest.fromJson(json.decode(str));

String loginRequestToJson(AccessTokenRequest data) =>
    json.encode(data.toJson());

class AccessTokenRequest {
  AccessTokenRequest({this.grant_type, this.client_id, this.client_secret});

  String grant_type;
  String client_id;
  String client_secret;

  factory AccessTokenRequest.fromJson(Map<String, dynamic> json) =>
      AccessTokenRequest(
          grant_type: json['grant_type'],
          client_id: json['client_id'],
          client_secret: json['client_secret']);

  Map<String, dynamic> toJson() =>
      {'grant_type': grant_type, 'client_id': client_id ?? '', 'client_secret': client_secret};
}
