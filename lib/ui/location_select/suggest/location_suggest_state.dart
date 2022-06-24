import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/model/shop_mall.dart';

abstract class LocationSuggestState extends Equatable {
  @override
  List<Object> get props => [];
}

class LocationSuggestStartState extends LocationSuggestState {}

class LocationSuggestLoadedState extends LocationSuggestState {
  List<ShopMall> originData;
  List<ShopMall> searchResultData;

  LocationSuggestLoadedState(
      {this.originData = const [], this.searchResultData = const []});
}
