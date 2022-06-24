// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:smartship_partner/base/base_state.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/ui/location_select/place/place_select.dart';
import 'package:smartship_partner/ui/location_select/suggest/location_suggest_page.dart';
import 'package:smartship_partner/widget/app_bar_icon.dart';

import 'maps/map_select.dart';

class LocationSelectPage extends StatefulWidget {
  static const TYPE_FROM = 0;
  static const TYPE_TO = 1;

  int state;
  int orderType;

  LocationSelectPage(
      [this.state = TYPE_FROM, this.orderType = CreateOrderCategory.TYPE_SHIP]);

  @override
  _LocationSelectPageState createState() => _LocationSelectPageState();
}

class _LocationSelectPageState extends BaseOrderState<LocationSelectPage> {
  int _orderType;
  int _state;

  @override
  void initState() {
    super.initState();
    _state = widget.state;
    _orderType = widget.orderType;
  }

  @override
  Widget getLayout(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed();
      },
      child: DefaultTabController(
        length: _shouldShowSuggestTab() ? 3 : 2,
        child: Scaffold(
          backgroundColor: Color(0xfffdfdfd),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              AppTranslations.of(context).text('select_place'),
              style: TextStyle(color: AppColors.colorAccent),
            ),
            elevation: 0.0,
            leading: AppBarIcon(
              onPressed: _onBackPressed,
            ),
            bottom: TabBar(
              labelColor: AppColors.colorAccent,
              labelStyle: TextStyle(
                  fontSize: FontConfig.font_very_large,
                  fontFamily: 'Quicksand'),
              tabs: _getListTab(context),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: _buildListPageView(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildListPageView() {
    return <Widget>[
      // Chỉ hiển thị trang đề xuất với đơn mua hộ
      if (_shouldShowSuggestTab())
        LocationSuggestPage(_state),
      PlaceSelectPage(_state,_orderType),
      MapSelectPage(_state),
    ];
  }

  List<Widget> _getListTab(BuildContext context) {
    return <Widget>[
      if (_shouldShowSuggestTab())
        // Chỉ hiển thị tab suggest khi mua hộ
        Tab(
          text: AppTranslations.of(context).text('suggest'),
        ),
      Tab(
        text: AppTranslations.of(context).text('place'),
      ),
      Tab(
        text: AppTranslations.of(context).text('maps'),
      )
    ];
  }

  bool _shouldShowSuggestTab() {
    return _orderType == CreateOrderCategory.TYPE_BUY && _state == LocationSelectPage.TYPE_FROM;
  }

  bool _onBackPressed() {
    Navigator.pop(context, null);
    return false;
  }
}
