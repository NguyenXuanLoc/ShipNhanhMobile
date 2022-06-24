// @dart = 2.9
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smartship_partner/base/base_state.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/config/router/route_util.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/model/user_info.dart';
import 'package:smartship_partner/data/network/request/user_profile/update_user_profile_request.dart';
import 'package:smartship_partner/data/network/response/area/ship_areas_response.dart';
import 'package:smartship_partner/eventbus/udate_user_event.dart';
import 'package:smartship_partner/ui/use_profile/user_profile.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/app_bar_icon.dart';
import 'package:smartship_partner/widget/area/area_select_dialog.dart';
import 'package:smartship_partner/widget/image_picker_bottom_sheet.dart';
import 'package:smartship_partner/widget/long_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/router/router.dart';

class UserProfilePage extends StatefulWidget {
  static const TYPE_NEW = 0;
  static const TYPE_UPDATE = 1;

  String phoneNumber;
  int mode;
  UserInfoModel userInfoModel;

  UserProfilePage(
      {this.phoneNumber, this.mode = TYPE_NEW, this.userInfoModel}) {
    userInfoModel ??= UserInfoModel();
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      userInfoModel.phone = phoneNumber;
    }
  }

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends BaseState<UserProfilePage> {
  TextStyle _inputStyle;
  File _localAvatar;
  final _imagePicker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final UserProfileBloc _userProfileBloc =
      UserProfileBloc(UserProfileStartState());
  bool _loading = false;

  UserInfoModel _userInfoModel;

  List<AppB2BConfig> _listAreas = [];
  AppB2BConfig _selectedArea;

  @override
  void initState() {
    super.initState();
    _userInfoModel = widget.userInfoModel;
    Utils.eventBus.on<UpdateUserEvent>().listen((event) {
      setState(() {
        _loading = false;
      });
      if (event.updateSuccess) {
        if (widget.mode == CreateOrderStatus.TYPE_NEW) {
          RouterUtils.push(context, AppRouter.home, true);
        } else {
//          // Notify setting page that update success
          Navigator.pop(context, true);
        }
      } else {
        showSnackBar(
            context,
            event.message.isNotEmpty
                ? event.message
                : AppTranslations.of(context).text('error_try_again'));
      }
    });
    updateData();
    _userProfileBloc.add(LoadUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    _inputStyle = TextStyle(
        color: AppColors.colorGrey,
        fontSize: ScreenUtil().setSp(FontConfig.font_large));
    ScreenUtil.init(context, width: 375, height: 667, allowFontScaling: true);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: AppBarIcon(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              SystemNavigator.pop();
            }
          },
        ),
        title: Text(
          AppTranslations.of(context).text('update_user_info'),
          style: TextStyle(
              color: AppColors.colorAccent,
              fontSize: ScreenUtil().setSp(FontConfig.font_huge)),
        ),
      ),
      body: BlocBuilder(
        bloc: _userProfileBloc,
        builder: (context, state) {
          if (state is UserProfileLoadAreaConfigState) {
            _listAreas = (state.areas);
            _areaController.text = state.areaName;
          }
          return ModalProgressHUD(
            inAsyncCall: _loading,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
                child: Column(
                  children: <Widget>[
                    _userListTile(),
                    ..._inputFields(),
                    SizedBox(
                      height: 15,
                    ),

                    /// Update Button
                    Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(67),
                        child: LongButton(
                          onPressed: () {
                            _requestUpdateProfile();
                          },
                          backgroundColor: AppColors.colorPrimary,
                          text: widget.mode == UserProfilePage.TYPE_UPDATE
                              ? AppTranslations.of(context).text('update')
                              : AppTranslations.of(context).text('register'),
                          borderRadius: 30,
                          textStyle: TextStyle(
                              fontSize:
                                  ScreenUtil().setSp(FontConfig.font_very_huge),
                              color: Colors.white),
                        )),
                    SizedBox(
                      height: 15,
                    ),

                    /// Term of use
                    Visibility(
                      visible: widget.mode == UserProfilePage.TYPE_NEW,
                      child: _termOfUse(),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _userListTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(64),
              height: ScreenUtil().setWidth(64),
              child: Card(
                elevation: 5,
                shape: CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: _buildAvatar(),
              ),
            ),
            Positioned(
              right: 1,
              top: 1,
              child: GestureDetector(
                onTap: () {
                  print('open image picker');
                  _getImage();
                },
                child: Container(
                    child: SvgPicture.asset('assets/images/phone/ic_edit.svg',
                        height: ScreenUtil().setWidth(15))),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            height: ScreenUtil().setHeight(97),
            margin: const EdgeInsets.only(left: 15),
            child: TextField(
              controller: _descriptionController,
              style: _inputStyle,
              maxLines: 4,
              decoration: InputDecoration(
                border: _outlineInputBorder,
                hintText: 'Giới thiệu ngắn',
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAvatar() {
    if (_localAvatar != null ||
        (_userInfoModel.pictureUrl != null &&
            _userInfoModel.pictureUrl.isNotEmpty)) {
      return CircleAvatar(
        backgroundImage: _localAvatar != null
            ? FileImage(_localAvatar)
            : NetworkImage(_userInfoModel.pictureUrl),
      );
    }

    // otherwise, return default image
    return Image.asset('assets/images/phone/ic_place_holder.png');
  }

  List<Widget> _inputFields() {
    return [
      SizedBox(
        height: 15,
      ),

      /// User name
      Container(
        height: ScreenUtil().setHeight(60),
        child: TextField(
          style: _inputStyle,
          maxLines: 1,
          controller: _nameController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person_outline,
              color: AppColors.colorAccent,
              size: ScreenUtil().setWidth(16),
            ),
            border: _outlineInputBorder,
            hintText: AppTranslations.of(context).text('user_profile_name'),
          ),
        ),
      ),
      SizedBox(
        height: 15,
      ),

      /// Email
      Container(
        height: ScreenUtil().setHeight(60),
        child: TextField(
          controller: _emailController,
          style: _inputStyle,
          maxLines: 1,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.drafts,
              color: AppColors.colorAccent,
              size: ScreenUtil().setWidth(16),
            ),
            border: _outlineInputBorder,
            hintText: AppTranslations.of(context).text('user_email'),
          ),
        ),
      ),
      SizedBox(
        height: 15,
      ),

      /// Phone, phone can't be changed
      Container(
        height: ScreenUtil().setHeight(60),
        child: TextField(
          enabled: false,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          style: _inputStyle,
          maxLines: 1,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.smartphone,
              color: AppColors.colorAccent,
              size: ScreenUtil().setWidth(16),
            ),
            border: _outlineInputBorder,
            hintText: AppTranslations.of(context).text('user_phone'),
          ),
        ),
      ),

      SizedBox(
        height: 15,
      ),

      /// Area
      Container(
        height: ScreenUtil().setHeight(60),
        child: TextField(
          enabled: false,
          controller: _areaController,
          keyboardType: TextInputType.phone,
          style: _inputStyle,
          maxLines: 1,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.place,
              color: AppColors.colorAccent,
              size: ScreenUtil().setWidth(16),
            ),
            border: _outlineInputBorder,
            hintText: AppTranslations.of(context).text('your_area'),
          ),
        ),
      ),
    ];
  }

  Widget _termOfUse() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
              text: AppTranslations.of(context).text('termofUse_1'),
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(FontConfig.font_normal),
                  color: AppColors.colorGrey)),
          TextSpan(
              text: AppTranslations.of(context).text('termofUse_2'),
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(FontConfig.font_normal),
                  color: AppColors.colorAccent,
                  decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  _openTermOfUse();
                }),
          TextSpan(
              text: AppTranslations.of(context).text('termofUse_3'),
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(FontConfig.font_normal),
                  color: AppColors.colorGrey)),
        ],
      ),
    );
  }

  Future _getImage() async {
    var type = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return ImagePickerBottomSheet();
        });
    print('type: $type');
    if (type != null) {
      var file = await _imagePicker.getImage(source: type);
      if (file != null) {
        print('file: ' + file.path);
        setState(() {
          _localAvatar = File(file.path);
        });
      }
    }
