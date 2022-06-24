import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';

/// the layout of bottom sheet which show the type of choosing image
/// used in showModalBottomSheet method
class ImagePickerBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // title
        children: <Widget>[
          Container(
            width: fullWidth,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              AppTranslations.of(context).text('pick_image_type'),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: FontConfig.font_large,
                  color: AppColors.colorAccent),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 1,
            color: AppColors.colorGreyStroke,
          ),
          SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context, ImageSource.camera);
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              width: fullWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.camera_alt,
                    size: 25,
                    color: AppColors.colorGrey,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppTranslations.of(context).text('camera'),
                    style: TextStyle(
                        fontSize: FontConfig.font_medium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorGreyDark),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context, ImageSource.gallery);
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              width: fullWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.image,
                    size: 25,
                    color: AppColors.colorGrey,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppTranslations.of(context).text('pick_image'),
                    style: TextStyle(
                        fontSize: FontConfig.font_medium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorGreyDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
