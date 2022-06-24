import 'package:flutter/cupertino.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';

class AppStyle {
  static const appBarTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: FontConfig.font_huge,
      fontFamily: 'Quicksand',
      color: AppColors.colorPrimary);

  static Widget widthSizedBox({double width=5}) {
    return SizedBox(
      width: width,
    );
  }

  static Widget heightSizedBox({double height=5}) {
    return SizedBox(
      height: height,
    );
  }
}
