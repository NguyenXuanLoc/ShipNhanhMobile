// @dart = 2.9
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/localizations/app_translations_delegate.dart';
import 'package:smartship_partner/config/localizations/application.dart';
import 'package:smartship_partner/config/router/router.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/repository/db_repository.dart';
import 'package:smartship_partner/widget/alert_dialog_two_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // change the status bar color to material color [green-400]
  await FlutterStatusbarcolor.setStatusBarColor(AppColors.colorPrimary);
  if (useWhiteForeground(AppColors.colorPrimary)) {
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  } else {
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  var prefs = await SharedPreferences.getInstance();
  await DatabaseRepository.get().init();

  AppRouter.configRouter();
  await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    Constants.app_version = packageInfo.version;
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
    print("onBackgroundMessage: $message ");
//    _handleNotification(message);
  }

  AppTranslationsDelegate _newLocaleDelegate;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  Future<void> _configureFcm() async {
    //_firebaseMessaging = FirebaseMessaging.instance;

    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }

  @override
  void initState() {
    _configureFcm();
    super.initState();
//    _initLocalNotification();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;


  }

  // Future<void> _firebaseMessagingopenApp(RemoteMessage message) async {
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call `initializeApp` before using other Firebase services.
  //   await Firebase.initializeApp();
  //
  //   print('[New FB handler] Handling a background message: ${message.messageId}');
  // }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print('[New FB handler] Handling a background message: ${message.messageId}');
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Ship Nhanh',
        localizationsDelegates: [
          _newLocaleDelegate,
          //provides localised strings
          GlobalMaterialLocalizations.delegate,
          //provides RTL support
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('vi', ''),
        ],
        theme: ThemeData(

            // Add the line below to get horizontal sliding transitions for routes.
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            }),
            primaryColor: AppColors.colorPrimary,
            accentColor: AppColors.colorAccent,
            // This is the theme of your application.
            //
            // Try running your application with 'flutter run'. You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // 'hot reload' (press 'r' in the console where you ran 'flutter run',
            // or simply save your changes to 'hot reload' in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Quicksand',
            appBarTheme: AppBarTheme(
              toolbarTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
            )),
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.router.generator);
  }

//  void _initLocalNotification() {
//    var android = AndroidInitializationSettings('app_icon');
//    var iOS = IOSInitializationSettings();
//    var initSetttings = InitializationSettings(android, iOS);
//    flutterLocalNotificationsPlugin.initialize(initSetttings,
//        onSelectNotification: onSelectNotification);
//  }

//  Future onSelectNotification(String payload) {
//    showDialog(
//      context: context,
//      builder: (_) =>
//          AlertDialog(
//            title: new Text('Notification'),
//            content: Text('$payload'),
//          ),
//    );
//    print('on trigger notification: $payload');
//    if (payload != null && payload.isNotEmpty) {
//      RouterUtils.push(context, AppRouter.orderDetail + '/$payload');
//    }
//  }
}
