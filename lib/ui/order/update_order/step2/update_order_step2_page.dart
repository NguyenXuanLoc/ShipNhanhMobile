// @dart = 2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smartship_partner/base/base_state.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/config/router/route_util.dart';
import 'package:smartship_partner/config/router/router.dart';
import 'package:smartship_partner/data/model/order/new_order.dart';
import 'package:smartship_partner/data/model/order_type.dart';
import 'package:smartship_partner/eventbus/update_order_event.dart';
import 'package:smartship_partner/ui/order/update_order/step2/update_order_step2_bloc.dart';
import 'package:smartship_partner/ui/order/update_order/update_order_event.dart';
import 'package:smartship_partner/ui/order/update_order/update_order_state.dart';
import 'package:smartship_partner/util/order_utils.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/app_bar_widget.dart';
import 'package:smartship_partner/widget/custom_listTile.dart';
import 'package:smartship_partner/widget/image_picker_bottom_sheet.dart';
import 'package:smartship_partner/widget/long_button.dart';
import 'package:smartship_partner/widget/numberic_text_formatter.dart';

class UpdateOrderStep2Page extends StatefulWidget {
  var order;
  String filePath;

  UpdateOrderStep2Page({this.order, this.filePath});

  @override
  _UpdateOrderStep2PageState createState() => _UpdateOrderStep2PageState();
}

class _UpdateOrderStep2PageState extends BaseOrderState<UpdateOrderStep2Page> {
  NewOrder _newOrder;
  String _currentOrderImg;
  final UpdateOrderStep2Bloc _bloc =
      UpdateOrderStep2Bloc(UpdateOrderStep2StartState());
  var _loading = false;
  var _baseShipFee = 0.0;
  var _baseDistance = 0.0;
  var _extraFee = 0.0;

  File _imageFile;
  final _imagePicker = ImagePicker();

  /* Style */
  TextStyle _labelTextStyle;
  TextStyle _contentTextStyle;
  TextStyle _contentLabelTextStyle;
  final _fromTextController = TextEditingController();
  final _toTextController = TextEditingController();
  final _shipFeeController = TextEditingController();
  final _goodsMoneyController = TextEditingController();
  final _shipFeeFormatter = NumericTextFormatter();
  final _goodsMoneyFormatter = NumericTextFormatter();