//    var file = await FilePicker.getFile(type: FileType.image);
//    if (file != null) {
//      setState(() {
//        _localAvatar = file;
//      });
//    }
  }

  void _requestUpdateProfile() async {
    var request = UpdateUserRequest();
    var profile = NewProfile(
        displayName: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        shortDesc: _descriptionController.text);

    request.newProfile = profile;
    setState(() {
      _loading = true;
    });

    _userProfileBloc.add(UpdateUserProfileEvent(
        request, _selectedArea, _localAvatar != null ? _localAvatar.path : null));
  }

  void updateData() {
    print('data: ${_userInfoModel.shortDesc}');
    _phoneController.text = _userInfoModel.phone;
    _nameController.text = _userInfoModel.displayName ?? '';
    _descriptionController.text = _userInfoModel.shortDesc ?? '';
    _emailController.text = _userInfoModel.email ?? '';
  }

  void _openTermOfUse() async {
    _userProfileBloc.add(ShowTermOfUseEvent());
  }

  void _showAreaList() async {
    if (_listAreas != null && _listAreas.isNotEmpty) {
      var area = await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) {
            return AreaSelectDialog(_listAreas, true);
          });
      if (area != null) {
        _selectedArea = area;
        debugPrint('select area: ${_selectedArea.name}');
        _areaController.text = _selectedArea.name;
      }
    } else {
      print('List area is empty, can;t show dialog');
    }
  }
}

const OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(25)),
  borderSide: BorderSide(color: Color(0xffD1D1D1), width: 2.0),
);
