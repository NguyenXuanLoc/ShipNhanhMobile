// @dart = 2.9
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/location_model.dart';
import 'package:smartship_partner/data/model/user_info.dart';
import 'package:smartship_partner/data/network/request/device/register_device_request.dart';
import 'package:smartship_partner/data/network/request/login_request.dart';
import 'package:smartship_partner/data/network/response/login/login_response.dart';
import 'package:smartship_partner/data/repository/config_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/eventbus/login_success_event.dart';
import 'package:smartship_partner/ui/login/login.dart';
import 'package:smartship_partner/util/utils.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;
  ConfigRepository _configRepository;

  final _auth = FirebaseAuth.instance;
  String _phoneNumber = '';
  String _verificationId = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  LoginBloc(LoginState initialState) : super(initialState) {
    _userRepository = UserRepository.get(PrefsManager.get);
    _configRepository = ConfigRepository.get();
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    print('map event to state: ' + event.runtimeType.toString());
    switch (event.runtimeType) {
      case SendPhoneNumberEvent:
        await registerUser((event as SendPhoneNumberEvent).phoneNumber);
        break;
      case CodeSentEvent:
        Utils.eventBus.fire(LoginLoadingEvent(loading: false));
        yield OtpState();
        return;
      case VerifyOtpEvent:
        await _signInWithOtp((event as VerifyOtpEvent).otpNumber);
        return;
      case LoginPageNavigationEvent:
        yield LoginStartState();
        return;
    }
  }

  /// Register to firebase
  Future registerUser(String mobilePhone) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: mobilePhone,
          timeout: Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            //This callback would gets called when verification is done automatically
            var result = await _auth.signInWithCredential(phoneAuthCredential);
            var user = result.user;
            print('Firebase authentication success: ' +
                user.uid +
                ' -- ' +
                user.phoneNumber);
            var uid = user.uid;
//          String authToken = (await user.getIdToken(refresh: true)).token;
            await _onFirebaseAuthSuccess(user);
          },
          verificationFailed: (error) async {
            print('verificationFailed');
            _onLoginError(error);
          },
          codeSent: ((String verificationId, [int forceResendingToken]) {
            _verificationId = verificationId;
            print('code Sent' + verificationId);
            add(CodeSentEvent());
          }),
          codeAutoRetrievalTimeout: (String verificationId) {
            print('codeAutoRetrievalTimeout');
          });
    } catch (error) {
      _onLoginError(error);
    }
  }

  /// Sign in with Firebase
  Future _signInWithOtp(String otp) async {
    try {
      var credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: otp);
      var result = await _auth.signInWithCredential(credential);
      var user = result.user;
      if (user != null) {
        print('Firebase authentication success: ' +
            user.uid +
            ' -- ' +
            user.phoneNumber);
        await _onFirebaseAuthSuccess(user);
      } else {
        throw Exception('Firebase user null');
      }
    } catch (error) {
      _onLoginError(error);
    }
  }

  /// Auth firebase done, login with APi
  Future _onFirebaseAuthSuccess(firebaseAuth.User user) async {
    var loginRequest =
        LoginRequest(uId: user.uid, phoneNumber: user.phoneNumber);
    var loginData = await _userRepository.login(loginRequest);
    /* If success, check if account missing data */
    print('success: ' + loginData.isSuccess.toString());
    if (loginData != null) {
      if (loginData.isSuccess) {
        var userData = loginData.dataResponse;
        print('User Data: ' + jsonEncode(loginData));
        _onLoginSuccess(userData);
      } else {
        _onLoginError('', loginData.message);
      }
    } else {
      throw Exception('login data failed');
    }
  }

  /// Handle user data after login
  void _onLoginSuccess(LoginData loginData) async {
    await _saveUserInfo(loginData);

    /// Save policy & guide
    var termOfUse = loginData?.user?.termCondition ?? '';
    var instruction = loginData?.user?.guideUrl ?? '';
    debugPrint('term: $termOfUse -- instruction: $instruction');

    /// If termOfUser or guid is Empty, load remoteConfig instead
    if (termOfUse.isEmpty || instruction.isEmpty) {
      await _loadRemoteConfig();
    } else {
      await _configRepository.saveTermOfUse(termOfUse);
      await _configRepository.saveInstruction(instruction);
    }

    if (loginData.user != null) {
      await _registerDevice(loginData.user.authToken);
    }
    print('login success: ${loginData.isMissingUserInfo}');

    Utils.eventBus
        .fire(LoginSuccessEvent(missingUserInfo: loginData.isMissingUserInfo));
  }

  Future<void> _saveUserInfo(LoginData loginData) async {
    var user = loginData.user;
    var userInfoModel = UserInfoModel.fromUser(user);
//    var userInfoModel = UserInfoModel(
//        authToken: user.authToken,
//        number: user.number,
//        displayName: user.displayName,
//        email: user.email,
//        phone: user.phone,
//        pictureUrl: user.pictureUrl,
//        userId: user.userId,
//        totalRates: user.totalRates,
//        location: LocationModel(
//            lat: user.lat, lng: user.lng, address: user.workingAddress),
//        shopLat: user.whLat,
//        shopLng: user.whLng,
//        shopName: user.shopAdminName,
//        shopPhone: user.shopAdminPhone,
//        address: user.workingAddress,
//        baseShipFee: user.baseShipFee,
//        shopAddress: user.whAddress);
    _userRepository.saveUserInfo(userInfoModel);
  }

  void _onLoginError(error, [String message = '']) {
    print('Login error: $error');
    var msg = message;
    if (error is FirebaseException) {
      msg = error.message;
      print('${error.code} -- ${error.message}');
    }

    Utils.eventBus.fire(LoginSuccessEvent(loginSuccess: false, message: msg));
  }

  /// Register device to Server for receiving notification
  Future<void> _registerDevice(String authToken) async {
    var token = await _firebaseMessaging.getToken();
    if (token == null || token.isEmpty) {
      print("can't retrieve firebase token");
      return;
    }

    var request = RegisterDeviceRequest(
        authToken: authToken,
        deviceId: token,
        deviceType: Platform.isAndroid ? 1 : 2, // Android :1, iOS: 2
        oldDeviceId: '');
    var response = await _userRepository.registerDevice(request);
    if (response != null && response.isSuccess) {
      print('register device success :$token');
    } else {
      print('register device failed: ');
    }
  }

  Future _loadRemoteConfig() async {
    print('Load remote config: ');
    try {
      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      await remoteConfig.setDefaults(FirebaseConstants.DEFAULT_RMT_CONFIG);
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(hours: 5),
      ));
      await remoteConfig.fetchAndActivate();
      await _configRepository.saveTermOfUse(
          remoteConfig.getString(FirebaseConstants.KEY_TERM_OF_USE));
      await _configRepository.saveInstruction(
          remoteConfig.getString(FirebaseConstants.KEY_INSTRUCTION));
      print('save config success');
    } catch (error) {
      print('Load remote config error: $error');
    }
  }
}
