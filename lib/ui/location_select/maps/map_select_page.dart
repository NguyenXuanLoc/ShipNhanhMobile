// @dart = 2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/model/create_order_contact.dart';
import 'package:smartship_partner/data/repository/hereMap_repository.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/confirm_order_dialog.dart';
import 'package:smartship_partner/widget/long_button.dart';
import 'package:smartship_partner/util/utils.dart';

class MapSelectPage extends StatefulWidget {
  int _state;

  MapSelectPage(this._state);

  @override
  _MapSelectPageState createState() => _MapSelectPageState();
}

class _MapSelectPageState extends State<MapSelectPage> {
  /* Maps */
  //final _geoPlace = GoogleMapsPlaces(apiKey: Utils.googleMapKey);
  Address _selectedAddress = null;
  LatLng _currentPosition; // Current position of marker
  StreamSubscription<Position> positionStream;
  var geolocator = Geolocator();
  final Completer<GoogleMapController> _controller = Completer();
  final locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _currentPosition = await LocationUtil.getCurrentLocation();

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          GoogleMap(
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _currentPosition ?? Constants.DEFAULT_POSITION,
              zoom: 17,
            ),
            onCameraMove: (CameraPosition position) async {
              print('onCameraMove');
              _currentPosition = position.target;
            },
            onCameraIdle: () {
              print('onCameraIdle');
              _requestLoadPlace();
            },
            onMapCreated: _onMapCreated,
          ),
          //Marker pin
          Center(
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.place,
                color: Colors.red,
                size: 50,
              ),
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Card(
                elevation: 3,
                color: AppColors.colorWhite,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Text(
                        _selectedAddress != null
                            ? _selectedAddress.addressLine
                            : '',
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: FontConfig.font_very_large,
                            color: AppColors.colorTextNormal),
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      LongButton(
                        fontSize: FontConfig.font_large,
                        height: null,
                        text: AppTranslations.of(context).text('choose'),
                        onPressed: () {
                          _confirmSelectPlace();
                        },
                        borderRadius: 25,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // _getCurrentLocation() async {
  //   print('load curent location');
  //   var position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   var latlng = LatLng(position.latitude, position.longitude);
  //   _currentPosition = latlng;
  //   _moveCamera(latlng);
  // }

  void _moveCamera(LatLng currentPosition) async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .moveCamera(CameraUpdate.newLatLngZoom(currentPosition, 17));
  }

  /// When camera is idle after move, request call place
  void _requestLoadPlace() async {
    print('requestPlace');
    if (_currentPosition != null) {
      final coordinates =
          Coordinates(_currentPosition.latitude, _currentPosition.longitude);
      // var addresses =
      //     await Geocoder.local.findAddressesFromCoordinates(coordinates);

      var hm_addresses =  await HereMapRepository().getNearbyPlace(_currentPosition);

      if (hm_addresses != null &&
          hm_addresses.error == null &&
          hm_addresses.results != null &&
          hm_addresses.results.items.isNotEmpty) {
        setState(() {
          var firstItem = hm_addresses.results.items.first;
          final firstCoordinates =
          Coordinates(firstItem.position.first, firstItem.position.last);
          var firstAddress = Address(coordinates: firstCoordinates,
              addressLine:firstItem.title + ', ' + Utils.stripHtmlIfNeeded(firstItem.vicinity),
              countryName:null,
              countryCode:null,
              featureName:null,
              postalCode:null,
              locality:null,
              subLocality:null,
              adminArea:null,
              subAdminArea:null,
              thoroughfare:null,
              subThoroughfare:null);
          _selectedAddress = firstAddress;
        });
      }
    }
  }

  void _confirmSelectPlace() async {
    if (_selectedAddress != null) {
      var temp = CreateOrderContact(
          userName: '',
          address: _selectedAddress.addressLine,
          long: _selectedAddress.coordinates.longitude,
          lat: _selectedAddress.coordinates.latitude,
          phone: '');

      /// Sau khi chọn địa điểm, sẽ show ra dialog để xác nhận
//      var result = await showDialog(
//          context: context,
//          builder: (context) {
//            return ConfirmOrderDialog(temp, widget._state, false);
//          });

      Navigator.pop(context, temp);
    }
  }
}
