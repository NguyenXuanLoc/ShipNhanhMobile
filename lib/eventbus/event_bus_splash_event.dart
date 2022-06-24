// @dart = 2.9
import 'package:smartship_partner/data/network/response/area/ship_areas_response.dart';

class SplashUserLoggedInEvent {
  bool loggedIn = false;

  SplashUserLoggedInEvent({this.loggedIn});
}

class SplashNotSelectAreaEvent {
  bool selectArea = false;
  List<AppB2BConfig> configList;

  SplashNotSelectAreaEvent([this.configList, this.selectArea = false]);
}
