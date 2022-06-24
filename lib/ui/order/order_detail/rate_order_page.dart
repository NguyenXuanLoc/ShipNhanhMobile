// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/widget/long_button.dart';

class RateOrderDialog extends StatelessWidget {

  Function(int, String) onSendRateClicked;
  final TextEditingController _feedbackController = TextEditingController();
  var ratingCount = 1;

  RateOrderDialog({@required this.onSendRateClicked});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.colorWhite,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          /// Title
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.colorNewOrder,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    AppTranslations.of(context).text(
                      'rate_quality',
                    ),
                    textAlign: TextAlign.center,
                    style: _labelTextStyle.copyWith(
                        fontSize: FontConfig.font_huge),
                  ),
                ),
                InkWell(
                  onTap: () => {
                  Navigator.of(context).pop()
                },
                  child: Icon(
                    Icons.clear,
                    color: AppColors.colorAccent,
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.colorGrey,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: <Widget>[
                Center(
                  child: RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    itemSize: 40,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, index) =>
                        Icon(
                          Icons.star,
                          color: AppColors.colorAccent,
                        ),
                    onRatingUpdate: (rating) {
                      ratingCount = rating.toInt();
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding:
                  const EdgeInsets.only(left: 10, right: 7, top: 0, bottom: 0),
                  decoration: _inputDecoration,
                  child: TextField(
                    controller: _feedbackController,
                    decoration: InputDecoration(border: InputBorder.none),
                    style: _contentTextStyle,
                    maxLines: 4,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  alignment: Alignment.center,
                  child: LongButton(
                    height: 40,
                    text: AppTranslations.of(context).text('send_rate'),
                    onPressed: () {
                      onSendRateClicked(ratingCount, _feedbackController.text);
                      Navigator.of(context).pop();
                    },
                    borderRadius: 7,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  final _inputDecoration = BoxDecoration(
    border: Border.all(
      color: AppColors.colorGreyStroke,
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(10)),
    color: AppColors.colorWhite,
  );
}

const _labelTextStyle = TextStyle(
    fontSize: FontConfig.font_normal,
    fontWeight: FontWeight.bold,
    color: AppColors.colorAccent);

const _contentTextStyle = TextStyle(
    fontSize: FontConfig.font_medium,
    fontWeight: FontWeight.bold,
    color: AppColors.colorGrey);
