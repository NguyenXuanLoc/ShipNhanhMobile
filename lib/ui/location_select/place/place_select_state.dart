import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/model/create_order_contact.dart';
import 'package:smartship_partner/data/model/shop_mall.dart';

abstract class PlaceSelectState extends Equatable {
  @override
  List<Object> get props => [];
}

class PlaceSelectStartState extends PlaceSelectState {}

class PlaceLoadedState extends PlaceSelectState {
  List<CreateOrderContact> originData;
  List<CreateOrderContact> searchResultData;
  PlaceLoadedState({this.originData = const [], this.searchResultData=const []});
}
