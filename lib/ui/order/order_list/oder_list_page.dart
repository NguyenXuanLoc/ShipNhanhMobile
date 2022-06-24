// @dart = 2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/config/router/route_util.dart';
import 'package:smartship_partner/config/router/router.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/model/order_info.dart';
import 'package:smartship_partner/data/model/order_item_model.dart';
import 'package:smartship_partner/data/model/order_status.dart';
import 'package:smartship_partner/ui/home/home_event.dart';
import 'package:smartship_partner/ui/notification/notification.dart';
import 'package:smartship_partner/ui/order/order_list/order_list_bloc.dart';
import 'package:smartship_partner/ui/order/order_list/order_list_event.dart';
import 'package:smartship_partner/ui/order/order_list/order_list_state.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/popup_menu.dart';
import 'package:smartship_partner/widget/order_list_item.dart';
import 'package:smartship_partner/widget/progress_hud.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  StreamSubscription<NewNotificationEBEvent> _newNotificationEvent;
  StreamSubscription<OrderCreatedHomeEvent> _orderCreatedEvent;
  final _orderListBloc = OrderListBloc();
  final _scrollController = ScrollController();
  GlobalKey filterPopupKey = GlobalKey();
  PopupMenu filterPopup;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  GlobalKey createOrderPopupKey = GlobalKey();
  PopupMenu createOrderPopup;

  bool _hasNotification = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _orderListBloc..add(OrderListStarted(initialStatus: OrderStatus.ALL));
    _setupHandleNewNotification();
    _setupHandleNewOrderCreated();
  }

  @override
  void dispose() {
    super.dispose();
    _orderListBloc.close();
    _newNotificationEvent?.cancel();
    _orderCreatedEvent?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    PopupMenu.itemWidth = 210.0;
    PopupMenu.itemHeight = 35.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorAppbar,
        elevation: 0.0,
        title: BlocListener<OrderListBloc, OrderListState>(
          bloc: _orderListBloc,
          listener: (context, state) {},
          child: BlocBuilder<OrderListBloc, OrderListState>(
              bloc: _orderListBloc,
              builder: (context, state) {
                var orderTotal = 0;
                var orderStatus = OrderStatus.ALL;
                if (state is OrderListLoaded) {
                  orderTotal = state.orderTotal;
                  orderStatus = state.currentOrderStatus;
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              orderStatus.name(context) +
                                  ' $orderTotal ' +
                                  AppTranslations.of(context)
                                      .text('order_simple')
                                      .toLowerCase() +
                                  ' ',
                              maxLines: 1,
                              style: TextStyle(
                                  color: AppColors.colorAccent,
                                  fontSize: ScreenUtil()
                                      .setSp(FontConfig.font_very_large),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Quicksand'),
                              overflow: TextOverflow.ellipsis),
                          Container(
                            key: filterPopupKey,
                            child: SvgPicture.asset(
                                'assets/images/phone/ic_expand_more.svg'),
                          )
                        ],
                      ),
                      onTap: () {
                        _showFilterPopup(context, orderStatus);
                      },
                    ),
                    Expanded(
                      child: Container(),
                    )
                  ],
                );
              }),
        ),
        actions: <Widget>[
          ///Not show this button anymore
          // Container(
          //   alignment: Alignment.center,
          //   margin: const EdgeInsets.only(right: 15),
          //   padding: const EdgeInsets.only(top: 10, bottom: 10),
          //   child: FlatButton.icon(
          //     key: createOrderPopupKey,
          //     icon: Icon(
          //       Icons.add,
          //       color: AppColors.colorWhite,
          //     ),
          //     color: AppColors.colorPrimary,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     onPressed: () {
          //       _showCreateOrderPopup();
          //     },
          //     label: Text(
          //       AppTranslations.of(context).text('create_order'),
          //       style: TextStyle(
          //           fontSize: ScreenUtil().setSp(FontConfig.font_medium),
          //           color: AppColors.colorWhite,
          //           fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // )
        ],
      ),
      body: BlocListener<OrderListBloc, OrderListState>(
          bloc: _orderListBloc,
          listener: (context, state) {},
          child: Stack(
            children: [
              BlocBuilder<OrderListBloc, OrderListState>(
                bloc: _orderListBloc,
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case OrderListUninitialized:
                      return Container();
                    case OrderListError:
                      _refreshController.refreshFailed();
                      return Container(
                        decoration:
                            BoxDecoration(color: AppColors.colorGreyLight),
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            AppTranslations.of(context)
                                .text('failed_to_fetch_order_list'),
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.colorAccent),
                          ),
                        ),
                      );
                    case OrderListLoaded:
                      _refreshController.refreshCompleted();
                      var stateLoaded = state as OrderListLoaded;
                      if (stateLoaded.orderTotal == 0) {
                        return Container(
                          decoration:
                              BoxDecoration(color: AppColors.colorWhite),
                          alignment: Alignment.center,
                          child: Text(
                            AppTranslations.of(context).text('no_orders'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize:
                                    ScreenUtil().setSp(FontConfig.font_huge),
                                fontWeight: FontWeight.bold,
                                color: AppColors.colorBlackFade),
                          ),
                        );
                      }
                      final orderList = stateLoaded.orderList;
                      return _getOrderListWidget(orderList, context);
                    default:
                      return ProgressHUD();
                  }
                },
              ),

              /// Thông báo có đơn mới
              Align(
                alignment: Alignment.topCenter,
                child: Visibility(
                  visible: _hasNotification,
                  child: MaterialButton(
                    onPressed: () {
                      _onReload(true);
                    },
                    elevation: 2,
                    color: AppColors.colorWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(40)),
                    ),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            color: AppColors.colorAccent,
                            size: ScreenUtil().setWidth(15),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(10),
                          ),
                          Text(
                            AppTranslations.of(context).text('refresh_orders'),
                            style: TextStyle(
                                color: AppColors.colorBlack,
                                fontSize:
                                    ScreenUtil().setSp(FontConfig.font_medium)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  void _onReload([bool force = false]) {
    setState(() {
      _hasNotification = false;
    });
    if (force) {
      _refreshController.requestRefresh();
      return;
    } else {
      _orderListBloc.add(OrderListRefresh());
    }
  }

  Widget _getOrderListWidget(
      List<OrderItemModel> orderList, BuildContext context) {
    return Container(
        color: AppColors.colorAppbar,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SmartRefresher(
          header: MaterialClassicHeader(),
          onLoading: () => {},
          onRefresh: _onReload,
          controller: _refreshController,
          child: ListView.builder(
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              return OrderListItem(
                  orderItem: orderList[index],
                  onOrderItemClicked: (orderInfo) => {_goToDetail(orderInfo)});
            },
            controller: _scrollController,
          ),
        ));
  }

  void _goToDetail(OrderItemModel orderItem) async {
    var data = await RouterUtils.push(context,
        AppRouter.orderDetail + '/' + orderItem.orderId.toString(), false);

    var shouldReload = data[0] ?? false;

    _onReload(shouldReload);
  }

  void onClickMenu(MenuItemProvider item) {
    if (item.menuTitle == AppTranslations.of(context).text('all')) {
      _orderListBloc..add(ChangeOrderStatus(newOrderStatus: OrderStatus.ALL));
    } else if (item.menuTitle ==
        AppTranslations.of(context).text('new_order')) {
      _orderListBloc..add(ChangeOrderStatus(newOrderStatus: OrderStatus.OPEN));
    } else if (item.menuTitle ==
        AppTranslations.of(context).text('ready_to_deliver_order')) {
      _orderListBloc
        ..add(ChangeOrderStatus(newOrderStatus: OrderStatus.READY_TO_DELIVER));
    } else if (item.menuTitle ==
        AppTranslations.of(context).text('delivering_order')) {
      _orderListBloc
        ..add(ChangeOrderStatus(newOrderStatus: OrderStatus.DELIVERING));
    } else if (item.menuTitle ==
        AppTranslations.of(context).text('delivered_order')) {
      _orderListBloc
        ..add(ChangeOrderStatus(newOrderStatus: OrderStatus.DELIVERED));
    }
    if (item.menuTitle ==
        AppTranslations.of(context).text('create_order_normal')) {
      _enterCreateOrder(CreateOrderCategory.TYPE_SHIP);
    }
    if (item.menuTitle ==
        AppTranslations.of(context).text('create_order_buy')) {
      _enterCreateOrder(CreateOrderCategory.TYPE_BUY);
    }
    if (item.menuTitle ==
        AppTranslations.of(context).text('create_order_grab')) {
      _enterCreateOrder(CreateOrderCategory.TYPE_GRAB);
    }
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _orderListBloc.add(OrderListFetch());
    }
  }

  void _showFilterPopup(BuildContext context, OrderStatus orderStatus) {
    filterPopup = PopupMenu(
      backgroundColor: AppColors.colorWhite,
      maxColumn: 1,
      lineColor: AppColors.colorTransparent,
      highlightColor: AppColors.colorTransparent,
      paddingLeft: 15.0,
      paddingRight: 11.4,
      menuType: MenuType.oneLine,
      panelLeft: 72.5,
      onClickMenu: onClickMenu,
      items: [
        MenuItem(
          title: AppTranslations.of(context).text('all'),
          image: SvgPicture.asset(
            'assets/images/phone/ic_all_order.svg',
            width: 13.35,
            height: 14.31,
          ),
          textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          checkSymbol: _checkSymbol(orderStatus.value == OrderStatus.ALL.value,
              (isSelected) {
            _orderListBloc
              ..add(ChangeOrderStatus(newOrderStatus: OrderStatus.ALL));
            filterPopup.dismiss();
          }),
        ),
        MenuItem(
            title: AppTranslations.of(context).text('new_order'),
            image: SvgPicture.asset(
              'assets/images/phone/ic_new_order.svg',
              width: 21.0,
              height: 14.87,
            ),
            textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            checkSymbol: _checkSymbol(
                orderStatus.value == OrderStatus.OPEN.value, (isSelected) {
              _orderListBloc
                ..add(ChangeOrderStatus(newOrderStatus: OrderStatus.OPEN));
              filterPopup.dismiss();
            })),
        MenuItem(
            title: AppTranslations.of(context).text('ready_to_deliver_order'),
            image: SvgPicture.asset(
              'assets/images/phone/ic_waiting_order.svg',
              width: 13.15,
              height: 15.43,
            ),
            textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            checkSymbol: _checkSymbol(
                orderStatus.value == OrderStatus.READY_TO_DELIVER.value,
                (isSelected) {
              _orderListBloc
                ..add(ChangeOrderStatus(
                    newOrderStatus: OrderStatus.READY_TO_DELIVER));
              filterPopup.dismiss();
            })),
        MenuItem(
            title: AppTranslations.of(context).text('delivering_order'),
            image: SvgPicture.asset(
              'assets/images/phone/ic_delivering_order.svg',
              width: 17.35,
              height: 12.03,
            ),
            textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            checkSymbol:
                _checkSymbol(orderStatus.value == OrderStatus.DELIVERING.value,
                    (isSelected) {
              _orderListBloc
                ..add(
                    ChangeOrderStatus(newOrderStatus: OrderStatus.DELIVERING));
              filterPopup.dismiss();
            })),
        MenuItem(
            title: AppTranslations.of(context).text('delivered_order'),
            image: SvgPicture.asset(
              'assets/images/phone/ic_delivered_order.svg',
              width: 14.64,
              height: 14.64,
            ),
            textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            checkSymbol: _checkSymbol(
                orderStatus.value == OrderStatus.DELIVERED.value, (isSelected) {
              _orderListBloc
                ..add(ChangeOrderStatus(newOrderStatus: OrderStatus.DELIVERED));
              filterPopup.dismiss();
            })),
      ],
    );
    filterPopup.show(widgetKey: filterPopupKey);
  }

  void _showCreateOrderPopup() {
    createOrderPopup = PopupMenu(
      backgroundColor: AppColors.colorWhite,
      maxColumn: 1,
      lineColor: AppColors.colorTransparent,
      highlightColor: AppColors.colorTransparent,
      menuType: MenuType.oneLine,
      onClickMenu: onClickMenu,
      items: [
        MenuItem(
          title: AppTranslations.of(context).text('create_order_normal'),
          image: SvgPicture.asset(
            'assets/images/phone/ic_order_ship.svg',
            width: 13.35,
            height: 14.31,
          ),
          textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        MenuItem(
          title: AppTranslations.of(context).text('create_order_buy'),
          image: SvgPicture.asset(
            'assets/images/phone/ic_order_buy.svg',
            width: 21.0,
            height: 14.87,
          ),
          textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        MenuItem(
          title: AppTranslations.of(context).text('create_order_grab'),
          image: SvgPicture.asset(
            'assets/images/phone/ic_order_grab.svg',
            width: 13.15,
            height: 15.43,
          ),
          textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
    createOrderPopup.show(widgetKey: createOrderPopupKey);
  }

  Widget _checkSymbol(bool value, Function(bool) onTap) {
    return RoundCheckBox(
      isChecked: value,
      onTap: onTap,
      checkedWidget:
//      SvgPicture.asset(
//        'assets/images/phone/ic_check_outline.svg',
//          color: AppColors.colorAccent,
//        height: 14.64,
//        width: 14.64,
//      )
          Icon(
        Icons.check_circle_outline,
        color: AppColors.colorAccent,
        size: 25.0,
      ),
      uncheckedWidget: Icon(
        Icons.radio_button_unchecked,
        color: AppColors.colorAccent,
      ),
      checkedColor: AppColors.colorTransparent,
      uncheckedColor: AppColors.colorTransparent,
      size: 25.0,
      borderColor: AppColors.colorTransparent,
    );
  }

  void _enterCreateOrder(
      [int orderType = CreateOrderCategory.TYPE_SHIP]) async {
    var created = await RouterUtils.push(
            context,
            AppRouter.createOrder +
                '/' +
                CreateOrderStatus.TYPE_NEW.toString() +
                '/' +
                orderType.toString(),
            false) ??
        false;
    _onReload(created);
  }

  void _setupHandleNewNotification() {
    _newNotificationEvent =
        Utils.eventBus.on<NewNotificationEBEvent>().listen((event) {
      debugPrint(
          'new notification: ${event?.notification?.orderId} mounted: $mounted');
      if (int.parse(event?.notification?.orderId ?? '0') <= 0)
        return; // Đơn ko có orderId thì ko xử lý

      if (mounted) {
        setState(() {
          _hasNotification = true;
        });
      } else {
        _hasNotification = true;
      }
    });
  }

  void _setupHandleNewOrderCreated() {
    _orderCreatedEvent =
        Utils.eventBus.on<OrderCreatedHomeEvent>().listen((event) {
      _onReload(event.created);
    });
  }
}
