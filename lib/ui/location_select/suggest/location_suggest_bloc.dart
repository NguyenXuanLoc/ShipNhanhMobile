// @dart = 2.9
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/shop_mall.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/network/response/create_order/shop_mall_response.dart';
import 'package:smartship_partner/data/repository/order_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/ui/location_select/place/place_select_event.dart';
import 'package:smartship_partner/ui/location_select/place/place_select_state.dart';
import 'package:smartship_partner/ui/location_select/suggest/location_suggest_event.dart';
import 'package:smartship_partner/ui/location_select/suggest/location_suggest_state.dart';

class LocationSuggestBloc extends Bloc<LocationSuggestEvent, LocationSuggestState> {
  final UserRepository _userRepository = UserRepository.get(PrefsManager.get);
  OrderRepository _orderRepository;

  LocationSuggestBloc(LocationSuggestState initialState) : super(initialState) {
    _orderRepository = OrderRepository.get(_userRepository);
  }

  @override
  Stream<LocationSuggestState> mapEventToState(LocationSuggestEvent event) async* {
    switch (event.runtimeType) {
      case LocationSuggestStartEvent:
        var searchKeyWord = (event as LocationSuggestStartEvent).searchKeyword;
        var data = await _loadShopMalls(searchKeyWord);
        yield LocationSuggestLoadedState(originData: data[0], searchResultData: data[1]);
        return;
    }
  }

  Future<List<dynamic>> _loadShopMalls(String keyword) async {
    keyword = keyword ?? '';
    var data = await _orderRepository.getShopMalls();
    if (data != null && data.isSuccess) {
      var shoppMalls = data.dataResponse.shopMalls;
      if (shoppMalls != null) {
        var searchResult = await _filterShopMalls(shoppMalls, keyword);
        return [shoppMalls, searchResult];
      }
    }
    return [[], []];
  }

  Future<List<ShopMall>> _filterShopMalls(
      List<ShopMall> originList, String keyword) async {
    var result = <ShopMall>[];
    if (keyword.isEmpty) {
      result.addAll(originList);
    } else {
      keyword = keyword.toLowerCase();
      var dummyList = originList.where((mall) {
        /* Filter by description, address */
        return (mall.description.toLowerCase().contains(keyword) ||
            mall.address.toLowerCase().contains(keyword));
      }).toList();
      result.addAll(dummyList);
    }
    ;
    return result;
  }
}
