// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/data/network/response/area/ship_areas_response.dart';

class AreaSelectDialog extends StatelessWidget {
  List<AppB2BConfig> areasConfig;
  bool allowBackPress;

  AreaSelectDialog(this.areasConfig, [this.allowBackPress = false]);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 667, allowFontScaling: true);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  _dialogContent(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return allowBackPress;
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppTranslations.of(context).text('select_area'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(FontConfig.font_medium),
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorAccent)),
            const SizedBox(
              height: 15,
            ),
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      Navigator.of(context).pop(areasConfig[index]);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Text(
                        areasConfig[index].name,
                        style: TextStyle(
                            fontSize:
                                ScreenUtil().setSp(FontConfig.font_medium),
                            color: AppColors.colorBlack),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                  );
                },
                itemCount: areasConfig.length),
          ],
        ),
      ),
    );
  }
}
