import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/router/route_util.dart';
import 'package:smartship_partner/config/router/router.dart';
import 'package:smartship_partner/data/model/create_order_contact.dart';
import 'package:smartship_partner/data/model/shop_mall.dart';
import 'package:smartship_partner/ui/location_select/suggest/location_suggest.dart';
import 'package:smartship_partner/widget/progress_hud.dart';
import 'package:smartship_partner/widget/search_field.dart';
import 'package:tiengviet/tiengviet.dart';

/// HIển thị đề xuất địa điểm, chỉ show khi loại đơn là Mua hộ
class LocationSuggestPage extends StatefulWidget {
  int _state;

  LocationSuggestPage(this._state);

  @override
  _LocationSuggestPageState createState() => _LocationSuggestPageState();
}

class _LocationSuggestPageState extends State<LocationSuggestPage> {
  final _bloc = LocationSuggestBloc(LocationSuggestStartState());
  List<ShopMall> _listShopMallOrigins = [];
  List<ShopMall> _listShopMallResult = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc.add(LocationSuggestStartEvent(_searchController.text));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case LocationSuggestLoadedState:
            _listShopMallOrigins =
                (state as LocationSuggestLoadedState).originData;
            _listShopMallResult =
                (state as LocationSuggestLoadedState).searchResultData;
            return _resultList(context);
          case LocationSuggestStartState:
            return ProgressHUD();
          default:
            return Container();
        }
      },
    );
  }

  Container _resultList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SearchField(
            onChanged: (text) async {
              _filterShopMalls();
            },
            textController: _searchController,
          ),
          SizedBox(
            height: 6,
          ),
          Expanded(
            child: GridView.builder(
                itemCount: _listShopMallResult.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1 / 1, crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  var item = _listShopMallResult[index];
                  return _buildPlaceItem(item);
                }),
          )
        ],
      ),
    );
  }

  Widget _buildPlaceItem(ShopMall item) {
    return InkWell(
      onTap: () {
        _onPlaceSelected(item);
      },
      child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: AppColors.colorAccent,
                  ),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: (item.pictures != null &&
                              item.pictures.isNotEmpty &&
                              item.pictures[0].pictureUrl != null &&
                              item.pictures[0].pictureUrl.isNotEmpty)
                          ? item.pictures[0].pictureUrl
                          : '',
                      placeholder: (context, url) => Image.asset(
                        'assets/images/phone/ic_place_holder.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColors.colorBlack.withOpacity(0.5),
                    AppColors.colorBlack.withOpacity(0)
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: FontConfig.font_large,
                            fontWeight: FontWeight.bold,
                            color: AppColors.colorWhite),
                      ),
                      Text(
                        item.address ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: FontConfig.font_normal,
                            color: AppColors.colorWhiteFade),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  /* Place selected, fire event to LocationSelectPage */
  void _onPlaceSelected(ShopMall mall) async {
    print('onPlace selected');
    var temp = CreateOrderContact(
        phone: mall.contactPhone,
        address: mall.description,
        userName: mall.contactName,
        shopMallId: mall.id,
        lat: mall.lat,
        long: mall.lng);

    /// Sau khi chọn địa điểm, sẽ show ra dialog để xác nhận
    var note = await _goToSuggestDetail(mall);
    if (note != null) {
      temp.note = note;

      Navigator.pop(context, temp);
    }
  }

  Future<String> _goToSuggestDetail(ShopMall shopMall) async {
    var stringToBase64Url = utf8.fuse(base64Url);
    return await RouterUtils.push(
        context,
        AppRouter.locationSuggestDetail +
            '/' +
            stringToBase64Url.encode(shopMallToJson(shopMall)));
  }

  void _filterShopMalls() async {
    var text = _searchController.text;
    if (text == null || text.isEmpty) {
      setState(() {
        _listShopMallResult.clear();
        _listShopMallResult.addAll(_listShopMallOrigins);
      });
    } else {
      text = text.toLowerCase();
      print('search text: ' + text);
      var dummyList = _listShopMallOrigins.where((mall) {
        /* Filter by description, address */
        var desctiption = (mall.description ?? '').toLowerCase();
        var address = (mall.address ?? '').toLowerCase();
        var des = TiengViet.parse(mall.description ?? '').toLowerCase();
        var addr = TiengViet.parse(mall.address ?? '').toLowerCase();
        return (desctiption.contains(text) ||
            address.contains(text) ||
            des.contains(text) ||
            addr.contains(text));
      }).toList();

      setState(() {
        _listShopMallResult.clear();
        _listShopMallResult.addAll(dummyList);
      });
    }
  }

}
