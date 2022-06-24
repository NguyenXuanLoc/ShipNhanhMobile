// @dart = 2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/config/router/route_util.dart';
import 'package:smartship_partner/config/router/router.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/create_order_contact.dart';
import 'package:smartship_partner/data/model/order_type.dart';
import 'package:smartship_partner/data/repository/order_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/ui/location_select/location_select_page.dart';
import 'package:smartship_partner/widget/long_button.dart';

/// Show when user click on an exist data in [CreateOrderStep1Page]
class ConfirmOrderDialog extends StatefulWidget {
  int type;

  /* enable or disable arrow action at address */
  bool enableAction;

  /* We just use order type in case need to change location (from Step1) */
  int orderType;

  CreateOrderContact data;

  ConfirmOrderDialog(
      [this.data,
      this.type = LocationSelectPage.TYPE_FROM,
      this.enableAction = true,
      this.orderType = CreateOrderCategory.TYPE_SHIP]);

  @override
  _ConfirmOrderDialogState createState() => _ConfirmOrderDialogState();
}

class _ConfirmOrderDialogState extends State<ConfirmOrderDialog> {
  CreateOrderContact data;
  TextStyle _labelTextStyle;
  TextStyle _contentTextStyle;
  var _type;
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _type = widget.type;
    data = widget.data;
    updateData();
  }

  void updateData() {
    if (data != null) {
      _addressController.text = data.address;
      _nameController.text = data.userName;
      _phoneController.text = data.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 667, allowFontScaling: true);
    _initTextStyle();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(),
    );
  }

  Widget _dialogContent() {
    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.colorWhite,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Title
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _getTitle(),
                        textAlign: TextAlign.center,
                        style: _labelTextStyle.copyWith(
                            fontSize:
                                ScreenUtil().setSp(FontConfig.font_medium)),
                      ),
                    ),
                    IconButton(
                      onPressed: _onBackPressed,
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.colorAccent,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _getAddressTitle(),
                  style: _labelTextStyle,
                ),
                SizedBox(
                  height: 5,
                ),

                /// Dịa chỉ
                Container(
                  padding: const EdgeInsets.only(
                      left: 13, right: 0, top: 0, bottom: 0),
                  decoration: _inputDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppTranslations.of(context)
                                .text('input_address_hint'),
                            hintStyle: _contentTextStyle.copyWith(
                                color: AppColors.colorGreyStroke),
                          ),
                          style: _contentTextStyle,
                          controller: _addressController,
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed:
                            widget.enableAction ? _openPlaceSelectScreen : null,
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: widget.enableAction
                              ? AppColors.colorGrey
                              : AppColors.colorGreyStroke,
                          size: ScreenUtil().setHeight(14),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AppTranslations.of(context).text('contact_name'),
                  style: _labelTextStyle,
                ),
                SizedBox(
                  height: 5,
                ),

                /// Tên liên hệ
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      left: 13, right: 7, top: 0, bottom: 0),
                  decoration: _inputDecoration,
                  child: TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            AppTranslations.of(context).text('input_name_hint'),
                        hintStyle: _contentTextStyle.copyWith(
                            color: AppColors.colorGreyStroke),
                      ),
                      style: _contentTextStyle,
                      validator: _validateUserName,
                      controller: _nameController),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AppTranslations.of(context).text('phone_num'),
                  style: _labelTextStyle,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      left: 13, right: 7, top: 0, bottom: 0),
                  decoration: _inputDecoration,
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        hintText: AppTranslations.of(context)
                            .text('input_phone_hint'),
                        hintStyle: _contentTextStyle.copyWith(
                            color: AppColors.colorGreyStroke),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0)),
                    validator: _validatePhone,
                    style: _contentTextStyle,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                /// Check box default address
                Visibility(
                  visible: _getDefaultAddressVisibility(),
                  child: CheckboxListTile(
                    title: Text(
                      AppTranslations.of(context).text('set_default_address'),
                      style: _contentTextStyle,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      setState(() {
                        _checked = value;
                      });
                    },
                    value: _checked,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: LongButton(
                    fontSize: ScreenUtil().setSp(FontConfig.font_large),
                    padding: EdgeInsets.all(10),
                    height: null,
                    text: AppTranslations.of(context).text('confirm'),
                    onPressed: () {
                      _onConfirm();
                    },
                    borderRadius: 20,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getAddressTitle() {
    return AppTranslations.of(context).text(
        _type == LocationSelectPage.TYPE_FROM
            ? (widget.orderType == OrderType.SHIPPER.value
                ? 'from_place'
                : 'take_goods_place')
            : (widget.orderType == OrderType.SHIPPER.value
                ? 'to_place'
                : 'give_goods_place'));
  }

  String _getTitle() {
    return AppTranslations.of(context).text(
        _type == LocationSelectPage.TYPE_FROM
            ? (widget.orderType == OrderType.SHIPPER.value
                ? 'confirm_grab_from_title'
                : 'confirm_take_goods_title')
            : (widget.orderType == OrderType.SHIPPER.value
                ? 'confirm_grab_to_title'
                : 'confirm_give_goods_title'));
  }

  final _inputDecoration = BoxDecoration(
    border: Border.all(
      color: AppColors.colorGreyStroke,
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(10)),
    color: AppColors.colorWhite,
  );

  void _openPlaceSelectScreen() async {
    CreateOrderContact result = await RouterUtils.push(
        context,
        AppRouter.placeSelect +
            '/' +
            _type.toString() +
            '/' +
            widget.orderType.toString());

    if (result != null) {
      if (result.fromOtherPlace) {
        /// Chọn từ other place, thì return luôn
        Navigator.pop(context, result);
      } else {
        setState(() {
          if (data != null) {
            result.userName = data.userName;
            result.phone = data.phone;
          }
          data = result;
          updateData();
        });
      }
    }
  }

  /// return true to apply backpressed from system
  /// The current data will not be sent
  bool _onBackPressed() {
    Navigator.pop(context, null);
    return false;
  }

  void _initTextStyle() {
    _labelTextStyle = TextStyle(
        fontSize: ScreenUtil().setSp(FontConfig.font_small),
        fontWeight: FontWeight.bold,
        color: AppColors.colorAccent);

    _contentTextStyle = TextStyle(
        fontSize: ScreenUtil().setSp(FontConfig.font_x_small),
        fontWeight: FontWeight.bold,
        color: AppColors.colorGrey);
  }

  /// Called when user confirm the current data
  void _onConfirm() async {
    /* If data is null, check the condition of data in TextField */
    if (_formKey.currentState.validate()) {
      data ??= CreateOrderContact();
      data.address = _addressController.text;
      data.userName = _nameController.text;
      data.phone = _phoneController.text;
      if (_checked) {
        await _saveDefaultAddress(data);
      }
      Navigator.pop(context, data);
    }
  }

  String _validateUserName(String value) {
    print('order type: ${widget.orderType}');
    // địa chỉ giao hàng của đơn xe ôm ko cần thiết
    if (widget.orderType == OrderType.SHIPPER.value &&
        _type == LocationSelectPage.TYPE_TO) return null;
    if (value.isNotEmpty) return null;
    return AppTranslations.of(context).text('location_user_name_empty');
  }

  String _validatePhone(String phone) {
    // địa chỉ giao hàng của đơn xe ôm ko cần thiết
    if (widget.orderType == OrderType.SHIPPER.value &&
        _type == LocationSelectPage.TYPE_TO) return null;
    if (phone.isEmpty) {
      return AppTranslations.of(context).text('location_phone_empty');
    }
    if (phone.length != 10 && phone.length != 11) {
      return AppTranslations.of(context).text('phone_invalid_format');
    }
    return null;
  }

  /// Save the default address
  _saveDefaultAddress(CreateOrderContact data) async {
    final userRepository = UserRepository.get(PrefsManager.get);
    var orderRepository = OrderRepository.get(userRepository);
    await orderRepository.saveOrderDefaultData(data);
  }

  bool _getDefaultAddressVisibility() {
    print('_getDefaultAddressVisibility: ${widget.orderType} -- ${_type}');
    if (widget.orderType == OrderType.NORMAL.value ||
        widget.orderType == OrderType.SHIPPER.value) {
      // ĐƠn giao hàng/ xe ôm chỉ hiện ở địa chỉ lấy hàng
      return _type == LocationSelectPage.TYPE_FROM;
    }
    if (widget.orderType == OrderType.ORDER_FOR_SOMEONE.value) {
      // ĐƠn giao mua hộ  chỉ hiện ở địa chỉ giao hàng
      return _type == LocationSelectPage.TYPE_TO;
    }

    return false;
  }
}
