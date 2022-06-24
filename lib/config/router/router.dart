// @dart = 2.9
import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/model/order/new_order.dart';
import 'package:smartship_partner/data/model/shop_mall.dart';
import 'package:smartship_partner/data/model/user_info.dart';
import 'package:smartship_partner/data/model/order_info.dart';
import 'package:smartship_partner/ui/create_order/create_order_images/create_order_images.dart';
import 'package:smartship_partner/ui/create_order/step1/create_order_step1.dart';
import 'package:smartship_partner/ui/create_order/step2/create_order_step2_page.dart';
import 'package:smartship_partner/ui/driver_info/driver_info.dart';
import 'package:smartship_partner/ui/feedback/feedback.dart';
import 'package:smartship_partner/ui/home/home_page.dart';
import 'package:smartship_partner/ui/location_select/location_select_page.dart';
import 'package:smartship_partner/ui/location_select/suggest/detail/location_suggest_detail_page.dart';
import 'package:smartship_partner/ui/login/login.dart';
import 'package:smartship_partner/ui/order/order_detail/note/note_list/note_list_page.dart';
import 'package:smartship_partner/ui/order/order_detail/order_detail_page.dart';
import 'package:smartship_partner/ui/order/order_detail/ordermonitor/order_monitor_page.dart';
import 'package:smartship_partner/ui/order/update_order/step1/update_order_step1_page.dart';
import 'package:smartship_partner/ui/order/update_order/step2/update_order_step2_page.dart';
import 'package:smartship_partner/ui/splash/splash.dart';
import 'package:smartship_partner/ui/use_profile/user_profile.dart';

class AppRouter {
  static String splash = 'splash';
  static String login = 'login';
  static String home = 'home';
  static String profile = 'profile';
  static String updateProfile = 'update_profile';
  static String orderDetail = 'orderDetail';
  static String placeSelect = 'placeSelect';
  static String driveInfo = 'driveInfo';
  static String createOrder = 'createOrder';
  static String createOrderWithImages = 'createOrderWithImages';
  static String createOrderStep2 = 'createOrderStep2';
  static String feedback = 'feedback';
  static String orderMonitor = 'orderMonitor';
  static String noteList = 'noteList';
  static String updateOrderStep2 = 'updateOrderStep2';
  static String updateOrderStep1 = 'updateOrderStep1';
  static String locationSuggestDetail = 'locationSuggestDetail';

  static FluroRouter router = FluroRouter();

