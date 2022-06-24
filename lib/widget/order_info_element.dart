// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:smartship_partner/config/color/color.dart';

class OrderInfoElement extends StatelessWidget {
  String label;
  String delimiter;
  String content;


  OrderInfoElement({this.label, this.delimiter, this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.colorAccent),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              delimiter,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorTextNormal),
            ),
          ),
          Flexible(
            child: Text(
              content,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorTextNormal),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
