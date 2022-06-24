// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/config/router/route_util.dart';
import 'package:smartship_partner/config/router/router.dart';
import 'package:smartship_partner/data/local/db/entity/notification_entity.dart'
    as notifyEntity;
import 'package:smartship_partner/ui/notification/notification.dart';
import 'package:smartship_partner/util/date_time_utils.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/app_bar_widget.dart';
import 'package:smartship_partner/widget/custom_listTile.dart';
import '../../base/base_state.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends BaseState<NotificationPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  final _bloc = NotificationBloc(NotificationStartState());

  List<notifyEntity.Notification> _notificationList = [];

  @override
  void initState() {
    super.initState();
    /* handle Result */
    _setupHandleData();
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  void _setupHandleData() {
    /* handle Result */
    Utils.eventBus.on<NotificationLoadedEvent>().listen((event) {
      var data = event.data;
      _refreshController.refreshCompleted();
      var temp = _notificationList;
      _notificationList.clear();
      if (data != null) {
        _notificationList.addAll(data);
      }
      setState(() {
        _notificationList = temp;
      });
    });

    /* handle new notification */
    Utils.eventBus.on<NewNotificationEBEvent>().listen((event) {
      var temp = _notificationList;
      temp.insert(0, event.notification);
      setState(() {
        _notificationList = temp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 667, allowFontScaling: true);
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: AppBarWidget(
        title: AppTranslations.of(context).text('notification'),
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          return _buildNotificationList();
        },
      ),
    );
  }

  Widget _buildNotificationList() {
    bool empty = _notificationList.isEmpty;
    return SmartRefresher(
      header: MaterialClassicHeader(),
      onRefresh: _onReload,
      controller: _refreshController,
      child: ListView.separated(
          itemBuilder: (context, index) {
            return empty
                ? _emptyView()
                : _buildNotificationItem(index, _notificationList[index]);
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 2,
              color: AppColors.colorAccent,
            );
          },
          itemCount: empty ? 1 : _notificationList.length),
    );
  }

  Widget _buildNotificationItem(int index, notifyEntity.Notification item) {
    return Container(
      color: item.read == 1 ? AppColors.colorWhite : AppColors.colorWhiteFade,
      child: InkWell(
        onTap: () {
          _onNotificationClicked(index, item);
        },
        child: CustomListTile(
          height: ScreenUtil().setHeight(70),
          title: Text(
            DateTimeUtil.dateMillisToString(
                item.time, DateTimeUtil.FULL_DATE_FORMAT),
            style: TextStyle(
                fontSize: FontConfig.font_small,
                fontWeight: FontWeight.bold,
                color: item.read == 1
                    ? AppColors.colorGrey
                    : AppColors.colorNavyDark),
          ),
          subtitle: Text(item.message ?? '',
              maxLines: 2,
              style: TextStyle(
                color: item.read == 1
                    ? AppColors.colorGrey
                    : AppColors.colorNavyDark,
                fontWeight: FontWeight.bold,
                fontSize: FontConfig.font_medium,
              )),
//      RichText(
//        text: TextSpan(
//          children: [
//            TextSpan(text: 'Đơn ', style: _notifyItemStyle),
//            TextSpan(
//                text: '12345 ',
//                style: _notifyItemStyle.copyWith(color: AppColors.colorCyan)),
//            TextSpan(text: item.message ?? '', style: _notifyItemStyle)
//          ],
//        ),
//      ),
        ),
      ),
    );
  }

  _emptyView() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        AppTranslations.of(context).text('notification_empty'),
        style: TextStyle(
            color: AppColors.colorGrey, fontSize: FontConfig.font_medium),
      ),
    );
  }

  _setReadNotification(int index, int notificationId) async {
    _bloc.add(NotificatioReadEvent(notificationId));
    var valid = _notificationList.length > index;
    if (valid) {
      if (mounted) {
        setState(() {
          _notificationList[index].read = 1;
        });
      } else {
        _notificationList[index].read = 1;
      }
    }
  }

  /// Reload Notification list from database
  void _onReload([bool force = false]) async {
    print('notification reload: $force');
    if (force) {
      _refreshController.requestRefresh();
      return;
    } else {
      print('load notifications');
      _bloc.add(NotificationStartEvent());
    }
  }

  /// When click on notificaiton, mark it as read and open order detail
  _onNotificationClicked(
      int index, notifyEntity.Notification notification) async {
    print('_onNotificationClicked $index');
    // Mark notification as read
    _setReadNotification(index, notification.id);

    // Open order detail
    if (notification.orderId != null && notification.orderId.isNotEmpty) {
      RouterUtils.push(
          context, AppRouter.orderDetail + '/' + notification.orderId);
    }
  }
}
