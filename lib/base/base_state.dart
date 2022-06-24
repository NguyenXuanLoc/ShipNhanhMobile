// @dart = 2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:smartship_partner/config/router/route_util.dart';
import 'package:smartship_partner/config/router/router.dart';
import 'package:smartship_partner/data/network/response/login/login_response.dart';
import 'package:smartship_partner/ui/home/home_page.dart';
import 'package:smartship_partner/ui/notification/notification.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/progress_hud.dart';
import 'package:visibility_detector/visibility_detector.dart';

abstract class BaseState<T extends StatefulWidget> extends BaseSetState<T> {
  ProgressHUD progressHUD;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterFirstLayout(context));
//    progressHUD = ProgressHUD(
//        backgroundColor: Colors.black12,
//        color: Colors.white,
//        containerColor: colorPrimary,
//        borderRadius: ScreenUtil().setWidth(20));
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  afterFirstLayout(BuildContext context) {}
}

abstract class BaseSetState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }
}

abstract class BaseOrderState<T extends StatefulWidget> extends BaseState<T> {
  static String pendingOrderId;
  StreamSubscription<NotificationTriggeredEBEvent> _newNotificationStream;
  bool _firstVisible = true;
  Key _key;
  double _visibleFraction = 0;
  bool focusGained = false;

  // Vital for identifying our FocusDetector when a rebuild occurs.
  final Key _focusDetectorKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _key = Key(hashCode.toString());
    _setupHandleOpenNotification();
  }

//  @override
//  Widget build(BuildContext context) {
//    return VisibilityDetector(
//      child: getLayout(context),
//      key: _key,
//      onVisibilityChanged: (info) {
//        _visibleFraction = info.visibleFraction;
//        print('visibleChanged: $_visibleFraction} ${runtimeType}');
//        if (isVisible() && _firstVisible) {
//          _firstVisible=false;
//          onFirstVisible();
//        }
//      },
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      key: _focusDetectorKey,
      child: getLayout(context),
      onFocusGained: () {
        print('focus Gained: $runtimeType');
        onFocusGained();
      },
      onFocusLost: () {
        print('focus Lost: $runtimeType');
        focusGained = false;
      },
    );
  }

  /// on Focus gained on this screen
  void onFocusGained() async {
    print('focus gained on $runtimeType');
    focusGained = true;
    if (_firstVisible) {
      _firstVisible = false;
      onFirstVisible();
    } else {
      if (pendingOrderId != null && pendingOrderId.isNotEmpty) {
        RouterUtils.push(context, AppRouter.orderDetail + '/$pendingOrderId');
        pendingOrderId = null;
      }
    }
  }

  /// Getlayout of the page
  Widget getLayout(BuildContext context);

  void _setupHandleOpenNotification() {
    _newNotificationStream =
        Utils.eventBus.on<NotificationTriggeredEBEvent>().listen((event) {
      String orderId = event.orderId ?? '';
      debugPrint('orderId: $orderId} visible: ${isVisible()}');
      if (orderId.isEmpty) return;
      if (isVisible()) {
        print('p: $orderId ' + this.runtimeType.toString());
        RouterUtils.push(context, AppRouter.orderDetail + '/$orderId');
        pendingOrderId = null;
      } else {
        if (runtimeType == HomePageState) {
          pendingOrderId = orderId;
        }
      }
    });
  }

  /// Detect current page is show on screen or not
  bool isVisible() {
    return mounted && focusGained;
  }

  @override
  void dispose() {
    _newNotificationStream?.cancel();
    super.dispose();
  }

  /// Called when the view is completed shown on screen for the first time
  void onFirstVisible() {}
}
