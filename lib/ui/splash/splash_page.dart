// @dart = 2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/config/router/route_util.dart';
import 'package:smartship_partner/config/router/router.dart';
import 'package:smartship_partner/eventbus/event_bus_splash_event.dart';
import 'package:smartship_partner/ui/splash/splash.dart';
import 'package:smartship_partner/util/date_time_utils.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/area/area_select_dialog.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();

  SplashPage() {
    print('splash page');
  }
}

class _SplashPageState extends State<SplashPage> {
  final _splashBloc = SplashBloc(StartSplashState());
  var _loggedIn = true;
  StreamSubscription<SplashUserLoggedInEvent> _loggedStream;
  StreamSubscription<SplashNotSelectAreaEvent> _areaStream;

  @override
  void initState() {
    super.initState();
    _handleEventBusEvent();
    startLoading();
  }

  void _handleEventBusEvent() {
    _loggedStream =
        Utils.eventBus.on<SplashUserLoggedInEvent>().listen((event) {
      setState(() {
        print('loggedin ${event.loggedIn}');
        _loggedIn = event.loggedIn;
        if (_loggedIn) {
          _enterHomeScreen();
        }
      });
    });

    _areaStream = Utils.eventBus.on<SplashNotSelectAreaEvent>().listen((event) async {
      debugPrint('xxxxxxxxxxxxxx');
      if (!event.selectArea) {
        /// Area not selected, show dialog
        var area = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AreaSelectDialog(event.configList);
            });
        /// after select area, request for continue
        _splashBloc.add(SplashSelectedAreaEvent(area));
      }
    });
  }

  void startLoading() {
    Timer(Duration(seconds: 1), () {
      _splashBloc.add(SplashStartEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 667, allowFontScaling: true);
    return Scaffold(
      body: BlocListener(
          bloc: _splashBloc,
          listener: (context, state) {},
          child: BlocBuilder(
            bloc: _splashBloc,
            builder: (context, state) {
              return _buildSplashScreen();
            },
          )),
    );
  }

  Widget _buildSplashScreen() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assets/images/phone/im_splash.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Logo
              SizedBox(
                height: 144,
              ),
//              Container(
//                child: Image.asset(
//                  'assets/images/phone/im_splash_icon.png',
//                  width: ScreenUtil().setWidth(99),
//                  height: ScreenUtil().setWidth(99),
//                ),
//                margin: EdgeInsets.only(
//                    top: (MediaQuery
//                        .of(context)
//                        .size
//                        .height / 5), bottom: 30),
//              ),
              Text(
                AppTranslations.of(context).text('splash_title'),
                style: TextStyle(
                    fontFamily: FontConfig.fontFutura,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(45),
                    color: AppColors.colorWhite),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                AppTranslations.of(context).text('splash_slogan'),
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(FontConfig.font_large),
                    color: AppColors.colorWhite),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil().setHeight(50),
                    ),
                    _loggedIn

                        ///LoggedIn show indicator
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.colorWhite),
                          )
                        : Container(
                            width: ScreenUtil().setWidth(339),
                            height: ScreenUtil().setHeight(67),
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            child: RaisedButton(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 20, bottom: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: _goToLoginScreen,
                              color: Colors.white,
                              textColor: AppColors.colorPrimary,
                              child: Text(
                                AppTranslations.of(context)
                                    .text('login_with_phone'),
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(FontConfig.font_large),
                                    color: AppColors.colorPrimary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  AppTranslations.of(context).text('power_by'),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(FontConfig.font_medium),
                      color: Colors.white),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _goToLoginScreen() async {
    await RouterUtils.push(context, AppRouter.login);
    // back from login, re-check
    startLoading();
  }

  void _enterHomeScreen() {
    RouterUtils.push(context, AppRouter.home, true);
  }

  @override
  void dispose() {
    if (_splashBloc != null) _splashBloc.close();
    _loggedStream?.cancel();
    _areaStream?.cancel();
    super.dispose();
  }
}