  @override
  void initState() {
    super.initState();
    _newOrder = widget.order;
    _currentOrderImg = widget.filePath;

    /* Handle loading */
    _setupHandleLoading();
    _updateData();
    _bloc.add(UpdateOrderStep2StartEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _setupHandleLoading() {
    /* Handle loading */
    Utils.eventBus.on<UpdateOrderResultEvent>().listen((event) {
      setState(() {
        _loading = event.success;
      });
      if (event.success) {
        showSnackBar(
            context, AppTranslations.of(context).text('update_order_success'));
        Timer(Duration(seconds: 1), () {
          Navigator.pop(context, [true]);
        });
      } else {
        if (event.message.isNotEmpty) {
          showSnackBar(context, event.message);
        } else {
          showSnackBar(
              context, AppTranslations.of(context).text('update_order_failed'));
        }
      }
    });

    //  Handle Ship fee data
    Utils.eventBus.on<UpdateOrderShipFeeEvent>().listen((event) {
      setState(() {
        _baseShipFee = event.baseFee;
        _baseDistance = event.baseDistance;
        _extraFee = event.extraFee;
      });
    });
  }

  void _initStyleVariables() {
    _labelTextStyle = TextStyle(
        fontSize: ScreenUtil().setSp(FontConfig.font_medium),
        fontWeight: FontWeight.bold,
        color: AppColors.colorAccent);
    _contentTextStyle = TextStyle(
        fontFamily: FontConfig.fontSen,
        fontSize: ScreenUtil().setSp(FontConfig.font_medium),
        fontWeight: FontWeight.normal,
        color: AppColors.colorNavyDark);
    _contentLabelTextStyle = TextStyle(
        fontFamily: FontConfig.fontSen,
        fontSize: ScreenUtil().setSp(FontConfig.font_x_small),
        fontWeight: FontWeight.normal,
        color: AppColors.colorAccent);
  }

  @override
  Widget getLayout(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 667, allowFontScaling: true);
    _initStyleVariables();
    return WillPopScope(
      onWillPop: () async {
        return _onBackPress();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.colorWhite,
        appBar: AppBarWidget(
          onActionTap: _onBackPress,
          title: AppTranslations.of(context).text('update_order'),
          showIcon: true,
        ),
        body: BlocBuilder(
          bloc: _bloc,
          builder: (context, state) {
            return ModalProgressHUD(
              child: _buildContent(),
              inAsyncCall: _loading,
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _baseInfo(),
              /* separator */
              Container(
                width: MediaQuery.of(context).size.width,
                height: ScreenUtil().setHeight(16),
                color: AppColors.colorWindowBackground,
              ),
              _additionalInfo()
            ],
          )),
        ),

        /// Update order button
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: LongButton(
            text: AppTranslations.of(context).text('update_order'),
            height: ScreenUtil().setHeight(40),
            textColor: AppColors.colorWhite,
            onPressed: _requestUpdateOrder,
            borderRadius: 10,
            fontSize: ScreenUtil().setSp(FontConfig.font_x_medium),
          ),
        )
      ],
    );
  }

  _baseInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    AppTranslations.of(context).text('base_info'),
                    style: _labelTextStyle,
                  ),
                ),
                InkWell(
                  onTap: _goToUpdate1,
                  child: Container(
                    width: ScreenUtil().setHeight(27),
                    height: ScreenUtil().setHeight(27),
                    margin: const EdgeInsets.only(right: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.colorAccent),
                    child: Icon(
                      Icons.edit,
                      color: AppColors.colorWhite,
                      size: ScreenUtil().setHeight(17),
                    ),
                  ),
                )
              ],
            ),

            InkWell(
              onTap: () {},
              child: CustomListTile(
                leading: Container(
                  child: SvgPicture.asset(
                    'assets/images/phone/ic_dot_outline.svg',
                    height: ScreenUtil().setWidth(8),
                  ),
                ),
                title: Text(
                  _getFromPlaceTitle(),
                  style: _contentLabelTextStyle,
                ),
                subtitle: TextField(
                  style: _contentTextStyle,
                  controller: _fromTextController,
                  enabled: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.colorGreyStroke,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
                child: SvgPicture.asset(
                  'assets/images/phone/ic_dot_fill.svg',
                  height: ScreenUtil().setWidth(4),
                )),
            SizedBox(
              height: 15,
            ),
            Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
                child: SvgPicture.asset(
                  'assets/images/phone/ic_dot_fill.svg',
                  height: ScreenUtil().setWidth(4),
                )),

            /// Giao hang
            InkWell(
              child: CustomListTile(
                leading: Container(
                  child: SvgPicture.asset(
                    'assets/images/phone/ic_dot_fill.svg',
                    height: ScreenUtil().setWidth(8),
                  ),
                ),
                title: Text(
                  _getToPlaceTitle(),
                  style: _contentLabelTextStyle,
                ),
                subtitle: TextField(
                  enabled: false,
                  controller: _toTextController,
                  style: _contentTextStyle,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
//                Text(
//                  _giveGoodsContactInfo != null
//                      ? _giveGoodsContactInfo.address
//                      : '',
//                  style: _contentTextStyle,
//                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.colorGreyStroke,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),

            /// Khoảng cách
            Row(
              children: <Widget>[
                Text(
                  '${AppTranslations.of(context).text('distance')}: ',
                  style: _contentLabelTextStyle,
                ),
                Text(
                  '${OrderUtil.formatDistance(_newOrder.distance)}',
                  style: _contentTextStyle.copyWith(
                      color: AppColors.colorTextNormal),
                ),
              ],
            ),

            SizedBox(
              height: 15,
            ),

            /// Ghi chú
            Text(
              AppTranslations.of(context).text('note'),
              style: _contentLabelTextStyle,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              _newOrder.notes ?? '',
              style:
                  _contentTextStyle.copyWith(color: AppColors.colorTextNormal),
            ),
            SizedBox(
              height: 15,
            ),
          ]),
    );
  }

  _additionalInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Text(
            AppTranslations.of(context).text('additional_info'),
            style: _labelTextStyle,
          ),
          SizedBox(
            height: 15,
          ),

          /// Tiền hàng
          Text(
            AppTranslations.of(context).text('goods_money'),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(FontConfig.font_small),
                color: AppColors.colorTextNormal),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            enabled: _newOrder.category != OrderType.SHIPPER.value,
            controller: _goodsMoneyController,
            keyboardType: TextInputType.number,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(FontConfig.font_medium),
                color: AppColors.colorTextNormal),
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              _goodsMoneyFormatter
            ],
            decoration: _moneyInputDecoration,
          ),

          /// Tiền ship
          SizedBox(
            height: 15,
          ),
          Text(
            AppTranslations.of(context).text('ship_fee'),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(FontConfig.font_small),
                color: AppColors.colorTextNormal),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            enabled: false,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              _shipFeeFormatter
            ],
            controller: _shipFeeController,
            keyboardType: TextInputType.number,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(FontConfig.font_medium),
                color: AppColors.colorTextNormal),
            decoration: _moneyInputDecoration,
          ),

          SizedBox(
            height: 15,
          ),
          Text(
            AppTranslations.of(context).text('note1') + ':',
            style: _labelTextStyle,
          ),

          SizedBox(
            height: 5,
          ),
          Text(
            Utils.shipFeeNote(AppTranslations.of(context).text('ship_fee_note'),
                _baseShipFee, _baseDistance, _extraFee),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(FontConfig.font_small),
                color: AppColors.colorAccent),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            AppTranslations.of(context).text('create_order_note'),
            style: TextStyle(
                fontSize: ScreenUtil().setSp(FontConfig.font_small),
                color: AppColors.colorAccent),
          ),

          /// Hình ảnh mô tả
          SizedBox(
            height: 15,
          ),
          Text(
            AppTranslations.of(context).text('add_description_image'),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(FontConfig.font_small),
                color: AppColors.colorTextNormal),
          ),
          SizedBox(
            height: 5,
          ),

          //TODO: upload images later
          Container(
            width: ScreenUtil().setWidth(166),
            height: ScreenUtil().setHeight(103),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(150),
                  height: ScreenUtil().setHeight(96),
                  decoration: BoxDecoration(
                      color: AppColors.colorGreyLight,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                Container(
                  width: ScreenUtil().setWidth(150),
                  height: ScreenUtil().setHeight(96),
                  child: _imageFile != null && _imageFile.path.isNotEmpty
                      ? Image.file(
                          _imageFile,
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        )
                      : (_currentOrderImg.isNotEmpty
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: AppColors.colorGreyLight),
                                child: FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/phone/ic_picture.svg',
                                    image: _currentOrderImg),
                              ))
                          : SvgPicture.asset(
                              'assets/images/phone/im_image.svg',
                              color: AppColors.colorGreyStroke,
                              fit: BoxFit.contain,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            )),
                ),
                Positioned(
                  right: 1,
                  top: 1,
                  child: GestureDetector(
                    onTap: () {
                      _getImage();
                    },
                    child: Container(
                      width: ScreenUtil().setHeight(17),
                      height: ScreenUtil().setHeight(17),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.colorAccent),
                      child: Icon(
                        Icons.edit,
                        color: AppColors.colorWhite,
                        size: ScreenUtil().setHeight(13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _updateData() {
    _fromTextController.text = _newOrder.fromAddress ?? '0';
    _toTextController.text = _newOrder.toAddress ?? '0';
    _shipFeeController.text = _newOrder.shipFee != null
        ? _currencyFormat.format(_newOrder.shipFee.toInt())
        : '0';
    _shipFeeFormatter.currentValue =
        _newOrder.shipFee != null ? _newOrder.shipFee.toInt().toString() : '0';
    _goodsMoneyController.text = _newOrder.amount != null
        ? _currencyFormat.format(_newOrder.amount.toInt())
        : '0';
    _goodsMoneyFormatter.currentValue =
        _newOrder.amount != null ? _newOrder.amount.toInt().toString() : '0';
    setState(() {});
  }

  bool _onBackPress([NewOrder data]) {
    if (data != null) {
//      data.shipFee = _shipFeeFormatter.currentValue.isEmpty
//          ? null
//          : double.parse(_shipFeeFormatter.currentValue);
      // Ship fee will be pre-calculate in step1
      data.amount = _goodsMoneyFormatter.currentValue.isEmpty
          ? null
          : double.parse(_goodsMoneyFormatter.currentValue);
    }
    Navigator.pop(context, [
      data,
      data == null ? null : (_imageFile != null ? _imageFile.path : null)
    ]);
    return false;
  }

  /// Request to create order, if all the condition is ok
  _requestUpdateOrder() async {
    if (_shipFeeFormatter.currentValue.isEmpty) {
      showSnackBar(
          context, AppTranslations.of(context).text('missing_ship_fee'));
      return;
    }

    if (_goodsMoneyFormatter.currentValue.isEmpty) {
      showSnackBar(
          context, AppTranslations.of(context).text('missing_goods_money'));
      return;
    }
    // Ship fee will be pre-calculate in step1
//    _newOrder.shipFee = double.parse(_shipFeeFormatter.currentValue);
    _newOrder.amount = double.parse(_goodsMoneyFormatter.currentValue);
    setState(() {
      _loading = true;
    });
    _bloc.add(UpdateOrderStep2Event(_newOrder, _imageFile));
  }

  Future _getImage() async {
    var type = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return ImagePickerBottomSheet();
        });
    print('type: $type');
    if (type != null) {
      var file = await _imagePicker.getImage(source: type);
      if (file != null) {
        print('file: ' + file.path);
        setState(() {
          _imageFile = File(file.path);
        });
      }
    }
//    var file = await FilePicker.getFile(type: FileType.image);
//    if (file != null) {
//      print('hoan.dv: file: ' + file.path);
//      setState(() {
//        _imageFile = file;
//      });
//    }
  }

  final _moneyInputDecoration = InputDecoration(
      suffix: Text('vnđ'),
      border: OutlineInputBorder(
        borderSide:
            const BorderSide(color: AppColors.colorGreyStroke, width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ));

  void _goToUpdate1() async {
    var stringToBase64Url = utf8.fuse(base64Url);
    var data = await RouterUtils.push(
        context,
        AppRouter.updateOrderStep1 +
            '/' +
            stringToBase64Url.encode(newOrderToJson(_newOrder)));

    _newOrder = data != null ? data[0] ?? _newOrder : _newOrder;
    _updateData();
  }

  final _currencyFormat = NumberFormat('#,###');

  String _getToPlaceTitle() {
    return _newOrder.category == OrderType.SHIPPER.value
        ? AppTranslations.of(context).text('to_place')
        : AppTranslations.of(context).text('give_goods');
  }

  String _getFromPlaceTitle() {
    return _newOrder.category == OrderType.SHIPPER.value
        ? AppTranslations.of(context).text('from_place')
        : AppTranslations.of(context).text('take_goods');
  }
}