  static final Handler _loginHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LoginPage());

  static final Handler _splashHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SplashPage());

  static final Handler _userProfileHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    var phoneNumber = params['phoneNumber'][0];
    return UserProfilePage(phoneNumber: phoneNumber);
  });

  static final Handler _updateUserProfileHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    var stringToBase64Url = utf8.fuse(base64Url);
    var user = params['user'] != null
        ? userInfoModelFromJson(stringToBase64Url.decode(params['user'][0]))
        : UserInfoModel();
    return UserProfilePage(
      mode: UserProfilePage.TYPE_UPDATE,
      userInfoModel: user,
    );
  });
  static final Handler _homeHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          HomePage());

  static final Handler _orderDetailHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    print('order router: ${params['orderId'][0]}');
    var orderId = int.parse(params['orderId'][0]);
    return OrderDetailPage(orderId: orderId);
  });
  static final Handler _placeSelectHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    var state = int.parse(params['state'][0]);
    var orderType = int.parse(params['orderType'][0]);
    return LocationSelectPage(state = state, orderType = orderType);
  });

  static Handler driveInfoHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    var driverId = int.parse(params['driverId'][0]);
    return DriverInfoPage(driverId);
  });

  static final Handler _createOrderHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    var orderType = int.parse(params['orderType'][0]);

    orderType ??= CreateOrderCategory.TYPE_SHIP;
    return CreateOrderStep1Page(orderType);
  });

  static final Handler _createOrderStep2Handler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    var stringToBase64Url = utf8.fuse(base64Url);
    var order = params['order'] != null
        ? newOrderFromJson(stringToBase64Url.decode(params['order'][0]))
        : NewOrder();
    var filePath = params['imagePath'];
    String file;
    if (filePath != null) {
      String path = filePath[0];
      if (path != null && path.isNotEmpty) {
        file = stringToBase64Url.decode(path);
      }
    } else {
      file = null;
    }
    return CreateOrderStep2Page(
      order: order,
      filePath: file,
    );
  });

  static final Handler _createOrderWithImagesHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return CreateOrderImagesPage();
  });

  static final Handler _updateOrderStep2Handler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    var stringToBase64Url = utf8.fuse(base64Url);
    var order = params['order'] != null
        ? newOrderFromJson(stringToBase64Url.decode(params['order'][0]))
        : NewOrder();
    var filePath = params['imagePath'];
    String file;
    if (filePath != null) {
      String path = filePath[0];
      if (path != null && path.isNotEmpty) {
        file = stringToBase64Url.decode(path);
      }
    } else {
      file = null;
    }
    return UpdateOrderStep2Page(
      order: order,
      filePath: file,
    );
  });

  static final Handler _updateOrderStep1Handler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    var stringToBase64Url = utf8.fuse(base64Url);
    var order = params['order'] != null
        ? newOrderFromJson(stringToBase64Url.decode(params['order'][0]))
        : NewOrder();
    var filePath = params['imagePath'];

    return UpdateOrderStep1Page(order: order);
  });

  static final Handler _feedbackHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return FeedbackPage();
  });

  static final Handler _orderMonitorHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    var stringToBase64Url = utf8.fuse(base64Url);
    var order = params['order'] != null
        ? orderInfoFromJson(stringToBase64Url.decode(params['order'][0]))
        : OrderInfoModel();
    return OrderMonitorPage(
      order: order,
    );
  });

  static final Handler _noteListHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    var stringToBase64Url = utf8.fuse(base64Url);
    var order = params['order'] != null
        ? orderInfoFromJson(stringToBase64Url.decode(params['order'][0]))
        : OrderInfoModel();
    return NoteListPage(order: order);
  });

  static final Handler _locationSuggestDetailHandler =
  Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {

    var stringToBase64Url = utf8.fuse(base64Url);
    var shopMall = params['shopMall'] != null
        ? shopMallFromJson(stringToBase64Url.decode(params['shopMall'][0]))
        : ShopMall();

    return LocationSuggestDetailPage(shopMall: shopMall);
  });

  static void configRouter() {
    router.define(splash, handler: _splashHandler);
    router.define(login, handler: _loginHandler);
    router.define(profile + '/:phoneNumber', handler: _userProfileHandler);
    router.define(updateProfile + '/:user', handler: _updateUserProfileHandler);
    router.define(orderDetail + '/:orderId', handler: _orderDetailHandler);
    router.define(home, handler: _homeHandler);

    router.define(placeSelect + '/:state/:orderType',
        handler: _placeSelectHandler);
    // State is LocationSelectPage.TYPE_FROM or TYPE_TO
    // orderType is from CreateOrderCategory

    router.define(driveInfo + '/:driverId', handler: driveInfoHandler);
    router.define(createOrder + '/:type/:orderType',
        handler: _createOrderHandler);
    router.define(createOrderStep2 + '/:order/:imagePath',
        handler: _createOrderStep2Handler);
    router.define(createOrderWithImages,
        handler: _createOrderWithImagesHandler);
    router.define(feedback, handler: _feedbackHandler);
    router.define(orderMonitor + '/:order', handler: _orderMonitorHandler);
    router.define(noteList + '/:order', handler: _noteListHandler);
    router.define(updateOrderStep2 + '/:order/:imagePath',
        handler: _updateOrderStep2Handler);
    router.define(updateOrderStep1 + '/:order',
        handler: _updateOrderStep1Handler);
    router.define(locationSuggestDetail + '/:shopMall', handler: _locationSuggestDetailHandler);
  }
}
