// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';

class SearchField extends StatelessWidget {
  Color color;
  String hint;
  TextEditingController textController;
  Function onChanged;

  SearchField(
      {this.color = AppColors.colorBlackFade,
      this.hint = '',
      this.textController,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
        child: TextField(
          maxLines: 1,
          onChanged: onChanged,
          controller: textController,
          style: TextStyle(color: color, fontSize: FontConfig.font_large),
          decoration: InputDecoration(
              hintText: AppTranslations.of(context).text('search_hint'),
              hintStyle: TextStyle(
                  color: AppColors.colorGrey, fontSize: FontConfig.font_large),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: color,
              )),
        ),
      ),
    );
  }
}
