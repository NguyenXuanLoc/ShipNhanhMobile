// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smartship_partner/base/base_state.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/config/style/style.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/network/response/user_profile/user_response.dart';
import 'package:smartship_partner/ui/driver_info/driver_info.dart';
import 'package:smartship_partner/util/date_time_utils.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/app_bar_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverInfoPage extends StatefulWidget {
  int driverId;

  DriverInfoPage(this.driverId);

  @override
  _DriverInfoPageState createState() => _DriverInfoPageState();
}

class _DriverInfoPageState extends BaseOrderState<DriverInfoPage> {
  final _bloc = DriveInfoBloc(InitDriveInfoState());

  final List<RateHistory> _rateHistoryList = [];
  UserInfo _userInfo;
  int _pageIndex = 1;
  ScrollController controller; // load more

  @override
  void initState() {
    super.initState();
    _bloc.add(LoadDriveInfoEvent(widget.driverId, _pageIndex));
    _setupHandleData();
    controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500) {
      _onLoadMore();
    }
  }


  Container _headerLayout() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      color: AppColors.colorWhite,
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
                width: 50,
                height: 50,
                child: Card(
                  elevation: 5,
                  shape: CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      placeholder: 'assets/images/phone/ic_place_holder.png',
                      image: _userInfo?.pictureUrl ?? ''),
                ),
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
                      _userInfo?.name ?? '',
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
                        /// Đánh giá
                        RatingBar.builder(
                          initialRating: _userInfo?.rate ?? 0,
                          minRating: 0,
                          itemSize: 15,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          onRatingUpdate: null,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: AppColors.colorAccent,
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          '(${_userInfo?.totalRates ?? 0})',
                          style: TextStyle(
                              fontSize: FontConfig.font_small,
                              color: AppColors.colorGrey),
                        )
                      ],
                    ),
//                    SizedBox(
//                      height: 5,
//                    ),
//                    Text(
//                      AppTranslations.of(context).text('license_plates') +
//                          ': 90B2-22762',
//                      style: TextStyle(
//                          fontSize: FontConfig.font_normal,
//                          fontWeight: FontWeight.bold,
//                          color: AppColors.colorGrey),
//                    )
                  ],
                ),
              ),

              /// Contact
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: RaisedButton(
                  color: AppColors.colorAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    _contactDriver();
                  },
                  child: Text(
                    AppTranslations.of(context).text('contact'),
                    style: TextStyle(
                        color: AppColors.colorWhite,
                        fontWeight: FontWeight.bold),
                  ),
                ),
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

  Widget _buildRateItem(RateHistory item) {
    return Container(
      color: AppColors.colorWhite,
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /// User Avatar
              Container(
                width: 40,
                height: 40,
                child: Card(
                  elevation: 5,
                  shape: CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      placeholder: 'assets/images/phone/ic_place_holder.png',
                      image: item?.pictureUrl ?? ''),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                item.name ?? '',
                style: TextStyle(
                  color: AppColors.colorGrey,
                  fontSize: FontConfig.font_medium,
                ),
              )
            ],
          ),
          RatingBar.builder(
            initialRating: (item.rate ?? 0).toDouble(),
            minRating: 1,
            itemSize: 15,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: AppColors.colorAccent,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          AppStyle.heightSizedBox(height: 5),
          Text(
            item.feedback ?? '',
            style: TextStyle(
                color: AppColors.colorGrey,
                fontSize: FontConfig.font_medium,
                fontWeight: FontWeight.bold),
          ),
          AppStyle.heightSizedBox(height: 5),
          Text(DateTimeUtil.utcToString(item.createdDate ?? ''),
              style: TextStyle(
                color: AppColors.colorGrey,
                fontSize: FontConfig.font_medium,
              ))
        ],
      ),
    );
  }

  _handleUserData(UserResponse data, bool isRefresh) {
    if (data == null) return;
    _userInfo = data.userInfo ?? _userInfo;
    if (isRefresh) {
      _rateHistoryList.clear();
    }
    _rateHistoryList.addAll(data.userInfo.rateHistories);
  }

  void _contactDriver() async {
    var phone = _userInfo?.phone ?? '';
    if (phone.isNotEmpty) {
      if (await canLaunch('tel://${phone}')) {
        await launch('tel://${phone}');
      }
    }
  }

  void _setupHandleData() {
    Utils.eventBus.on<LoadDriveFailedEBEvent>().listen((event) {
      if (event.message != null && event.message.isNotEmpty) {
        showSnackBar(context, event.message);
      }
    });
  }

  void _onLoadMore() async {
    if (_rateHistoryList.length % Constants.DEFAULT_PAGE_SIZE == 0) {
      _bloc.add(LoadDriveInfoEvent(widget.driverId, _pageIndex + 1));
    }
  }

  @override
  Widget getLayout(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xffF7F7F7),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xffF7F7F7),
          elevation: 0.0,
          leading: AppBarIcon(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            AppTranslations.of(context).text('driver_info'),
            style: TextStyle(color: AppColors.colorAccent),
          ),
        ),
        body: BlocBuilder(
          bloc: _bloc,
          builder: (context, state) {
            if (state is DriveDataLoadedState) {
              if (state.data != null && !state.isRefresh) {
                _pageIndex = state.pageIndex;
              }
              _handleUserData(state.data, state.isRefresh);
            }

            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _headerLayout(),
                  AppStyle.heightSizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      AppTranslations.of(context).text('rate_history'),
                      style: TextStyle(
                          fontSize: FontConfig.font_medium,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorGrey,
                          fontFamily: 'Quicksand'),
                    ),
                  ),
                  AppStyle.heightSizedBox(),
                  Expanded(
                    child: ListView.separated(
                        controller: controller,
                        itemBuilder: (context, index) {
                          RateHistory item = _rateHistoryList[index];
                          return _buildRateItem(item);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 2,
                            color: const Color(0xffF7F7F7),
                          );
                        },
                        itemCount: _rateHistoryList.length),
                  )
                ],
              ),
            );
          },
        ));
  }
}
