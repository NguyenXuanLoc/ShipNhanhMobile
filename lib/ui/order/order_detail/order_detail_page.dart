// @dart = 2.9
import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartship_partner/base/base_state.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/config/router/route_util.dart';
import 'package:smartship_partner/config/router/router.dart';
import 'package:smartship_partner/data/model/order/new_order.dart';
import 'package:smartship_partner/data/model/order_info.dart';
import 'package:smartship_partner/data/model/order_status.dart';
import 'package:smartship_partner/data/model/order_type.dart';
import 'package:smartship_partner/ui/notification/notification.dart';
import 'package:smartship_partner/ui/order/order_detail/rate_order_page.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/alert_dialog_two_button.dart';
import 'package:smartship_partner/widget/app_bar_icon.dart';
import 'package:smartship_partner/widget/long_button.dart';
import 'package:smartship_partner/widget/order_contact.dart';
import 'package:smartship_partner/widget/order_status_bar.dart';
import 'package:smartship_partner/widget/progress_hud.dart';
import 'package:smartship_partner/widget/step_progress_bar.dart';
import 'package:smartship_partner/ui/order/order_detail/order_detail_bloc.dart';
import 'package:smartship_partner/ui/order/order_detail/order_detail_event.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'order_detail_state.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;

  OrderDetailPage({@required this.orderId});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends BaseOrderState<OrderDetailPage> {
  final _orderInfoBloc = OrderInfoBloc();
  OrderInfoModel orderInfo;
  var _shouldReloadList = false;
  var _pendingLoad = false;

  _OrderDetailPageState();

  StreamSubscription<NewNotificationEBEvent> _streamNotification;

  @override
  void initState() {
    super.initState();
    if (widget.orderId.toString() == BaseOrderState.pendingOrderId) {
      // current order is the pending one, so clear the pending
      BaseOrderState.pendingOrderId = null;
    }
    _handleNotification();
    _pendingLoad = false;
    _orderInfoBloc..add(Fetch(orderId: widget.orderId));
  }

  @override
  void dispose() {
    super.dispose();
    _streamNotification?.cancel();
    _orderInfoBloc.close();
  }

  @override
  Widget getLayout(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 667, allowFontScaling: true);
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      statusBarColor: Colors.black, //or set color with: Color(0xFF0000FF)
//    ));

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, [_shouldReloadList]);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.colorAppBgr,
        appBar: AppBar(
          backgroundColor: AppColors.colorAppbar,
          centerTitle: true,
          elevation: 0.0,
          leading: AppBarIcon(
            onPressed: () {
              Navigator.pop(context, [_shouldReloadList]);
            },
          ),
          actions: <Widget>[
            BlocListener<OrderInfoBloc, OrderInfoState>(
                bloc: _orderInfoBloc,
                listener: (context, state) {},
                child: BlocBuilder<OrderInfoBloc, OrderInfoState>(
                    bloc: _orderInfoBloc,
                    builder: (context, state) {
                      if (state is OrderInfoLoaded) {
                        orderInfo = state.orderInfo;

                        if (orderInfo.orderStatus == OrderStatus.OPEN) {
                          return Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 15),
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: RaisedButton(
                              color: AppColors.colorAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: () {
                                _goToUpdateOrderPage(orderInfo, context);
                              },
                              child: Text(
                                AppTranslations.of(context).text('edit'),
                                style: TextStyle(
                                    color: AppColors.colorWhite,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }
                      }

                      return Container();
                    }))
          ],
          title: Text(
            AppTranslations.of(context).text('order_detail'),
            style: TextStyle(color: AppColors.colorAccent),
          ),
        ),
        body: BlocListener<OrderInfoBloc, OrderInfoState>(
          bloc: _orderInfoBloc,
          listener: (context, state) {
            if (state is CanceledOrder) {
              Navigator.pop(context, [true]);
            } else if (state is CancelOrderFail) {
              var msg = state.message;
              final snackBar = SnackBar(
                  content: Text(
                      '${AppTranslations.of(context).text('cancel_order_failed')}. \n$msg'));
              Scaffold.of(context).showSnackBar(snackBar);
            }
          },
          child: BlocBuilder<OrderInfoBloc, OrderInfoState>(
            bloc: _orderInfoBloc,
            builder: (context, state) {
              if (state is OrderInfoError) {
                return Container(
                  child: Text(
                      AppTranslations.of(context).text('load_order_failed')),
                );
              } else if (state is OrderInfoUninitialized) {
                return ProgressHUD();
              } else if (state is CanceledOrder) {
                return Container();
              } else if (state is CancelOrderFail) {
                var oi = state.orderInfo;
                if (oi != null) {
                  return _getOrderInfoWithStatus(orderInfo);
                } else {
                  return Container();
                }
              }
              orderInfo = (state as OrderInfoLoaded).orderInfo;

              return _getOrderInfoWithStatus(orderInfo);
            },
          ),
        ),
      ),
    );
  }

  void _showNoteList() async {
    var stringToBase64Url = utf8.fuse(base64Url);
    var orderJson = orderInfoToJson(orderInfo);
    await RouterUtils.push(context,
        AppRouter.noteList + '/' + stringToBase64Url.encode(orderJson));
  }

  Widget _getOrderInfoWithStatus(OrderInfoModel orderInfo) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            color: AppColors.colorAppbar,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  StepProgressBar(
                    activeColor: AppColors.colorAccent,
                    inactiveColor: AppColors.colorWhite,
                    width: double.infinity,
                    curStep: _getProgressStep(orderInfo),
                    icons: [
                      StepIcon(
                          path: 'assets/images/phone/ic_step_new.svg',
                          stepIconType: StepIconType.assetSvg),
                      StepIcon(
                          path: 'assets/images/phone/ic_step_timer.svg',
                          stepIconType: StepIconType.assetSvg),
                      StepIcon(
                          path: 'assets/images/phone/ic_step_truck.svg',
                          stepIconType: StepIconType.assetSvg),
                      StepIcon(
                          path: 'assets/images/phone/ic_check_outline.svg',
                          stepIconType: StepIconType.assetSvg),
                    ],
                  ),
                  _buildOrderDetail(orderInfo),
                ],
              ),
            ),
          ),
        ),
        _bottomLayout(orderInfo)
      ],
    );
  }

  int _getProgressStep(OrderInfoModel orderInfo) {
    var temp = orderInfo.orderStatus.value + 1;
    return temp > 4 ? 4 : temp;
  }

  Widget _buildOrderDetail(OrderInfoModel orderInfo) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Card(
        elevation: 0,
        color: AppColors.colorWhite,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.colorGreyStroke, width: 1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Header
            Container(
              height: 29,
              decoration: BoxDecoration(
                  color: AppColors.colorYellowLight,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7))),
              child: Stack(
                alignment: const Alignment(0.0, 0.0),
                children: <Widget>[
                  OrderStatusBar(
                    orderStatus: orderInfo.orderStatus,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      _showOrderMonitor(orderInfo);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/images/phone/ic_location.svg',
                          color: AppColors.colorAccent,
                          height: 12,
                          width: 12,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          AppTranslations.of(context).text('maps'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: FontConfig.font_small),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 11),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            /// Base Info
            _widgetOrderInfo(orderInfo),
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              width: double.infinity,
              color: AppColors.colorGreyLight,
              height: 2,
            ),
            _moreInfo(orderInfo, context)
          ],
        ),
      ),
    );
  }

  void _showOrderMonitor(OrderInfoModel orderInfo) async {
    var stringToBase64Url = utf8.fuse(base64Url);
    var orderJson = orderInfoToJson(orderInfo);
    await RouterUtils.push(context,
        AppRouter.orderMonitor + '/' + stringToBase64Url.encode(orderJson));

    // check notification
    if (_pendingLoad) {
      _pendingLoad = false;
      _orderInfoBloc..add(Fetch(orderId: widget.orderId));
    }
  }

  Widget _widgetOrderInfo(OrderInfoModel orderInfo) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  if (orderInfo.orderPicUrl.isNotEmpty) {
                    _showImageFull(orderInfo.orderPicUrl);
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: AppColors.colorGreyLight),
                    child: CachedNetworkImage(
                        imageUrl: orderInfo.orderPicUrl,
                        placeholder: (context, url) => SvgPicture.asset(
                              'assets/images/phone/ic_picture.svg',
                              color: AppColors.colorGreyStroke,
                            )),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// Mã đơn
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: '#${orderInfo.orderId} - ',
                          style: _textLabelStyle),
                      TextSpan(
                          text: '${orderInfo.orderType.name(context)}',
                          style: _textContentStyle)
                    ]),
                  ),
                  SizedBox(
                    height: 7,
                  ),

                  /// Phí
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: '${AppTranslations.of(context).text('fee')} : ',
                          style: _textLabelStyle),
                      TextSpan(
                          text:
                              '${Utils.formatCurrency(context).format(orderInfo.deliverFee)}',
                          style: _textContentStyle)
                    ]),
                  ),
                  SizedBox(
                    height: 7,
                  ),

                  /// Tiền hàng
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text:
                              '${AppTranslations.of(context).text('order_amount')}: ',
                          style: _textLabelStyle),
                      TextSpan(
                          text:
                              '${Utils.formatCurrency(context).format(orderInfo.orderPrice)}',
                          style: _textContentStyle)
                    ]),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 7,
          ),

          /// ĐIểm đi
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: '${AppTranslations.of(context).text('from_place')}: ',
                  style: _textLabelStyle),
              TextSpan(
                  text: '${orderInfo.supplier.location.address ?? ''}',
                  style: _textContentStyle)
            ]),
          ),
          SizedBox(
            height: 7,
          ),

          /// Liên hệ lấy hàng
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                _getFromContact(orderInfo.orderType),
                style: _textLabelStyle,
              ),
              SizedBox(
                width: 10,
              ),
              orderInfo.supplier.displayName != null
                  ? OrderContact(
                      name: orderInfo.supplier.displayName,
                      phone: orderInfo.supplier.phone,
                    )
                  : Text(
                      AppTranslations.of(context).text('no_contact'),
                      style: _textInActiveStyle,
                    )
            ],
          ),
          SizedBox(
            height: 7,
          ),

          /// Điểm đến
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: '${AppTranslations.of(context).text('to_place')} : ',
                  style: _textLabelStyle),
              TextSpan(
                  text: '${orderInfo.receiver.location.address ?? ''}',
                  style: _textContentStyle)
            ]),
          ),
          SizedBox(
            height: 7,
          ),

          /// Liên hệ giao hàng
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                _getToContact(orderInfo.orderType),
                style: _textLabelStyle,
              ),
              SizedBox(
                width: 10,
              ),
              orderInfo.receiver.displayName != null
                  ? OrderContact(
                      name: orderInfo.receiver.displayName,
                      phone: orderInfo.receiver.phone,
                    )
                  : Text(
                      AppTranslations.of(context).text('no_contact'),
                      style: _textInActiveStyle,
                    )
            ],
          ),
          SizedBox(
            height: 7,
          ),

          /// Ghi chú
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${AppTranslations.of(context).text('note')}: ',
                style: _textLabelStyle,
              ),
              orderInfo.description != null && orderInfo.description.isNotEmpty
                  ? Expanded(
                      child: InkWell(
                        onTap: () async {
                          await _showNoteList();
                        },
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(children: [
                            TextSpan(
                                text: '${orderInfo.description} ',
                                style: _textContentStyle),
                            TextSpan(
                                text: AppTranslations.of(context)
                                    .text('see_more'),
                                style: TextStyle(
                                    color: AppColors.colorAccent,
                                    fontSize: FontConfig.font_normal,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold))
                          ]),
                        ),
                      ),
                    )
                  : Text(
                      AppTranslations.of(context).text('none'),
                      style: _textInActiveStyle,
                    ),
            ],
          )
        ],
      ),
    );
  }

  String _getFromContact(OrderType orderType) {
    return orderType == OrderType.SHIPPER
        ? AppTranslations.of(context).text('contact')
        : AppTranslations.of(context).text('from_contact');
  }

  String _getToContact(OrderType orderType) {
    return orderType == OrderType.SHIPPER
        ? AppTranslations.of(context).text('contact')
        : AppTranslations.of(context).text('to_contact');
  }

  Widget _moreInfo(OrderInfoModel orderInfo, BuildContext context) {
    return Row(
      children: <Widget>[
        FlatButton.icon(
            onPressed: () {
              _shareOrder(orderInfo, context);
            },
            icon: SvgPicture.asset('assets/images/phone/ic_share.svg'),
            label: Text(
              AppTranslations.of(context).text('share'),
              style: _textLabelStyle,
            )),
        orderInfo.verifyPictureUrl != null &&
                orderInfo.verifyPictureUrl.isNotEmpty
            ? FlatButton.icon(
                onPressed: () {
                  _showImageFull(orderInfo.verifyPictureUrl);
                },
                icon: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                  child: Image.network(
                    '${orderInfo.verifyPictureUrl}',
                    width: 23,
                    height: 19,
                    fit: BoxFit.cover,
                  ),
                ),
                label: Text(
                  AppTranslations.of(context).text('description_image'),
                  style: _textLabelStyle,
                ))
            : Container(),
      ],
    );
  }

  /// bottom layout,
  Widget _bottomLayout(OrderInfoModel orderInfo) {
    var shipper = orderInfo.shipper;

    if (orderInfo.orderStatus == OrderStatus.OPEN) {
      return _getBottomButton(orderInfo);
    }

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 6.5),
          width: double.infinity,
          color: AppColors.colorGreyLight,
          height: 2,
        ),
        Container(
          color: AppColors.colorWhite,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppTranslations.of(context).text('driver_info'),
                style: _textLabelStyle,
              ),
              SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () {
                  _enterShipperInfo(shipper.userId);
                },
                child: Row(
                  children: <Widget>[
                    /// Avatar
                    Container(
                      width: 50,
                      height: 50,
                      child: Card(
                        elevation: 5,
                        shape: CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder:
                                'assets/images/phone/ic_place_holder.svg',
                            image: shipper.pictureUrl ?? ''),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),

                    /// Driver Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            shipper.displayName ?? '',
                            style: TextStyle(
                                color: AppColors.colorGrey,
                                fontSize: FontConfig.font_medium,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              RatingBar.builder(
                                initialRating: shipper.rate ?? 0.0,
                                minRating: 1,
                                itemSize: 15,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: AppColors.colorAccent,
                                ),
                                onRatingUpdate: null,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                '(${shipper.totalRates})',
                                style: TextStyle(
                                    fontSize: FontConfig.font_small,
                                    color: AppColors.colorGrey),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),

                    /// Contact
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: RaisedButton(
                        color: AppColors.colorAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () async {
                          if (await canLaunch('tel://${shipper.phone}')) {
                            await launch('tel://${shipper.phone}');
                          }
                        },
                        child: Text(
                          AppTranslations.of(context).text('contact'),
                          style: TextStyle(
                              color: AppColors.colorWhite,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),

              /// Long button
              _getBottomButton(orderInfo)
            ],
          ),
        )
      ],
    );
  }

  Widget _getBottomButton(OrderInfoModel orderInfoModel) {
    var orderStatus = orderInfoModel.orderStatus;

    var buttonText = AppTranslations.of(context).text('rate');
    return BlocListener<OrderInfoBloc, OrderInfoState>(
        bloc: _orderInfoBloc,
        listener: (context, state) {},
        child: BlocBuilder<OrderInfoBloc, OrderInfoState>(
            bloc: _orderInfoBloc,
            builder: (context, state) {
              if (orderStatus == OrderStatus.OPEN) {
                buttonText = AppTranslations.of(context)
                    .text('cancel_order_button_text');
              } else if (orderStatus == OrderStatus.DELIVERED) {
                if (orderInfoModel.rated) {
                  return Container();
                }
              } else {
                return Container();
              }

              return Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: LongButton(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  height: 48,
                  backgroundColor: AppColors.colorAccent,
                  text: buttonText,
                  fontSize: 19,
                  borderRadius: 10,
                  onPressed: () {
                    if (orderInfoModel.orderStatus == OrderStatus.OPEN) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialogTwoButton(
                              title: AppTranslations.of(context)
                                  .text('cancel_order'),
                              message: AppTranslations.of(context).text(
                                  'do_you_really_want_to_cancel_the_order'),
                              onYesClicked: () {
                                _orderInfoBloc
                                  ..add(CancelOrder(
                                      orderId: orderInfoModel.orderId,
                                      reason: 'Some reason'));
                              },
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return RateOrderDialog(
                                onSendRateClicked: (ratingCount, feedback) {
                              _orderInfoBloc
                                ..add(RateOrder(
                                    orderId: orderInfoModel.orderId,
                                    rate: ratingCount,
                                    feedback: feedback));
                            });
                          });
                    }
                  },
                ),
              );
            }));
  }

  void _goToUpdateOrderPage(
      OrderInfoModel orderInfo, BuildContext context) async {
    var stringToBase64Url = utf8.fuse(base64Url);

    var orderRequest = NewOrder(
        notes: orderInfo.description,
        fromAddress: orderInfo.supplier.location.address,
        toAddress: orderInfo.receiver.location.address,
        receiverName: orderInfo.receiver.displayName,
        receiverPhone: orderInfo.receiver.phone,
        amount: orderInfo.orderPrice,
        shipFee: orderInfo.deliverFee,
        category: orderInfo.orderType.value,
        fromLat: orderInfo.supplier.location.lat,
        fromLng: orderInfo.supplier.location.lng,
        toLat: orderInfo.receiver.location.lat,
        toLng: orderInfo.receiver.location.lng,
        isOnbehalf: orderInfo.orderType != OrderType.NORMAL,
        onbehalfName: orderInfo.supplier.displayName,
        onbehalfPhoneNumber: orderInfo.supplier.phone,
        orderId: orderInfo.orderId,
        idShopMall: 0);

    var filePath = ((orderInfo != null && orderInfo.orderPicUrl.isNotEmpty)
        ? stringToBase64Url.encode(orderInfo.orderPicUrl)
        : '');

    var data = await RouterUtils.push(
        context,
        AppRouter.updateOrderStep2 +
            '/' +
            stringToBase64Url.encode(newOrderToJson(orderRequest)) +
            '/' +
            filePath);
    var _shouldReloadList = data[0] ?? false || _pendingLoad;

    if (_shouldReloadList) {
      _pendingLoad = false;
      _orderInfoBloc..add(Fetch(orderId: widget.orderId));
    }
  }

  void _shareOrder(OrderInfoModel orderInfo, BuildContext context) async {
    var msgContent =
        '${orderInfo.orderType.name(context)}. ${AppTranslations.of(context).text('price')}: ${Utils.formatCurrency(context).format(orderInfo.orderPrice)}. ${AppTranslations.of(context).text('fee')}: ${Utils.formatCurrency(context).format(orderInfo.deliverFee)}. ${AppTranslations.of(context).text('from')}: ${orderInfo.supplier.location.address}. ${AppTranslations.of(context).text('to')}: ${orderInfo.receiver.location.address}. ${AppTranslations.of(context).text('call')}: ${orderInfo.receiver.phone}. ${AppTranslations.of(context).text('journey')}: ${orderInfo.orderSharingUrl}';
    try {
      await WcFlutterShare.share(
          sharePopupTitle: AppTranslations.of(context).text('share'),
          subject: AppTranslations.of(context).text('order'),
          text: msgContent,
          mimeType: 'text/plain');
    } catch (e) {
      print(e);
    }
  }

  void _handleNotification() async {
    _streamNotification =
        Utils.eventBus.on<NewNotificationEBEvent>().listen((event) {
      if (widget.orderId.toString() == event.notification.orderId) {
        if (mounted) {
          _pendingLoad = false;
          _orderInfoBloc.add(Fetch(orderId: widget.orderId));
        } else {
          _pendingLoad = true;
        }
      }
    });
  }

  void _enterShipperInfo(int userId) async {
    if (userId != null && userId != 0) {
      RouterUtils.push(context, AppRouter.driveInfo + '/${userId}');
    }
  }

  void _showImageFull(String url) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6),
      // background color
      barrierDismissible: true,
      // should dialog be dismissed when tapped outside
      barrierLabel: "Dialog",
      // label for barrier
      transitionDuration: Duration(milliseconds: 400),
      // how long it takes to popup dialog after button click
      pageBuilder: (context, __, ___) {
        // your widget implementation
        return SafeArea(
          child: SizedBox.expand(
            // makes widget fullscreen
            child: Stack(
              children: [
                Container(
                  child: Center(
                    child: CachedNetworkImage(
                        imageUrl: url,
                        placeholder: (context, url) => ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: Container(
                              width: 200,
                              height: 200,
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: AppColors.colorGreyLight),
                              child: SvgPicture.asset(
                                'assets/images/phone/ic_picture.svg',
                                color: AppColors.colorGreyStroke,
                                height: 100,
                                width: 100,
                              ),
                            ))),
                  ),
                ),

                /// Back button
                Positioned(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: (Icon(
                      Icons.clear,
                      color: AppColors.colorWhite,
                      size: ScreenUtil().setWidth(30),
                    )),
                  ),
                  top: 3,
                  right: 3,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

const TextStyle _textLabelStyle = TextStyle(
    color: AppColors.colorAccent,
    fontSize: FontConfig.font_x_small,
    fontWeight: FontWeight.bold);
const TextStyle _textContentStyle = TextStyle(
    color: AppColors.colorTextNormal,
    fontSize: FontConfig.font_x_small,
    fontWeight: FontWeight.bold);
const TextStyle _textInActiveStyle = TextStyle(
    color: AppColors.colorGreyStroke,
    fontSize: FontConfig.font_x_small,
    fontWeight: FontWeight.bold);
