// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ApiClient implements ApiClient {
  _ApiClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://smartshipapp.com/api/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<BaseResponse<ShipAreasResponse>> getShipAreas([groupType = 1]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'groupType': groupType};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<ShipAreasResponse>>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/B2BApp/GetB2BAppConfig',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<ShipAreasResponse>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<LoginData>> login(xAppKey, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<LoginData>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/PhoneSignIn',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<LoginData>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<UserProfileData>> updateUserProfile(
      xAppKey, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<UserProfileData>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/UpdateProfile',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<UserProfileData>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<UserProfileData>> updateUserProfileWithAvatar(
      xAppKey, file, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
        'file',
        MultipartFile.fromFileSync(file.path,
            filename: file.path.split(Platform.pathSeparator).last)));
    _data.fields.add(MapEntry('Data', jsonEncode(request)));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<UserProfileData>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/UpdateProfileWithAvatar',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<UserProfileData>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<UserResponse>> getUserInfo(
      authToken, userId, pageIndex, xAppKey) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'authToken': authToken,
      r'userId': userId,
      r'pageIndex': pageIndex
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<UserResponse>>(Options(
                method: 'GET',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/GetUserInfo',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<UserResponse>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<LoginData>> getUserAppLogin(xAppKey, authToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'authToken': authToken};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<LoginData>>(Options(
                method: 'GET',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, 'B2BApp/AppLogin',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<LoginData>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<dynamic>> sendFeedback(xAppKey, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<dynamic>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/SendFeedback',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<dynamic>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<dynamic>> sendFeedbackWithImage(
      xAppKey, file, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
        'file',
        MultipartFile.fromFileSync(file.path,
            filename: file.path.split(Platform.pathSeparator).last)));
    _data.fields.add(MapEntry('Data', jsonEncode(request)));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<dynamic>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/SendFeedbackImage',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<dynamic>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<dynamic>> registerDevice(xAppKey, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<dynamic>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/RegisterDevice',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<dynamic>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<dynamic>> logout(xAppKey, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<dynamic>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, 'B2BApp/Logout',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<dynamic>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<OrderListData>> getOrderList(
      xAppKey, pageIndex, pageSize, keyword, status, authToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'PageIndex': pageIndex,
      r'PageSize': pageSize,
      r'Keyword': keyword,
      r'Status': status,
      r'AuthToken': authToken
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<OrderListData>>(Options(
                method: 'GET',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra,
                contentType: 'application/x-www-form-urlencoded')
            .compose(_dio.options, '/B2BApp/ListOrders',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<OrderListData>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<OrderDetailData>> getOrderDetail(
      xAppKey, orderId, authToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'orderId': orderId,
      r'AuthToken': authToken
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<OrderDetailData>>(Options(
                method: 'GET',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/OrderDetail',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<OrderDetailData>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<ShipperNearbyResponse>> getShippersNearby(
      xAppKey, authToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'authToken': authToken};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<ShipperNearbyResponse>>(Options(
                method: 'GET',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/GetShippersNearBy',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<ShipperNearbyResponse>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<ShopMallResponse>> getShopMalls(
      xAppKey, authToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'authToken': authToken};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<ShopMallResponse>>(Options(
                method: 'GET',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/GetShopMall',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<ShopMallResponse>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<NewOrderResposne>> createOrder(xAppKey, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<NewOrderResposne>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/CreateOrder',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<NewOrderResposne>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<NewOrderResposne>> createOrderWithImage(
      xAppKey, file, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
        'file',
        MultipartFile.fromFileSync(file.path,
            filename: file.path.split(Platform.pathSeparator).last)));
    _data.fields.add(MapEntry('Data', jsonEncode(request)));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<NewOrderResposne>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/CreateOrderWithImage',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<NewOrderResposne>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<NewOrderResposne>> createOrderWithImages(
      xAppKey, file, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    _data.files.addAll(file.map((i) => MapEntry(
        'file',
        MultipartFile.fromFileSync(
          i.path,
          filename: i.path.split(Platform.pathSeparator).last,
        ))));
    _data.fields.add(MapEntry('Data', jsonEncode(request)));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<NewOrderResposne>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/CreateOrderWithImage',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<NewOrderResposne>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<NewOrderResposne>> updateOrder(xAppKey, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<NewOrderResposne>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/EditOrder',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<NewOrderResposne>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<NewOrderResposne>> updateOrderWithImage(
      xAppKey, file, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
        'file',
        MultipartFile.fromFileSync(file.path,
            filename: file.path.split(Platform.pathSeparator).last)));
    _data.fields.add(MapEntry('Data', jsonEncode(request)));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<NewOrderResposne>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/EditOrderWithImage',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<NewOrderResposne>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<NoteListData>> getNoteList(
      xAppKey, orderId, authToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'orderId': orderId,
      r'authToken': authToken
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<NoteListData>>(Options(
                method: 'GET',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/GetOrderLogChange',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<NoteListData>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<dynamic>> createNote(xAppKey, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<dynamic>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/AddNomarlLog',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<dynamic>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<Object>> rateOrder(xAppKey, rateOrderRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(rateOrderRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<Object>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/CreateRate',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<Object>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<Object>> cancelOrder(xAppKey, cancelOrderRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(cancelOrderRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<Object>>(Options(
                method: 'POST',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/CancelOrder',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<Object>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse<StatisticResponse>> getStatistic(
      xAppKey, token, pageIndex, from, to) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'authToken': token,
      r'pageIndex': pageIndex,
      r'from': from,
      r'to': to
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<StatisticResponse>>(Options(
                method: 'GET',
                headers: <String, dynamic>{r'x-AppKey': xAppKey},
                extra: _extra)
            .compose(_dio.options, '/B2BApp/GetUserHistory',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<StatisticResponse>.fromJson(_result.data!);
    return value;
  }

  @override
  Future<HereRoute> getRoute(
      apiKey, waypoint0, waypoint1, mode, routeattributes) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'apiKey': apiKey,
      r'waypoint0': waypoint0,
      r'waypoint1': waypoint1,
      r'mode': mode,
      r'routeattributes': routeattributes
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HereRoute>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/routing/7.2/calculateroute.json',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = HereRoute.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NearbyPlace> getNearbyPlaces(apiKey, _in, pretty) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'apiKey': apiKey,
      r'in': _in,
      r'pretty': pretty
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NearbyPlace>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/places/v1/discover/around',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NearbyPlace.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchPlace> getSearchPlaces(
      apiKey, at, limit, lang, countryCode, query) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'apiKey': apiKey,
      r'at': at,
      r'limit': limit,
      r'lang': lang,
      r'countryCode': countryCode,
      r'q': query
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SearchPlace>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/v1/autosuggest',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SearchPlace.fromJson(_result.data!);
    return value;
  }

  @override
  Future<HereAuthResponse> getAccessToken(request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HereAuthResponse>(
            Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/oauth2/token',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = HereAuthResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
