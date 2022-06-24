// @dart = 2.9
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/config/router/route_util.dart';
import 'package:smartship_partner/config/router/router.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/local/db/entity/notification_entity.dart';
import 'package:smartship_partner/data/local/db/entity/notification_entity.dart'
    as notifyEntity;
import 'package:smartship_partner/data/repository/db_repository.dart';
import 'package:smartship_partner/data/repository/hereMap_repository.dart';
import 'package:smartship_partner/ui/home/home_event.dart';
import 'package:smartship_partner/ui/notification/notification.dart';
import 'package:smartship_partner/ui/notification/notification_page.dart';
import 'package:smartship_partner/ui/order/order_list/oder_list_page.dart';
import 'package:smartship_partner/ui/setting/setting_page.dart';
import 'package:smartship_partner/ui/statistic/statistic_page.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/home/create_order_bottom_sheet.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../base/base_state.dart';
import '../../config/color/color.dart';

/// Local notification
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'com.SS.shipnhanh', 'ShipNhanh', '',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    color: AppColors.colorAccent);
var iOSPlatformChannelSpecifics = IOSNotificationDetails();
var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

void _handleNotification(
    Map<String, dynamic> message, bool showNotification) async {
  notifyEntity.Notification notification;


  /// Parse android
  if (message.containsKey('data')) {
    notification =
        notificationFromJson(Map<String, dynamic>.from(message['data']));
  } else if (message.containsKey('aps')) {
    /// Parse iOS
    notification = notificationFromJson(Map<String, dynamic>.from(message));
  } else if (message != null) {

    notification = notificationFromJson(Map<String, dynamic>.from(message));
  }
  else{
    /// No data at message, just return
    return;
  }
  var db = DatabaseRepository.get();
  db.init();
  print('message: ${json.encode(message)}');
  await db.insertNotification(notification);

  print('saved notification: ${notification.orderId} ${notification.message}');
  Utils.eventBus.fire(NewNotificationEBEvent(notification));

  if (showNotification) {
    var id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await flutterLocalNotificationsPlugin.show(
        id, notification.title, notification.message, platformChannelSpecifics,
        payload: notification.orderId);
  } else {
    if (int.parse(notification?.orderId ?? '0') <= 0) return;
    Utils.eventBus.fire(NotificationTriggeredEBEvent(notification.orderId));
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends BaseOrderState<HomePage>
    with TickerProviderStateMixin {
  bool _showNotificationBadge = false;
  int _selectedIndex;
  final List<Widget> _homeTabs = [
    OrderListPage(),
    StatisticPage(),
    Container(),
    NotificationPage(),
    SettingPage()
  ];

  // static Future<dynamic> myBackgroundMessageHandler(
  //     Map<String, dynamic> message) {
  //   print('onBackgroundMessage: $message ');
  //
  //   /// This method called when  message in background (ios will not received this message)
  //   _handleNotification(message, Platform.isAndroid);
  // }

  Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.

    print('onBackgroundMessage: $message ');
    // await Fluttertoast.showToast(
    //     msg: 'getInitialMessage toast : ${message.data}',
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );

    /// This method called when  message in background (ios will not received this message)
    _handleNotification(message.data, Platform.isAndroid);
  }


  @override
  void onFirstVisible() {

    //HereMapRepository.get().getAccessToken();
    //FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }

      /// Called when received at foreground (for notification message)
      /// and all case (for data message - Android)
      print('onMessage: $message');
      _handleNotification(message.data, true);

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('Got a message after open!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }

      /// Called when received at foreground (for notification message)
      /// and all case (for data message - Android)
      print('onMessage: $message');
      _handleNotification(message.data, false);

    });

     FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message){

      _handleNotification(message.data, false);
    });
  }

  @override
  void initState() {
    super.initState();
    _initLocalNotification();
    _selectedIndex = 0;
    Utils.eventBus.on<NewNotificationEBEvent>().listen((event) {
      // Not shown badge when current tab is notification
      if (_selectedIndex != 2) {
        setState(() {
          _showNotificationBadge = true;
        });
      } else {
        _showNotificationBadge = false;
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 2) {
        _showNotificationBadge = false;
      }
    });
  }

  Widget _tabIcon(Widget icon, [bool showBadge = false]) {
    if (!showBadge) {
      return Container(
          width: 22, height: 22, alignment: Alignment.center, child: icon);
    }
    return Container(
      width: 25,
      height: 25,
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                child: icon),
          ),
          Positioned(
            right: 1,
            top: 1,
            child: Icon(
              Icons.brightness_1,
              size: 10,
              color: AppColors.colorAccent,
            ),
          )
        ],
      ),
    );
  }

  void _initLocalNotification() {
    var android = AndroidInitializationSettings('app_icon');
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android:android, iOS:iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    Utils.eventBus.fire(NotificationTriggeredEBEvent(payload));
  }

  @override
  Widget getLayout(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 667, allowFontScaling: true);
    return DefaultTabController(
      length: HomeConstants.TAB_COUNT,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _homeTabs,
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _bottomNavigationTapped,
            items: [
              BottomNavigationBarItem(
                  icon: _tabIcon(SvgPicture.asset(
                    'assets/images/phone/ic_home.svg',
                    height: 22,
                    width: 22,
                    color: _selectedIndex == HomeConstants.TAB_HOME_POS
                        ? AppColors.colorAccent
                        : AppColors.colorGrey,
                  )),
                  title: Text(AppTranslations.of(context).text('home_page'))
                  // text: AppTranslations.of(context).text('home_page'),
                  ),
              BottomNavigationBarItem(
                  icon: _tabIcon(SvgPicture.asset(
                    'assets/images/phone/ic_statistic.svg',
                    height: 19.5,
                    width: 33,
                    color: _selectedIndex == HomeConstants.TAB_STATISTIC_POS
                        ? AppColors.colorAccent
                        : AppColors.colorGrey,
                  )),
                  title: Text(AppTranslations.of(context).text('statistic'))
                  // text: AppTranslations.of(context).text('statistic'),
                  ),
              BottomNavigationBarItem(icon: Container(), title: Text('')),
              BottomNavigationBarItem(
                  icon: _tabIcon(
                      SvgPicture.asset(
                        'assets/images/phone/ic_notification.svg',
                        height: 22,
                        width: 17,
                        color:
                            _selectedIndex == HomeConstants.TAB_NOTIFICATION_POS
                                ? AppColors.colorAccent
                                : AppColors.colorGrey,
                      ),
                      _showNotificationBadge),
                  title: Text(AppTranslations.of(context).text('notification'))
                  // text: AppTranslations.of(context).text('notification'),
                  ),
              BottomNavigationBarItem(
                  icon: _tabIcon(SvgPicture.asset(
                    'assets/images/phone/ic_more.svg',
                    height: 8,
                    width: 30,
                    color: _selectedIndex == HomeConstants.TAB_MORE_POS
                        ? AppColors.colorAccent
                        : AppColors.colorGrey,
                  )),
                  title: Text(AppTranslations.of(context).text('setting'))
                  // text: AppTranslations.of(context).text('setting'),
                  ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
          child: GestureDetector(
            onTap: _showCreateOrderSheet,
            child: SvgPicture.asset(
              'assets/images/phone/ic_create_order.svg',
            ),
          ),
        ),
      ),
    );
  }

