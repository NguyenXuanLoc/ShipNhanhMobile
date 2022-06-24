// @dart = 2.9
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:smartship_partner/base/base_state.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/config/router/route_util.dart';
import 'package:smartship_partner/eventbus/login_success_event.dart';
import 'package:smartship_partner/ui/login/login.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/app_bar_widget.dart';
import 'package:smartship_partner/widget/long_button.dart';

import '../../config/router/router.dart';
import 'login.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage> {
  final _loginBloc = LoginBloc(LoginStartState());
  final _phoneNumberController = TextEditingController();
  var _phoneNumber = '';
  var _otpText = '';
  CountryCode _countryCode;
  final _title = 'Nhập số điện thoại';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    Utils.eventBus.on<LoginLoadingEvent>().listen((event) {
      setState(() {
        _loading = event.loading;
      });
    });
    Utils.eventBus.on<LoginSuccessEvent>().listen((event) {
      print('event: ${event.message} ${_loginBloc.state.runtimeType}');
      setState(() {
        _loading = false;
      });
      if (event.loginSuccess) {
        if (event.missingUserInfo) {
          RouterUtils.push(
              context, AppRouter.profile + '/' + _phoneNumber, true);
        } else {
          RouterUtils.push(context, AppRouter.home, true);
        }
      } else {
        if (_loginBloc.state is OtpState) {
          showDialog(
              context: context,
              builder: (context) {
                return _buildOtpErrorDialog(event.message);
              });
        } else {
          showSnackBar(
              context,
              event.message.isNotEmpty
                  ? event.message
                  : AppTranslations.of(context).text('error_try_again'));
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 667, allowFontScaling: true);
    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed();
      },
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        key: scaffoldKey,
        appBar: AppBarWidget(
          centerTitle: false,
          showIcon: true,
          title: AppTranslations.of(context).text('login_with_phone'),
          onActionTap: _onBackPressed,
        ),
        body: BlocBuilder(
          bloc: _loginBloc,
          builder: (context, state) {
            return ModalProgressHUD(
              child: _getLayoutByState(state),
              inAsyncCall: _loading,
            );
          },
        ),
      ),
    );
  }

  Widget _getLayoutByState(LoginState state) {
    switch (state.runtimeType) {
      case LoginStartState:
        return _buildLoginForm();
      case OtpState:
        return _buildOtpForm();
      default:
        return Container();
    }
  }

  /// Build layout where user has to input phone number
  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 15, right: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              // country code
              Card(
                child: CountryCodePicker(
                  onChanged: (countryCode) {
                    print(countryCode);
                    _countryCode = countryCode;
                  },
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'VN',
                  favorite: ['+84', 'VN'],
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                ),
              ),

              Expanded(
                child: Container(
                  height: ScreenUtil().setHeight(112),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 15),
                  child: TextField(
                    controller: _phoneNumberController,
                    style: TextStyle(
                        color: AppColors.colorPrimary,
                        fontSize: ScreenUtil().setSp(FontConfig.font_large)),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    // Only numbers can be ent
                    // red
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: AppColors.colorPrimary,
                          fontSize: ScreenUtil().setSp(FontConfig.font_large)),
                      labelText: 'Số điện thoại',
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.colorPrimary, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 15),
            child: LongButton(
              fontSize: FontConfig.font_very_large,
              height: ScreenUtil().setHeight(50),
              backgroundColor: AppColors.colorAccent,
              text: AppTranslations.of(context).text('confirm_phone_number'),
              onPressed: _verifyPhoneNumber,
            ),
          )
        ],
      ),
    );
  }

  /// Build layout where user enter OTP code
  Widget _buildOtpForm() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 40, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppTranslations.of(context).text('input_received_otp'),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(FontConfig.font_large),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Text(
            _phoneNumber,
            style: TextStyle(
                color: Colors.blue,
                fontSize: ScreenUtil().setSp(FontConfig.font_large)),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
            flex: 1,
            child: OTPTextField(
              length: 6,
              width: double.infinity,
              fieldStyle: FieldStyle.underline,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              onCompleted: (text) {
                // dismiss keyboard
                FocusScope.of(context).unfocus();
                _otpText = text;
              },
              style: TextStyle(
                  fontSize: FontConfig.font_very_huge,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 4, child: Container()),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 15),
            child: LongButton(
              fontSize: FontConfig.font_very_large,
              height: ScreenUtil().setHeight(50),
              text: 'Xác nhận'.toUpperCase(),
              onPressed: _verifyOtp,
            ),
          )
        ],
      ),
    );
  }

  String _validatePhoneNumber(String value) {
    if (value == null || value.isEmpty) {
      return 'Phone number must not be empty.';
    }
    return null;
  }

  void _verifyPhoneNumber() {
    if (_phoneNumberController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      setState(() {
        _loading = true;
      });
      _phoneNumber = (_countryCode == null ? '+84' : _countryCode.dialCode) +
          _phoneNumberController.text;
      _loginBloc.add(SendPhoneNumberEvent(_phoneNumber));
    }
  }

  void _verifyOtp() {
    if (_otpText != null && _otpText.isNotEmpty) {
      setState(() {
        _loading = true;
      });
      _loginBloc.add(VerifyOtpEvent(_otpText));
    }
  }

  Widget _buildOtpErrorDialog(String message) {
    return AlertDialog(
      title: Text(
        AppTranslations.of(context).text('login_error_title'),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          mainAxis: Axis.vertical,
          children: <Widget>[
            Visibility(
              visible: message!=null && message.isNotEmpty,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: AppColors.colorBlack,
                      fontSize: ScreenUtil().setSp(FontConfig.font_medium),
                    ),
                  ),
                  SizedBox(height: 15,)
                ],
              ),
            ),
            Text(AppTranslations.of(context).text('try_again'),
                style: TextStyle(
                  color: AppColors.colorBlack,
                  fontSize: ScreenUtil().setSp(FontConfig.font_medium),
                  fontWeight: FontWeight.bold
                )),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            AppTranslations.of(context).text('ok'),
            style: TextStyle(
                color: AppColors.colorAccent, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            _verifyOtp();
          },
        ),
        FlatButton(
          child: Text(AppTranslations.of(context).text('cancel'),
              style: TextStyle(
                  color: AppColors.colorAccent, fontWeight: FontWeight.bold)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  /// return true to apply backpressed from system
  bool _onBackPressed() {
    if (_loginBloc.state.runtimeType == OtpState) {
      _loginBloc
          .add(LoginPageNavigationEvent(pageType: LoginPageType.phonePage));
      return false;
    } else {
      Navigator.pop(context);
    }
    return false;
  }
}
