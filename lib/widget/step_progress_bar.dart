// @dart = 2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartship_partner/config/color/color.dart';

enum StepIconType { iconData, assetImage, assetSvg, url }

class StepProgressBar extends StatelessWidget {
  final double _width;
  final List<StepIcon> _icons;
  final List<String> _titles;
  final int _curStep;
  final Color activeColor;
  final Color inactiveColor;
  final double lineWidth = 10.0;
  final Color lineInactiveColor;

  StepProgressBar(
      {Key key,
      @required List<StepIcon> icons,
      @required int curStep,
      List<String> titles,
      @required double width,
      @required this.activeColor,
      this.lineInactiveColor = AppColors.colorGreyLight,
      this.inactiveColor = AppColors.colorWhite})
      : _icons = icons,
        _titles = titles,
        _curStep = curStep,
        _width = width,
        assert(curStep > 0 == true && curStep <= icons.length),
        assert(width > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          top: 32.0,
          left: 14.0,
          right: 14.0,
        ),
        width: _width,
        child: Column(
          children: <Widget>[
            Row(
              children: _iconViews(),
            ),
            SizedBox(
              height: 10,
            ),
            if (_titles != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _titleViews(),
              ),
          ],
        ));
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    _icons.asMap().forEach((i, icon) {
      //colors according to state
      var circleColor = activeColor;
//          (i == 0 || _curStep > i + 1) ? activeColor : inactiveColor;

      var lineColor = _curStep > i + 1 ? activeColor : lineInactiveColor;

      var iconColor = inactiveColor;
//          (i == 0 || _curStep > i + 1) ? inactiveColor : activeColor;

      list.add(
        //dot with icon view
        Container(
          width: 35.0,
          height: 35.0,
          padding: EdgeInsets.all(7),
          child: _getStepIcon(icon, iconColor),
          decoration: BoxDecoration(
            color: circleColor,
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
//            border: new Border.all(
//              color: activeColor,
//              width: 2.0,
//            ),
          ),
        ),
      );

      //line between icons
      if (i != _icons.length - 1) {
        list.add(Expanded(
            child: Container(
          height: lineWidth,
          color: lineColor,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, text) {
      list.add(Text(text, style: TextStyle(color: activeColor)));
    });
    return list;
  }

  Widget _getStepIcon(StepIcon icon, Color iconColor) {
    switch (icon.stepIconType) {
      case StepIconType.iconData:
        return Icon(
          icon.iconData,
          color: iconColor,
          size: 25.0,
        );
      case StepIconType.assetImage:
        return Image.asset(
          icon.path,
          width: 25.0,
          height: 25.0,
          color: iconColor,
        );
      case StepIconType.assetSvg:
        return SvgPicture.asset(
          icon.path,
          height: 25.0,
          color: iconColor,
        );
      default:
        /// default dummy
        return Icon(
          Icons.android,
          color: iconColor,
          size: 15.0,
        );
    }
  }
}

/// Type of icon use in [StepProgressBar]
class StepIcon {
  IconData iconData;
  String path;
  StepIconType stepIconType;

  StepIcon({this.iconData, this.path, this.stepIconType});
}
