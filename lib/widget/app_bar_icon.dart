// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/constant/constants.dart';

class AppBarIcon extends StatelessWidget {
  Function onPressed;

  AppBarIcon({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.keyboard_arrow_left,
        color: AppColors.colorAccent,
        size: ScreenUtil().setHeight(Constants.app_bar_icon_size),
      ),
      onPressed: () {
        onPressed != null
            ? onPressed()
            : () {
                Navigator.pop(context);
              };
      },
    );
  }
}
