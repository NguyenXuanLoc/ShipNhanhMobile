// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';

class CreateOrderProgressDialog extends StatefulBuilder {

  @override
  // TODO: implement builder
  get builder => (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppTranslations.of(context).text('creating_order'),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(FontConfig.font_large),
                  color: AppColors.colorAccent),
            ),
            const SizedBox(
              height: 5,
            ),
            Divider(
              color: AppColors.colorAccent,
              height: 1,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                  width: ScreenUtil().setWidth(50),
                  height: ScreenUtil().setWidth(50),
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.colorAccent),
                  ),
                ),
                const SizedBox(width: 10,),
              ],
            )
          ],
        );
      };
}
