// @dart = 2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/model/create_order_contact.dart';
import 'package:smartship_partner/data/network/response/here_map/searchPlace_response.dart';
import 'package:smartship_partner/data/repository/hereMap_repository.dart';
import 'package:smartship_partner/ui/location_select/place/place_select_bloc.dart';
import 'package:smartship_partner/ui/location_select/place/place_select_event.dart';
import 'package:smartship_partner/ui/location_select/place/place_select_state.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/confirm_order_dialog.dart';
import 'package:smartship_partner/widget/progress_hud.dart';
import 'package:smartship_partner/widget/search_field.dart';
import 'package:uuid/uuid.dart';

class PlaceSelectPage extends StatefulWidget {
  static const _TYPE_NEARBY = 0;
  static const _TYPE_AUTO_COMPLETE = 1;

  int _state;
  int _orderType;
  PlaceSelectPage(this._state, [this._orderType=CreateOrderCategory.TYPE_SHIP]);

  @override
  _PlaceSelectPageState createState() => _PlaceSelectPageState();
}

class _PlaceSelectPageState extends State<PlaceSelectPage> {
  final PlaceSelectBloc _bloc = PlaceSelectBloc(PlaceSelectStartState());
  List<CreateOrderContact> _listResult = [];
  //List<Prediction> _predictionList = [];
  List<HereSearchItem> _hereSeachItems = [];


  var _loadType = PlaceSelectPage._TYPE_NEARBY;

  /* Maps */
  final _geoPlaces = GoogleMapsPlaces(apiKey: Utils.googleMapKey);
  TextEditingController _searchController = TextEditingController();
  Timer _requestTimer;
  bool _isLoading = false;
  String _sessionToken = '';
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _sessionToken = uuid.v4();
    _setupHandleData();
    _isLoading = true;
    _bloc.add(PlaceSelectStartEvent(_searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        return _buildContent();
      },
    );
  }

  Widget _buildPlaceItem(CreateOrderContact item) {
    return InkWell(
      onTap: () {
        _onPlaceSelected(item);
      },
      child: ListTile(
        title: Text(
          item.address,
          style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: FontConfig.font_very_large,
              color: AppColors.colorTextNormal),
        ),
        leading: Icon(
          Icons.location_on,
          color: AppColors.colorAccent,
        ),
      ),
    );
  }

  Widget _buildPredictionItem(HereSearchItem item) {
    print('_buildPredictionItem ${item.title}');
    return InkWell(
      onTap: () {
//        _onPlaceSelected(item);
        _onPredictionItemSelected(item);
      },
      child: ListTile(
        title: Text(
          item.title + ', ' + item.address.label,
          style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: FontConfig.font_very_large,
              color: AppColors.colorTextNormal),
        ),
        leading: Icon(
          Icons.location_on,
          color: AppColors.colorAccent,
        ),
      ),
    );
  }

  /* Place selected, fire event to LocationSelectPage */
  void _onPlaceSelected(CreateOrderContact item) async {
    print('onPlace selected');
    var temp = CreateOrderContact(
        phone: item.phone,
        address: item.address,
        userName: item.userName,
        lat: item.lat,
        long: item.long);

    /// Sau khi chọn địa điểm, sẽ show ra dialog để xác nhận
//    var result = await showDialog(
//        context: context,
//        builder: (context) {
//          return ConfirmOrderDialog(temp, widget._state, false,);
//        });
    Navigator.pop(context, temp);
  }

  void _onPredictionItemSelected(HereSearchItem item) async {
    setState(() {
      _isLoading = true;
    });
    print('prediction item selected: ${item.title}');
    // var detail =
    //     await _geoPlaces.getDetailsByPlaceId(item.placeId);
    // setState(() {
    //   _isLoading = false;
    // });
    if (item != null) {
      print('detail: ${item.title}');
      var temp = CreateOrderContact(
          lat: item.position.lat,
          long: item.position.lng,
          address: item.title);

//      /// Sau khi chọn địa điểm, sẽ show ra dialog để xác nhận
//      var result = await showDialog(
//          context: context,
//          builder: (context) {
//            return ConfirmOrderDialog(temp, widget._state, false);
//          });
//      if (result != null) Navigator.pop(context, result);
      Navigator.pop(context, temp);
    }
  }

  void _requestOtherPlace() async {
    CreateOrderContact result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ConfirmOrderDialog(null, widget._state, false,widget._orderType);
        });
    if (result != null) {
      result.fromOtherPlace = true;
      Navigator.pop(context, result);
    }
  }

  void _setupHandleData() {
    Utils.eventBus.on<PlaceSearchResultEBEvent>().listen((event) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _listResult = event.result;
        });
      } else {
        _isLoading = false;
        _listResult = event.result;
      }
    });
  }

  /// Request load place after 1.5s use typed
  void _requestSearchPlace(text) async {
    if (_requestTimer != null && _requestTimer.isActive) {
      _requestTimer.cancel();
      _requestTimer = null;
    }

    _requestTimer = Timer(Duration(seconds: 1), () async {
      print('search: ${_searchController.text.isEmpty}');
      if (_searchController.text.isEmpty) {
        if (_loadType == PlaceSelectPage._TYPE_AUTO_COMPLETE) {
          setState(() {
            _hereSeachItems = [];
          });
        }
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // auto complete
      var searchItems = await _loadAutoCompleteWithText(text);
      print('search items count = ${searchItems.length}');
      setState(() {
        _isLoading = false;
        _loadType = PlaceSelectPage._TYPE_AUTO_COMPLETE;
        _hereSeachItems = searchItems;
      });
    });
  }



  Future<List<HereSearchItem>> _loadAutoCompleteWithText(String text) async {
    print('_loadAutoCompleteWithText $text');
    try {
      var currentPosition = await LocationUtil.getCurrentLocation();

      //currentPosition ??= await _getCurrentLocation();

      var hm_response = await HereMapRepository().searchPlace(currentPosition, text);
      if(hm_response != null &&
          hm_response.error == null &&
          hm_response.items.isNotEmpty){
        return hm_response.items ?? [];
      }
      return [];
    } catch (error) {
      print('load error: $error');
      return [];
    }
  }

  // Future<LatLng> _getCurrentLocation() async {
  //   print('load curent location');
  //   var position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   return LatLng(position.latitude, position.longitude);
  // }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  Widget _buildContent() {
    bool isNearby = _loadType == PlaceSelectPage._TYPE_NEARBY;
    print('place select page _buildContent');
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SearchField(
            onChanged: (text) async {
              _requestSearchPlace(text);
            },
            textController: _searchController,
          ),
          FlatButton.icon(
              onPressed: () {
                _requestOtherPlace();
              },
              icon: Icon(
                Icons.add,
                color: AppColors.colorCyan,
              ),
              label: Text(
                AppTranslations.of(context).text('other_place'),
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: FontConfig.font_very_large,
                    color: AppColors.colorCyan),
              )),
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                ListView.separated(
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Divider(
                          color: AppColors.colorGreyLight,
                        ),
                      );
                    },
                    itemCount:
                        isNearby ? _listResult.length : _hereSeachItems.length,
                    itemBuilder: (context, index) {
                      return isNearby
                          ? _buildPlaceItem(_listResult[index])
                          : _buildPredictionItem(_hereSeachItems[index]);
                    }),
                Visibility(
                  visible: _isLoading,
                  child: ProgressHUD(
                    backgroundColor: AppColors.colorWhiteTransparent,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
