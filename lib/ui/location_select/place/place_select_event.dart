import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/model/create_order_contact.dart';

abstract class PlaceSelectEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PlaceSelectStartEvent extends PlaceSelectEvent {
  String searchKeyword;

  PlaceSelectStartEvent([this.searchKeyword = '']);

  @override
  // TODO: implement props
  List<Object> get props => [searchKeyword];
}

///***************EventBus****************/
class PlaceSearchResultEBEvent {
  List<CreateOrderContact> result;

  PlaceSearchResultEBEvent(this.result);
}
