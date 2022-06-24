import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  static var app_version = '1.0.0';
  static var app_bar_icon_size = 40.0;
  static const DEFAULT_POSITION = LatLng(21.028511, 105.804817);
  static const DEFAULT_PAGE_SIZE = 100;
}

class HomeConstants {
  static const TAB_COUNT = 5;
  static const TAB_HOME_POS = 0;
  static const TAB_STATISTIC_POS = 1;
  static const TAB_NOTIFICATION_POS = 3;
  static const TAB_MORE_POS = 4;
}

class FirebaseConstants {
  static const KEY_TERM_OF_USE = 'term_of_use';
  static const KEY_INSTRUCTION = 'instruction';
  static const DEFAULT_TERM_OF_USE =
      'https://smartshipapp.com/smart-ship/dieu-khoan';
  static const DEFAULT_INSTRUCTION =
      'https://smartshipapp.com/smart-ship/huong-dan';
  static const DEFAULT_RMT_CONFIG = <String, dynamic>{
    KEY_TERM_OF_USE: DEFAULT_TERM_OF_USE,
    KEY_INSTRUCTION: DEFAULT_INSTRUCTION
  };
}

class CreateOrderCategory {
  static const TYPE_SHIP = 6;
  static const TYPE_BUY = 8;
  static const TYPE_GRAB = 9;
}

class CreateOrderStatus {
  static const TYPE_NEW = 0;
  static const TYPE_EDIT = 1;
}

class DatabaseConstant {
  static const DB_NAME = 'shipnhanh_db';
  static const String TABLE_NOTIFICATION = 'notification';
}
