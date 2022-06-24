// @dart = 2.9
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smartship_partner/base/base_state.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/config/router/route_util.dart';
import 'package:smartship_partner/config/router/router.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/create_order_contact.dart';
import 'package:smartship_partner/data/model/order/new_order.dart';
import 'package:smartship_partner/data/model/order_type.dart';
import 'package:smartship_partner/data/model/shipper_model.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/ui/create_order/create_order_event.dart';
import 'package:smartship_partner/ui/create_order/step1/create_order_step1.dart';
import 'package:smartship_partner/ui/location_select/location_select_page.dart';
import 'package:smartship_partner/ui/order/update_order/step1/update_order_step1_bloc.dart';
import 'package:smartship_partner/ui/order/update_order/update_order_event.dart';
import 'package:smartship_partner/ui/order/update_order/update_order_state.dart';
import 'package:smartship_partner/util/order_utils.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/confirm_order_dialog.dart';
import 'package:smartship_partner/widget/custom_listTile.dart';
import 'package:smartship_partner/widget/long_button.dart';

class UpdateOrderStep1Page extends StatefulWidget {
  final order;

  UpdateOrderStep1Page({@required this.order});

  @override
  _UpdateOrderStep1PageState createState() => _UpdateOrderStep1PageState();
}

class _UpdateOrderStep1PageState extends BaseOrderState<UpdateOrderStep1Page> {
  ScrollController _scrollController = ScrollController();
  StreamSubscription<Position> positionStream;
  List<String> listOrderTypeTitle;
  OrderType _orderType;
  final UpdateOrderStep1Bloc _bloc =
      UpdateOrderStep1Bloc(UpdateOrderStep1StartState());
  List<ShipperModel> shippers = [];

  NewOrder _order;
  String _filepath;
  bool _isLoading = false;

  /// Data đơn hàng
  /* Thông tin lấy hàng */
  CreateOrderContact _takeGoodsContactInfo;
  CreateOrderContact _giveGoodsContactInfo;

