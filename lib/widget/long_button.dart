// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';

/// Button for action like verify, confirm
class LongButton extends StatelessWidget {
  String text;
  Function onPressed;
  double borderRadius;
  double fontSize;
  TextStyle textStyle;
  Color backgroundColor;
  double width;
  double height;
  EdgeInsets padding;
  Color textColor;
  bool singleLine;

  LongButton(
      {this.width = double.infinity,
      this.height = 67,
      this.text,
      this.fontSize = FontConfig.font_very_huge,
      this.onPressed,
      this.backgroundColor = AppColors.colorPrimary,
      this.borderRadius = 15.0,
      this.textColor = AppColors.colorWhite,
      this.textStyle,
      this.padding = const EdgeInsets.all(0),
      this.singleLine = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        child: RaisedButton(
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          color: backgroundColor,
          onPressed: onPressed,
          child: Text(
            text,
            style: textStyle ??
                TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: FontWeight.bold),
            maxLines: singleLine ? 1 : null,
          ),
        ));
  }
}
