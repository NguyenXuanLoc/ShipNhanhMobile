import 'package:equatable/equatable.dart';

abstract class LocationSuggestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LocationSuggestStartEvent extends LocationSuggestEvent {
  String searchKeyword;

  LocationSuggestStartEvent([this.searchKeyword = '']);
}
