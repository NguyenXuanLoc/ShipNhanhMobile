// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';

import 'app_bar_icon.dart';

/// AppBar widget
/// Note: The widget use this appbar must call ScreenUtil.init() method in build
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  List<Widget> action;
  bool showIcon = false;
  Function onActionTap;
  String title;
  Color backgroundColor;
  bool centerTitle;
  AppBarWidget({this.action, this.showIcon = false, this.onActionTap, this.title='', this.backgroundColor=AppColors.colorWhite, this.centerTitle = true});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0.0,
      centerTitle: centerTitle,
      title: Text(
        title,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(FontConfig.font_very_large),
            color: AppColors.colorPrimary,
            fontWeight: FontWeight.bold),
      ),
      leading: showIcon ? AppBarIcon(onPressed: onActionTap,) : null,
      actions: action,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize {
   return Size.fromHeight(ScreenUtil().setHeight(50));
  }
}
