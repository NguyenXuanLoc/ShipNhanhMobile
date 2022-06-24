// @dart = 2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/data/model/shop_mall.dart';
import 'package:smartship_partner/widget/app_bar_icon.dart';

class LocationSuggestDetailPage extends StatefulWidget {
  final ShopMall shopMall;

  LocationSuggestDetailPage({@required this.shopMall});

  @override
  _LocationSuggestDetailState createState() => _LocationSuggestDetailState();
}

class _LocationSuggestDetailState extends State<LocationSuggestDetailPage> {
  final _noteTextController = TextEditingController();
  final PageController _imageController =
      PageController(initialPage: 0, keepPage: false, viewportFraction: 1);
  var _currentPageValue = 0;
  List<Picture> pictures = [];

  final _contentTextStyle = TextStyle(
      fontSize: ScreenUtil().setSp(FontConfig.font_medium),
      color: AppColors.colorBlack);

  final _inputDecoration = BoxDecoration(
    border: Border.all(
      color: AppColors.colorGreyStroke,
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(10)),
    color: AppColors.colorWhite,
  );

  @override
  void initState() {
    pictures = widget.shopMall.pictures ?? [];
    _currentPageValue = pictures.length > 1 ? 1 : 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: AppColors.colorDeliveredOrder,
          appBar: AppBar(
            backgroundColor: AppColors.colorAppbar,
            centerTitle: true,
            elevation: 0.0,
            title: Container(
              child: Column(
                children: [
                  Text(
                    '${widget.shopMall?.description ?? ''}',
                    style: TextStyle(
                        color: AppColors.colorBlack,
                        fontSize: FontConfig.font_large,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.shopMall?.address ?? ''}',
                    style: TextStyle(
                        color: AppColors.colorBlack,
                        fontSize: FontConfig.font_normal,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            leading: AppBarIcon(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
            ),
            actions: <Widget>[
              pictures.isNotEmpty && pictures[0].pictureUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(pictures[0].pictureUrl),
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.colorGreyStroke),
                    ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          body: _buildContent(context),
        ),
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        });
  }

  Widget _buildContent(BuildContext context) {
    var itemCount = pictures.isNotEmpty ? pictures.length - 1 : 0;
    return Container(
        color: itemCount == 0 ? AppColors.colorWhite : AppColors.colorBlack,
        child: Column(
          children: [
            if (itemCount > 0)
              ..._buildPageViewLayout(context, itemCount)
            else
              _buildEmptyView(context),
            _buildConfirmLayout(context)
          ],
        ));
  }

  /// When there's not image can be show in PageView, show a text instead
  Widget _buildEmptyView(BuildContext context) {
    return Expanded(
      child: Container(
        child: Center(
          child: Text(
            AppTranslations.of(context).text('no_menu_info'),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.colorAccent,
                fontSize: ScreenUtil().setSp(FontConfig.font_large)),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 80,
              padding:
                  const EdgeInsets.only(left: 10, right: 7, top: 0, bottom: 0),
              decoration: _inputDecoration,
              child: TextField(
                controller: _noteTextController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppTranslations.of(context)
                      .text('location_suggest_detail_input_place_holder'),
                ),
                style: _contentTextStyle,
                maxLines: 4,
              ),
            ),
          ),
          SizedBox(
            width: 7,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context, _noteTextController.text ?? '');
            },
            child: Container(
              height: 80,
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(
                          10.0) //                 <--- border radius here
                      ),
                  color: Colors.red),
              child: Text(
                AppTranslations.of(context).text('confirm'),
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(FontConfig.font_medium),
                    color: AppColors.colorWhite,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Layout PageView show the image in carousel + indicator
  List<Widget> _buildPageViewLayout(BuildContext context, int itemCount) {
    return [
      Expanded(
        child: Container(
          margin: EdgeInsets.all(15),
          child: PageView.builder(
            controller: _imageController,
            itemBuilder: (context, position) {
              return PhotoView(
                imageProvider: CachedNetworkImageProvider(
                  pictures.elementAt(_currentPageValue).pictureUrl,
                ),
                maxScale: PhotoViewComputedScale.covered * 2.0,
                minScale: PhotoViewComputedScale.contained * 0.8,
                initialScale: PhotoViewComputedScale.contained,
              );
            },
            itemCount: itemCount,
            onPageChanged: (page) {
              setState(() {
                _currentPageValue = page + 1;
              });
            },
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0), //                 <--- border radius here
            ),
            color: AppColors.colorBlackFade),
        child: Text(
          '$_currentPageValue/${pictures.isNotEmpty ? pictures.length - 1 : 0}',
          style: TextStyle(
              color: AppColors.colorWhite, fontSize: FontConfig.font_normal),
        ),
      )
    ];
  }
}
