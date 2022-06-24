// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';

class CreateNoteDialog extends StatelessWidget {
  Function(String) onSendNoteClicked;
  final TextEditingController noteController = TextEditingController();
  var ratingCount = 1;

  CreateNoteDialog({@required this.onSendNoteClicked});

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
              color: AppColors.colorWhite,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                AppTranslations.of(context).text(
                  'create_note_title',
                ),
                textAlign: TextAlign.center,
                style: _labelTextStyle.copyWith(fontSize: FontConfig.font_huge),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.colorWhite,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      left: 10, right: 7, top: 0, bottom: 0),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: _inputDecoration,
                  child: TextField(
                    controller: noteController,
                    decoration: InputDecoration(border: InputBorder.none),
                    style: _contentTextStyle,
                    maxLines: 4,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                  color: AppColors.colorGrey,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.colorWhite,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10)),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Đóng',
                                  textAlign: TextAlign.center,
                                  style: _buttonStyle,
                                ),
                              )),
                        ),
                      ),
                      Container(
                        height: 40,
                        child: VerticalDivider(
                          width: 1,
                          color: AppColors.colorBlueDark,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            onSendNoteClicked(noteController.text);
                            Navigator.pop(context);
                          },
                          child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.colorWhite,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10)),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Gửi',
                                  textAlign: TextAlign.center,
                                  style: _buttonStyle,
                                ),
                              )),
                        ),
                      )
                    ],
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

const _buttonStyle = TextStyle(
  fontSize: FontConfig.font_large,
  fontWeight: FontWeight.bold,
  color: AppColors.colorAccent,
);

const _contentTextStyle = TextStyle(
    fontSize: FontConfig.font_medium,
    fontWeight: FontWeight.bold,
    color: AppColors.colorGrey);
