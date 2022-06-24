class HereAuthResponse {
  HereAuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.error,
    required this.errorDescription,
  });
  late final String accessToken;
  late final String tokenType;
  late final int expiresIn;
  late final String error;
  late final String errorDescription;

  HereAuthResponse.fromJson(Map<String, dynamic> json){
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    error = json['error'];
    errorDescription = json['error_description'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['access_token'] = accessToken;
    _data['token_type'] = tokenType;
    _data['expires_in'] = expiresIn;
    _data['error'] = error;
    _data['error_description'] = errorDescription;
    return _data;
  }
}