import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/network/response/area/ship_areas_response.dart';

abstract class SplashEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SplashStartEvent extends SplashEvent {
  @override
  String toString() {
    return 'SplashStarted';
  }

  @override
  List<Object> get props => [DateTime.now()];
}

class SplashSelectedAreaEvent extends SplashEvent {
  AppB2BConfig area;

  SplashSelectedAreaEvent(this.area);

  @override
  List<Object> get props => [DateTime.now()];
}

class SplashLoadUserEvent extends SplashEvent {
  @override
  List<Object> get props => [DateTime.now()];
}