// bottomNavigationBar: SafeArea(
// bottom: true,
// child: TabBar(
// onTap: _onItemTapped,
// labelStyle: TextStyle(
// fontSize: ScreenUtil().setSp(FontConfig.font_x_small),
// fontWeight: FontWeight.bold),
// labelColor: AppColors.colorAccent,
// unselectedLabelColor: AppColors.colorGrey,
// indicatorColor: Colors.transparent,
// tabs: <Widget>[
// Tab(
// icon: _tabIcon(SvgPicture.asset(
// 'assets/images/phone/ic_home.svg',
// height: 22,
// width: 22,
// color: _selectedIndex == 0
// ? AppColors.colorAccent
//     : AppColors.colorGrey,
// )),
// // text: AppTranslations.of(context).text('home_page'),
// ),
// Tab(
// icon: _tabIcon(SvgPicture.asset(
// 'assets/images/phone/ic_statistic.svg',
// height: 19.5,
// width: 33,
// color: _selectedIndex == 1
// ? AppColors.colorAccent
//     : AppColors.colorGrey,
// )),
// // text: AppTranslations.of(context).text('statistic'),
// ),
// Tab(
// icon: _tabIcon(
// SvgPicture.asset(
// 'assets/images/phone/ic_notification.svg',
// height: 22,
// width: 17,
// color: _selectedIndex == 2
// ? AppColors.colorAccent
//     : AppColors.colorGrey,
// ),
// _showNotificationBadge),
// // text: AppTranslations.of(context).text('notification'),
// ),
// Tab(
// icon: _tabIcon(SvgPicture.asset(
// 'assets/images/phone/ic_more.svg',
// height: 8,
// width: 30,
// color: _selectedIndex == 3
// ? AppColors.colorAccent
//     : AppColors.colorGrey,
// )),
// // text: AppTranslations.of(context).text('setting'),
// ),
// ],
// ),
// ),

  void _bottomNavigationTapped(int index) {
    if (index == 2) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showCreateOrderSheet() async {
    var orderType = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return CreateOrderBottomSheet();
        });
    if (orderType != null) {
      if (orderType != -1) {
        _enterCreateOrder(orderType);
      } else {
        _enterCreateOrderWithImages();
      }
    }
  }

  void _enterCreateOrder(orderType) async {
    var created = await RouterUtils.push(
            context,
            AppRouter.createOrder +
                '/' +
                CreateOrderStatus.TYPE_NEW.toString() +
                '/' +
                orderType.toString(),
            false) ??
        false;
    if (created != null) {
      Utils.eventBus.fire(OrderCreatedHomeEvent(created));
    }
  }

  void _enterCreateOrderWithImages() async {
    var created =
        await RouterUtils.push(context, AppRouter.createOrderWithImages) ??
            false;
    if (created != null) {
      Utils.eventBus.fire(OrderCreatedHomeEvent(created));
    }
  }
}
