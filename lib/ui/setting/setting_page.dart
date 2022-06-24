// @dart = 2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/config/router/route_util.dart';
import 'package:smartship_partner/config/router/router.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/model/user_info.dart';
import 'package:smartship_partner/ui/setting/setting.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/alert_dialog_two_button.dart';
import 'package:smartship_partner/widget/app_bar_widget.dart';

import '../../base/base_state.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends BaseState<SettingPage> {
  final SettingBloc _bloc = SettingBloc(SettingStartState());
  UserInfoModel user = null;
  String areaName = '';
  var _loading = false;

  @override
  void initState() {
    super.initState();
    _setupHandleEventBus();
    _bloc.add(SettingStartEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: AppBarWidget(
        title: AppTranslations.of(context).text('setting'),
      ),
      body: ModalProgressHUD(inAsyncCall: _loading, child: buildContainer()),
    );
  }

  Widget buildContainer() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        print('build layout: ' + state.toString());
        if (state.runtimeType == SettingUserLoadedState) {
          user = (state as SettingUserLoadedState).user;
          areaName = (state as SettingUserLoadedState).areaName;
          print('user: ${user.displayName}');
        }

        return Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _headerLayout(),
                SizedBox(
                  height: 15,
                ),
                _itemList()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _headerLayout() {
    return InkWell(
      onTap: () {
        if (user != null) _openUserDetail(user);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              /// Avatar
              Container(
                width: 60,
                height: 60,
                child: Card(
                    elevation: 5,
                    shape: CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: (user != null &&
                            user.pictureUrl != null &&
                            user.pictureUrl.isNotEmpty)
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(user.pictureUrl),
                          )
                        : Image.asset(
                            'assets/images/phone/ic_place_holder.png')),
              ),
              SizedBox(
                width: 10,
              ),

              /// Driver Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user != null ? user.displayName ?? '' : '',
                      style: TextStyle(
                          color: AppColors.colorGrey,
                          fontSize: FontConfig.font_medium,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        RatingBar.builder(
                          initialRating: user?.rate ?? 0.0,
                          minRating: 0,
                          itemSize: 15,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: AppColors.colorAccent,
                          ),
                          onRatingUpdate: null,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          (user != null && user.totalRates != null)
                              ? '(${user.totalRates})'
                              : '(0)',
                          style: TextStyle(
                              fontSize: FontConfig.font_small,
                              color: AppColors.colorGrey),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '${AppTranslations.of(context).text('area')}: ',
                          style: TextStyle(
                              fontSize: FontConfig.font_normal,
                              fontWeight: FontWeight.bold,
                              color: AppColors.colorBlack),
                        ),
                        Text(
                          '$areaName',
                          style: TextStyle(
                              fontSize: FontConfig.font_normal,
                              fontWeight: FontWeight.bold,
                              color: AppColors.colorAccent),
                        )
                      ],
                    )
//                  Text(
//                    'Biển số xe: 90B2-22762',
//                    style: TextStyle(
//                        fontSize: FontConfig.font_normal,
//                        fontWeight: FontWeight.bold,
//                        color: AppColors.colorGrey),
//                  )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (user != null) _requestLogout();
                },
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Icon(
                      Icons.exit_to_app,
                      color: user != null
                          ? AppColors.colorAccent
                          : AppColors.colorGrey,
                    )
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget _itemList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SettingItemWidget(
          title: AppTranslations.of(context).text('help'),
          onPressed: () {
            _requestHelp();
          },
        ),
        _divider(),
        _SettingItemWidget(
          title: AppTranslations.of(context).text('feedback'),
          onPressed: _enterFeedback,
        ),
        _divider(),
        _SettingItemWidget(
          title: AppTranslations.of(context).text('guide'),
          onPressed: _showInstruction,
        ),
        _divider(),
        _SettingItemWidget(
          title:
              '${AppTranslations.of(context).text('app_version')}: ${Constants.app_version}',
          onPressed: () {},
        ),
        _divider(),
      ],
    );
  }

  Widget _divider() {
    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Divider(height: 2, color: AppColors.colorGreyStroke));
  }

  _openUserDetail(UserInfoModel user) async {
    print('user: ${user.shortDesc}');
    var stringToBase64Url = utf8.fuse(base64Url);
    bool updateSuccess = await RouterUtils.push(
            context,
            AppRouter.updateProfile +
                '/' +
                stringToBase64Url.encode(userInfoModelToJson(user))) ??
        false;
    print('updarte success: ${updateSuccess}');
    if (updateSuccess) {
      if (user?.pictureUrl?.isNotEmpty == true) {
        // ignore: omit_local_variable_types
        final NetworkImage provider = NetworkImage(user.pictureUrl);
        await provider.evict();
      }
      _bloc.add(SettingStartEvent());
    }
  }

  void _enterFeedback() {
    RouterUtils.push(context, AppRouter.feedback);
  }

  void _requestLogout() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialogTwoButton(
            title: AppTranslations.of(context).text('logout_title'),
            message: AppTranslations.of(context).text('logout_message'),
            onYesClicked: () {
              setState(() {
                _loading = true;
              });
              _bloc.add(SettingLogoutEvent());
            },
          );
        });
  }

  void _setupHandleEventBus() {
    Utils.eventBus.on<SettingLogoutResultEBEvent>().listen((event) {
      setState(() {
        _loading = true;
      });

      if (event.isLoggedOut) {
        //Log out success, move to Splash
        RouterUtils.push(context, AppRouter.splash, true);
      }
    });
  }

  void _requestHelp() async {
    _bloc.add(SettingHelpEvent());
  }

  void _showInstruction() async {
    _bloc.add(SettingInstructionEvent());
  }
}

class _SettingItemWidget extends StatelessWidget {
  String title;
  Function onPressed;

  _SettingItemWidget({this.title = '', this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
        child: Text(
          title,
          style: _settingItemTextStyle,
        ),
      ),
    );
  }
}

const _settingItemTextStyle = TextStyle(
    fontSize: FontConfig.font_large,
    fontWeight: FontWeight.bold,
    color: AppColors.colorTextNormal);