  /// Map
  final Set<Polyline> polyline = {};
  List<LatLng> routeCoords;
  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: Utils.googleMapKey);

  BitmapDescriptor _shipperMarkerIcon; // shi
  BitmapDescriptor _fromMarkerIcon;
  BitmapDescriptor _toMarkerIcon; // pper marker
  Set<Marker> _markers;
  var geolocator = Geolocator();
  final locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  LatLng _currentPosition;
  Completer<GoogleMapController> _controller = Completer();

  /// Style
  final _takeGoodsTextController = TextEditingController();
  final _giveGoodsTextController = TextEditingController();
  final _noteController = TextEditingController();
  var _labelTextStyle;
  var _contentTextStyle;

  _UpdateOrderStep1PageState();

  @override
  void initState() {
    super.initState();
    _setupHandleNearbyShippers();
    handleUserDetail();
    _bloc.add(UpdateOrderStep1StartEvent());
  }

  void handleUserDetail() {
    _order = widget.order;
    _takeGoodsContactInfo = CreateOrderContact(
        phone: _order.onbehalfPhoneNumber,
        userName: _order.onbehalfName,
        address: _order.fromAddress,
        long: _order.fromLng,
        lat: _order.fromLat);

    _giveGoodsContactInfo = CreateOrderContact(
        phone: _order.receiverPhone,
        address: _order.toAddress,
        userName: _order.receiverName,
        long: _order.toLng,
        lat: _order.toLat);
    setState(() {
      _takeGoodsTextController.text = _order.fromAddress;
      _giveGoodsTextController.text = _order.toAddress;
      _noteController.text = _order.notes;
      _orderType = _mapValueToOrderType(_order.category);
    });
  }

  OrderType _mapValueToOrderType(int value) {
    for (var type in OrderType.values) {
      if (value == type.value) {
        return type;
      }
    }
    return OrderType.DELIVER;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget getLayout(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 667, allowFontScaling: true);
    _loadMarkerIcon();
    initStyle();

    listOrderTypeTitle = [
      AppTranslations.of(context).text('order_type_ship'),
      AppTranslations.of(context).text('order_type_buying'),
      AppTranslations.of(context).text('order_type_grab')
    ];
    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed();
      },
      child: Scaffold(
        key: scaffoldKey,
        body: BlocBuilder(
          bloc: _bloc,
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: _isLoading,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          _mapLayout(),
                          _topLayout(),
                        ],
                      ),
                    ),
                  ),

                  /// Next btn
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: const EdgeInsets.only(bottom: 5),
                    child: LongButton(
                      fontSize: ScreenUtil().setSp(15),
                      height: 40,
                      text: AppTranslations.of(context).text('done'),
                      onPressed: _onDonePressed,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void initStyle() {
    _labelTextStyle = TextStyle(
        fontFamily: FontConfig.fontSen,
        fontSize: ScreenUtil().setSp(FontConfig.font_x_small),
        color: AppColors.colorAccent);

    _contentTextStyle = TextStyle(
        fontSize: ScreenUtil().setSp(FontConfig.font_medium),
        color: AppColors.colorBlack);
  }

  /// The top layout, include Header, PlaceSelect
  Widget _topLayout() {
    return Column(
      children: <Widget>[
        _headerLayout(),
        Expanded(
          child: Container(),
        ),
        _placeSelectLayout(),
      ],
    );
  }

  /// Header layout, include action button and select order type
  Widget _headerLayout() {
    return Container(
      alignment: Alignment.topCenter,
      margin:
          EdgeInsets.only(left: 15, top: MediaQuery.of(context).padding.top),
      height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            onPressed: () {
              _onBackPressed(true);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.colorAccent,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: listOrderTypeTitle.length,
                // itemExtent: 10.0,
                // reverse: true, //makes the list appear in descending order
                itemBuilder: (BuildContext context, int index) {
                  return _buildItems(index);
                }),
          ),
        ],
      ),
    );
  }

  Widget _placeSelectLayout() {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Lấy hàng
            InkWell(
              onTap: () {
                _onTakeGoodsPlaceClicked();
              },
              child: CustomListTile(
                leading: Container(
                  child: SvgPicture.asset(
                    'assets/images/phone/ic_dot_outline.svg',
                    height: ScreenUtil().setWidth(8),
                  ),
                ),
                title: Text(
                  _getFromPlaceTitle(),
                  style: _labelTextStyle,
                ),
                subtitle: TextField(
                  controller: _takeGoodsTextController,
                  style: _contentTextStyle,
                  enabled: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          AppTranslations.of(context).text('select_place')),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.colorGreyStroke,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
                child: SvgPicture.asset(
                  'assets/images/phone/ic_dot_fill.svg',
                  height: ScreenUtil().setWidth(4),
                )),
            SizedBox(
              height: 15,
            ),
            Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
                child: SvgPicture.asset(
                  'assets/images/phone/ic_dot_fill.svg',
                  height: ScreenUtil().setWidth(4),
                )),

            /// Giao hang
            InkWell(
              onTap: _onGiveGoodsPlaceClicked,
              child: CustomListTile(
                leading: Container(
                  child: SvgPicture.asset(
                    'assets/images/phone/ic_dot_fill.svg',
                    height: ScreenUtil().setWidth(8),
                  ),
                ),
                title: Text(
                  _getToPlaceTitle(),
                  style: _labelTextStyle,
                ),
                subtitle: TextField(
                  controller: _giveGoodsTextController,
                  enabled: false,
                  style: _contentTextStyle,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          AppTranslations.of(context).text('select_place')),
                ),
//                Text(
//                  _giveGoodsContactInfo != null
//                      ? _giveGoodsContactInfo.address
//                      : '',
//                  style: _contentTextStyle,
//                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.colorGreyStroke,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),

            /// Ghi chú
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
              child: Text(
                AppTranslations.of(context).text('note'),
                style: _labelTextStyle,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
              child: TextField(
                controller: _noteController,
                style: _contentTextStyle,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppTranslations.of(context).text('enter_note')),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getToPlaceTitle() {
    return _orderType == OrderType.SHIPPER
        ? AppTranslations.of(context).text('to_place')
        : AppTranslations.of(context).text('give_goods');
  }

  String _getFromPlaceTitle() {
    return _orderType == OrderType.SHIPPER
        ? AppTranslations.of(context).text('from_place')
        : AppTranslations.of(context).text('take_goods');
  }

  Widget _mapLayout() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: GoogleMap(
        markers: _markers,
        mapType: MapType.normal,
        polylines: polyline,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: _onMapCreated,
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: _currentPosition ?? Constants.DEFAULT_POSITION,
          zoom: 17,
        ),
      ),
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _setupLocation();
  }

  Widget _buildItems(int index) {
    var orderType = _mapOrderType(index);
    final button = LongButton(
      singleLine: true,
      width: ScreenUtil().setWidth(120),
      fontSize: ScreenUtil().setSp(FontConfig.font_medium),
      height: null,
      onPressed: () {
        _goToOrderTypeItem(index);
        setState(() {
          _orderType = orderType;
        });
        _bloc.add(UpdateOrderTypeChangeEvent(orderType));
      },
      backgroundColor: _orderType == orderType
          ? AppColors.colorAccent
          : AppColors.colorWhite,
      textColor: _orderType == orderType
          ? AppColors.colorWhite
          : AppColors.colorAccent,
      text: listOrderTypeTitle[index],
    );

    return Container(
        // color: Colors.blue,
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: Row(children: [
          button,
        ]));
  }

  /// return true to apply backpressed from system
  bool _onBackPressed([bool force = false]) {
    if (force) {
      Navigator.of(context).pop();
    }
    return true;
  }

  void _setupLocation() async {
    print('load curent location');
    LatLng latlng = await LocationUtil.getCurrentLocation();
    _currentPosition = latlng;

    // Draw the directions if possible
    if (_takeGoodsContactInfo != null &&
        _takeGoodsContactInfo.isLocationValid() &&
        _giveGoodsContactInfo != null &&
        _giveGoodsContactInfo.isLocationValid()) {
      getDirections(_takeGoodsContactInfo.getLocation(),
          _giveGoodsContactInfo.getLocation());
    } else {
      _moveCamera(latlng);
    }
  }

  // Future<LatLng> _loadCurrentPosition() async {
  //   var position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   var latlng = LatLng(position.latitude, position.longitude);
  //   return latlng;
  // }

  void _loadMarkerIcon() async {
    var imageConfig = ImageConfiguration(
        devicePixelRatio: MediaQuery.of(context).devicePixelRatio);

    var ship = await BitmapDescriptor.fromAssetImage(
        imageConfig, 'assets/images/phone/bike_small.png',
        mipmaps: false);

    var from = await BitmapDescriptor.fromAssetImage(
        imageConfig, 'assets/images/phone/ic_marker_from.png',
        mipmaps: false);

    var to = await BitmapDescriptor.fromAssetImage(
        imageConfig, 'assets/images/phone/ic_marker_to.png',
        mipmaps: false);

    _shipperMarkerIcon = ship;
    _fromMarkerIcon = from;
    _toMarkerIcon = to;
    Set<Marker> markerList = (await _buildMarkerList()).toSet();
    if (markerList.isNotEmpty) {
      setState(() {
        _markers = markerList;
      });
    }
  }

  void _moveCamera(LatLng currentPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(currentPosition));
  }

  /// If take goods data exist, show dialog, otherwise, show [LocationSelectPage]
  void _onTakeGoodsPlaceClicked() async {
    if (_takeGoodsContactInfo != null) {
      print('currentAddress: ${_takeGoodsContactInfo.address}');
      var result = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return ConfirmOrderDialog(_takeGoodsContactInfo,
                LocationSelectPage.TYPE_FROM, true, _orderType.value);
          });
      if (result != null) {
        _takeGoodsContactInfo = result;
        var markerList = (await _buildMarkerList()).toSet();
        setState(() {
          if (markerList.isNotEmpty) {
            _markers = markerList;
          }
          _takeGoodsTextController.text = _takeGoodsContactInfo.address;
          if (_takeGoodsContactInfo.note != null && _takeGoodsContactInfo.note.isNotEmpty){
            _noteController.text = _takeGoodsContactInfo.note;
          }
        });
      }
    } else {
      CreateOrderContact result = await RouterUtils.push(
          context,
          AppRouter.placeSelect +
              '/' +
              LocationSelectPage.TYPE_FROM.toString() +
              '/' +
              _orderType.toString());

      if (result != null) {
        print('select place: ${result.lat} x ${result.long}');
        _takeGoodsContactInfo = result;
        var markerList = (await _buildMarkerList()).toSet();
        setState(() {
          if (markerList.isNotEmpty) {
            _markers = markerList;
          }
          _takeGoodsTextController.text = _takeGoodsContactInfo.address;
        });
        print('currentAddress: ${_takeGoodsContactInfo.address}');
      }
    }

    if (_takeGoodsContactInfo.isLocationValid()) {
      if (_giveGoodsContactInfo != null &&
          _giveGoodsContactInfo.isLocationValid()) {
        /// Nếu đủ cả 2 địa chỉ thì vẽ route
        getDirections(_takeGoodsContactInfo.getLocation(),
            _giveGoodsContactInfo.getLocation());
      } else {
        /// Không thì move camera đến địa điểm vừa chọn
        _moveCamera(_takeGoodsContactInfo.getLocation());
      }
    }
  }

  /// If give goods data exist, show dialog, otherwise, show [LocationSelectPage]
  void _onGiveGoodsPlaceClicked() async {
    if (_giveGoodsContactInfo != null) {
      print('currentAddress: ${_giveGoodsContactInfo.address}');
      var result = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return ConfirmOrderDialog(_giveGoodsContactInfo,
                LocationSelectPage.TYPE_TO, true, _orderType.value);
          });
      if (result != null) {
        _giveGoodsContactInfo = result;
        var markerList = (await _buildMarkerList()).toSet();

        setState(() {
          if (markerList.isNotEmpty) {
            _markers = markerList;
          }
          _giveGoodsTextController.text = _giveGoodsContactInfo.address;
        });
      }
    } else {
      CreateOrderContact result = await RouterUtils.push(
          context,
          AppRouter.placeSelect +
              '/' +
              LocationSelectPage.TYPE_TO.toString() +
              '/' +
              _orderType.toString());
      if (result != null) {
        _giveGoodsContactInfo = result;
        print('currentAddress: ${_giveGoodsContactInfo.address}');
        var markerList = (await _buildMarkerList()).toSet();
        setState(() {
          if (markerList.isNotEmpty) {
            _markers = markerList;
          }
          _giveGoodsTextController.text = _giveGoodsContactInfo.address;
        });
      }
    }

    if (_giveGoodsContactInfo.isLocationValid()) {
      if (_takeGoodsContactInfo != null &&
          _takeGoodsContactInfo.isLocationValid()) {
        /// Nếu đủ cả 2 địa chỉ thì vẽ route
        getDirections(_takeGoodsContactInfo.getLocation(),
            _giveGoodsContactInfo.getLocation());
      } else {
        /// Không thì move camera đến địa điểm vừa chọn
        _moveCamera(_giveGoodsContactInfo.getLocation());
      }
    }
  }

  /// Next button pressed, check the condition to return step2
  _onDonePressed() async {
    var stringToBase64Url = utf8.fuse(base64Url);
    if (_takeGoodsContactInfo == null || _giveGoodsContactInfo == null) {
      showSnackBar(
          context, AppTranslations.of(context).text('place_select_empty'));
      return;
    }

    /// bắt buộc có thông tin lấy hàng
    if (_takeGoodsContactInfo.userName == null ||
        _takeGoodsContactInfo.phone == null ||
        _takeGoodsContactInfo.userName.isEmpty ||
        _takeGoodsContactInfo.phone.isEmpty) {
      showSnackBar(
          context, AppTranslations.of(context).text('missing_from_user_info'));
      return;
    }

    if (_giveGoodsContactInfo.userName == null ||
        _giveGoodsContactInfo.phone == null ||
        _giveGoodsContactInfo.userName.isEmpty ||
        _giveGoodsContactInfo.phone.isEmpty) {
      if (_orderType != OrderType.SHIPPER) {
        showSnackBar(
            context, AppTranslations.of(context).text('missing_to_user_info'));
        return;
      }
    }
    setState(() {
      _isLoading = true;
    });

    await _buildOrder();
    await _calculateShipFee();
    var filePath = ((_filepath != null && _filepath.isNotEmpty)
        ? stringToBase64Url.encode(_filepath)
        : '');

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context, [_order, _order == null ? null : filePath]);
  }

  Future _calculateShipFee() async {
    if (_takeGoodsContactInfo?.fromOtherPlace == true ||
        _giveGoodsContactInfo?.fromOtherPlace == true) {
      // Select from other place, return 15000 default ship fee
      _order.distance = 0;
      _order.shipFee = CreateOrderStep1Page.OTHER_PLACE_SHIP_FEE;
      return;
    }
    var distance = await geolocator.distanceBetween(
            _takeGoodsContactInfo.lat,
            _takeGoodsContactInfo.long,
            _giveGoodsContactInfo.lat,
            _giveGoodsContactInfo.long) ??
        0.0;

    distance = (distance / 1000);
    print('distance: $distance');
    _order.distance = distance;
    // calculate ship fee
    var user = await UserRepository.get(PrefsManager.get).getUserInfo();
    _order.shipFee = OrderUtil.calculateShipFee(
        user.baseShipFee, user.baseDistance, distance, user.extraShipFee);
  }

  /// Return the real equest order type
  OrderType _mapOrderType(int orderIndex) {
    switch (orderIndex) {
      case 0:
        return OrderType.DELIVER;
      case 1:
        return OrderType.ORDER_FOR_SOMEONE;
      case 2:
        return OrderType.SHIPPER;
      default:
        return OrderType.DELIVER;
    }
  }

  /// Build the Order for entering Step 2
  Future<void> _buildOrder() async {
    _order ??= NewOrder();
    _order.notes = _noteController.text;
    _order.fromAddress = _takeGoodsContactInfo.address;
    _order.toAddress = _giveGoodsContactInfo.address;
    _order.receiverPhone = _giveGoodsContactInfo.phone ?? '';
    _order.receiverName = _giveGoodsContactInfo.userName ?? '';
    _order.category = _orderType.value;
    _order.onbehalfName = _takeGoodsContactInfo.userName ?? '';
    _order.onbehalfPhoneNumber = _takeGoodsContactInfo.phone ?? '';
    _order.isOnbehalf = _orderType == OrderType.ORDER_FOR_SOMEONE;
    _order.fromLat = _takeGoodsContactInfo.lat ?? 0;
    _order.fromLng = _takeGoodsContactInfo.long ?? 0;
    _order.toLat = _giveGoodsContactInfo.lat ?? 0;
    _order.toLng = _giveGoodsContactInfo.long ?? 0;

    if (_orderType == OrderType.ORDER_FOR_SOMEONE) {
      _order.idShopMall = _takeGoodsContactInfo.shopMallId;
    } else {
      _order.idShopMall = 0;
    }
  }

  Future<List<Marker>> _buildMarkerList() async {
    var listMarker = List<Marker>();
    if (shippers.isNotEmpty) {
      listMarker.addAll(shippers.map((item) {
        return Marker(
            markerId: MarkerId(item.userId.toString()),
            position: LatLng(item.latitude, item.longitude),
            icon: _shipperMarkerIcon);
      }));
    }

    if (_takeGoodsContactInfo != null) {
      listMarker.add(Marker(
          markerId: MarkerId('fromMarker'),
          position:
              LatLng(_takeGoodsContactInfo.lat, _takeGoodsContactInfo.long),
          icon: _fromMarkerIcon ?? BitmapDescriptor.defaultMarker));
    }

    if (_giveGoodsContactInfo != null) {
      listMarker.add(Marker(
          markerId: MarkerId('toMarker'),
          position:
              LatLng(_giveGoodsContactInfo.lat, _giveGoodsContactInfo.long),
          icon: _toMarkerIcon ?? BitmapDescriptor.defaultMarker));
    }
    return listMarker;
  }

  void _setupHandleNearbyShippers() async {
    Utils.eventBus.on<NearbyShipperLoadedEBEvent>().listen((event) {
      shippers.clear();
      shippers.addAll(event.data);
      _buildMarkerList().then((value) {
        setState(() {
          _markers = value.toSet();
        });
      });
    });
  }

  void getDirections(LatLng from, LatLng to) async {
    if (from.latitude != 0 &&
        from.longitude != 0 &&
        to.latitude != 0 &&
        to.longitude != 0) {
      /// only draw the direction if the position of both from and to is valid
      try {
        routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
            origin: from, destination: to, mode: RouteMode.driving);
        setState(() {
          polyline.clear();
          polyline.add(Polyline(
              polylineId: PolylineId('route'),
              visible: true,
              points: routeCoords,
              width: 4,
              color: AppColors.colorAccent,
              startCap: Cap.roundCap,
              endCap: Cap.buttCap));
        });

        // Move camera
        var minLat = Utils.minValue([from.latitude, to.latitude]);
        var minLng = Utils.minValue([from.longitude, to.longitude]);
        var maxLat = Utils.maxValue([from.latitude, to.latitude]);
        var maxLng = Utils.maxValue([from.longitude, to.longitude]);
        _animateCameraBound(CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(maxLat, maxLng),
            southwest: LatLng(minLat, minLng),
          ),
          30.0,
        ));
      } catch (error) {
        print('load direction failed: $error');
      }
    }
  }

  void _animateCameraBound(CameraUpdate newLatLngBounds) async {
    // ignore: omit_local_variable_types
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(newLatLngBounds);
  }

  void _goToOrderTypeItem(int index) {
    _scrollController.animateTo((ScreenUtil().setWidth(120) * index),
        // 100 is the height of container and index of 6th element is 5
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut);
  }
}
