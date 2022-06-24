import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:url_launcher/url_launcher.dart';

/// User contact in Order detail
/// TODO: need pass contact info as params
class OrderContact extends StatelessWidget {

  final name;
  final phone;

  OrderContact({this.name, this.phone});

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
        color: AppColors.colorWhite,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        onPressed: () async {
          if (await canLaunch('tel://$phone')) {
            await launch('tel://$phone');
          }
        },
        icon: SvgPicture.asset('assets/images/phone/ic_contact.svg'),
        label: Text(
          name,
          style: TextStyle(
              color: AppColors.colorAccent,
              fontSize: FontConfig.font_normal,
              fontWeight: FontWeight.bold),
        ));
  }
}
