// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/data/model/order_type.dart';

/// Bottom sheet for choosing the type of order
class CreateOrderBottomSheet extends StatelessWidget {
  TextStyle _textStyle;

  @override
  Widget build(BuildContext context) {
    _textStyle = TextStyle(
        fontSize: ScreenUtil().setSp(FontConfig.font_medium),
        color: AppColors.colorTextNormal,
        fontWeight: FontWeight.bold);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(
              context,
              'assets/images/phone/ic_order_ship.svg',
              AppTranslations.of(context).text('create_order_normal'),
              OrderType.DELIVER.value),
          _buildItem(
              context,
              'assets/images/phone/ic_order_buy.svg',
              AppTranslations.of(context).text('create_order_buy'),
              OrderType.ORDER_FOR_SOMEONE.value),
          _buildItem(
              context,
              'assets/images/phone/ic_order_grab.svg',
              AppTranslations.of(context).text('create_order_grab'),
              OrderType.SHIPPER.value),
          _buildItem(
              context,
              'assets/images/phone/ic_images.svg',
              AppTranslations.of(context).text('create_order_with_images'),
              -1,
              true),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String icon, String text, int orderType,
      [bool isNew = false]) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).pop(orderType);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: SvgPicture.asset(icon,
                        width: ScreenUtil().setWidth(20),
                        height: ScreenUtil().setWidth(20)),
                  ),
                  Visibility(
                    visible: isNew,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                          color: AppColors.colorAccent,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: Text(
                        AppTranslations.of(context).text('new'),
                        style: TextStyle(
                            color: AppColors.colorWhite,
                            fontSize:
                                ScreenUtil().setSp(FontConfig.font_small)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                text,
                style: _textStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
