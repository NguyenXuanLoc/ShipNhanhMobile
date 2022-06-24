// @dart = 2.9
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  Widget leading;
  Widget title;
  Widget subtitle;
  Widget trailing;
  double height;

  CustomListTile({this.leading, this.title, this.subtitle, this.trailing, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (leading != null) leading,
          SizedBox(width: 15,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (title != null) title,
                if (subtitle != null) subtitle,
              ],
            ),
          ),
          SizedBox(width: 15,),
          if (trailing != null) trailing
        ],
      ),
    );
  }
}
