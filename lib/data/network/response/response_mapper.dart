// @dart = 2.9
import 'package:smartship_partner/data/network/request/order/create_update_order_request.dart';
import 'package:smartship_partner/data/network/response/area/ship_areas_response.dart';
import 'package:smartship_partner/data/network/response/create_order/shipper_nearby_response.dart';
import 'package:smartship_partner/data/network/response/create_order/shop_mall_response.dart';
import 'package:smartship_partner/data/network/response/login/login_response.dart';
import 'package:smartship_partner/data/network/response/order/note_list_response.dart';
import 'package:smartship_partner/data/network/response/order/order_detail_reponse.dart';
import 'package:smartship_partner/data/network/response/statistic/statistic_response.dart';
import 'package:smartship_partner/data/network/response/user_profile/user_profile_data.dart';
import 'package:smartship_partner/data/network/response/user_profile/user_response.dart';

import 'order/order_list_response.dart';

class ResponseMapper {
  static T dataFromJson<T>(Map<String, dynamic> input) {
    switch (T) {
      case LoginData:
        return LoginData.fromJson(input) as T;
      case OrderListData:
        return OrderListData.fromJson(input) as T;
      case UserProfileData:
        return UserProfileData.fromJson(input) as T;
      case OrderDetailData:
        return OrderDetailData.fromJson(input) as T;
      case ShipperNearbyResponse:
        return ShipperNearbyResponse.fromJson(input) as T;
      case ShopMallResponse:
        return ShopMallResponse.fromJson(input) as T;
      case NewOrderRequest:
        return NewOrderRequest.fromJson(input) as T;
      case UserResponse:
        return UserResponse.fromJson(input) as T;
      case StatisticResponse:
        return StatisticResponse.fromJson(input) as T;
      case NoteListData:
        return NoteListData.fromJson(input) as T;
      case ShipAreasResponse:
        return ShipAreasResponse.fromJson(input) as T;
      default:
        print('not found data mapper for ' + T.toString());
        return null;
    }
  }
}
