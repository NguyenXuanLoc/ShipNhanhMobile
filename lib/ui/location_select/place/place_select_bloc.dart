// @dart = 2.9
import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/create_order_contact.dart';
import 'package:smartship_partner/data/network/response/here_map/nearbyPlace_response.dart';
import 'package:smartship_partner/data/network/response/here_map/searchPlace_response.dart';
import 'package:smartship_partner/data/repository/hereMap_repository.dart';
import 'package:smartship_partner/data/repository/order_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/ui/location_select/place/place_select_event.dart';
import 'package:smartship_partner/ui/location_select/place/place_select_state.dart';
import 'package:smartship_partner/util/utils.dart';

class PlaceSelectBloc extends Bloc<PlaceSelectEvent, PlaceSelectState> {
  final _userRepository = UserRepository.get(PrefsManager.get);
  OrderRepository _orderRepository;

  CancelableOperation _cancelableOperation;
  LatLng currentLocation;
  /* Maps */
  //final _geoPlaces = GoogleMapsPlaces(apiKey: Utils.googleMapKey);

  PlaceSelectBloc(PlaceSelectState initialState) : super(initialState) {
    _orderRepository = OrderRepository.get(_userRepository);
  }

  @override
  Stream<PlaceSelectState> mapEventToState(PlaceSelectEvent event) async* {
    switch (event.runtimeType) {
      case PlaceSelectStartEvent:
        var searchKeyWord = (event as PlaceSelectStartEvent).searchKeyword;
        if (_cancelableOperation != null && !_cancelableOperation.isCanceled) {
          await _cancelableOperation.cancel();
        }

        if (searchKeyWord == null || searchKeyWord.isEmpty) {
          _cancelableOperation =
              CancelableOperation.fromFuture(_loadNearbyPlace());
        } else {
          _cancelableOperation =
              CancelableOperation.fromFuture(_loadPlaceWithText(searchKeyWord));
        }
        await _cancelableOperation.value.then((value) {
          print('PlaceSearchResultEBEvent fire');
          Utils.eventBus.fire(PlaceSearchResultEBEvent(value));
        });
        return;
    }
  }

  //  Future<LatLng> _getCurrentLocation() async {
  //   print('load curent location');
  //   if(currentLocation == null)
  //     {
  //       var position = await Geolocator()
  //           .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //       currentLocation = LatLng(position.latitude, position.longitude);
  //     }
  //   return currentLocation;
  // }

  Future<List<CreateOrderContact>> _loadNearbyPlace([int radius = 5000]) async {
    try {
      var currentPosition = await LocationUtil.getCurrentLocation();
      print('current Location: $currentPosition');

      var nearbyPlaceResponse = await HereMapRepository().getNearbyPlace(currentPosition);

      if (nearbyPlaceResponse != null &&
        nearbyPlaceResponse.error == null&&
        nearbyPlaceResponse.results != null &&
          nearbyPlaceResponse.results.items.isNotEmpty) {
        var data = nearbyPlaceResponse.results.items.map((Items item){
          var r_item = CreateOrderContact(
              userName: '',
              phone: '',
              lat: item.position.first,
              long: item.position.last,
              address: item.title+ ', ' + Utils.stripHtmlIfNeeded(item.vicinity));
          return r_item;
        }).toList();

        return data;
      }
      return [];
    } catch (error) {
      print('load nearby places failed: $error');
      return [];
    }
  }

  @Deprecated('unused due to only show predictions')
  Future<List<CreateOrderContact>> _loadPlaceWithText(String text) async {
    print('_loadPlaceWithText');
    var currentPosition = await LocationUtil.getCurrentLocation();
    var hm_response = await HereMapRepository().searchPlace(currentPosition, text);
    if(hm_response != null &&
    hm_response.error == null &&
    hm_response.items.isNotEmpty)
      {
        var data = hm_response.items.map((HereSearchItem s_item) {
          var r_item = CreateOrderContact(
              userName: '',
              phone: '',
              lat: s_item.position.lat,
              long: s_item.position.lng,
              address: s_item.title );
          return r_item;
        }).toList();
        return data;
      }
    return [];
  }

  Future<List<CreateOrderContact>> _filterPlace(
      List<CreateOrderContact> originList, String keyword) async {
    var result = <CreateOrderContact>[];
    if (keyword.isEmpty) {
      result.addAll(originList);
    } else {
      keyword = keyword.toLowerCase();
      var dummyList = originList.where((item) {
        /* Filter by description, address */
        return item.address.toLowerCase().contains(keyword);
      }).toList();
      result.addAll(dummyList);
    }
    ;
    return result;
  }
}
