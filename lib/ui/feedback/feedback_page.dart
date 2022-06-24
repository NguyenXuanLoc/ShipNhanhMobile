// @dart = 2.9
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smartship_partner/base/base_state.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/data/network/request/feedback/feedback_request.dart';
import 'package:smartship_partner/ui/feedback/feedback.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/app_bar_widget.dart';
import 'package:smartship_partner/widget/image_picker_bottom_sheet.dart';
import 'package:smartship_partner/widget/long_button.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends BaseOrderState<FeedbackPage> {
  final FeedbackBloc _bloc = FeedbackBloc(FeedbackStartState());
  File _imageFile;
  bool _loading = false;
  final _imagePicker = ImagePicker();

  /* Style */
  final _labelController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Utils.eventBus.on<EBFeedbackSent>().listen((event) {
      setState(() {
        _loading = false;
      });
      if (!event.isSuccess) {
        showSnackBar(
            context, AppTranslations.of(context).text('error_try_again'));
      } else {
        /// gửi phản hồi thành công, hiện thông báo, rồi pop về trang trước sau 1s
        showSnackBar(
            context, AppTranslations.of(context).text('send_feedback_done'));
        Timer(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      }
    });
  }

  @override
  Widget getLayout(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 667, allowFontScaling: true);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarWidget(
        showIcon: true,
        onActionTap: _onBackPressed,
        centerTitle: true,
        title: AppTranslations.of(context).text('feedback'),
      ),
      body: _buildContent(),
    );
  }

  void _onBackPressed() {
    Navigator.pop(context);
  }

  _buildContent() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: _loading,
          child: Column(
            children: <Widget>[
              Expanded(child: _topLayout()),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                child: LongButton(
                  text: AppTranslations.of(context).text('send_feedback'),
                  height: null,
                  borderRadius: 10,
                  fontSize: ScreenUtil().setSp(FontConfig.font_x_medium),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                  onPressed: _sendFeedback,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  SingleChildScrollView _topLayout() {
    final fullSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Tiêu đề
            TextField(
              controller: _labelController,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: AppTranslations.of(context).text('feedback_title'),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: AppColors.colorPrimary, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 1,
              color: AppColors.colorGreyStroke,
            ),
            SizedBox(
              height: 10,
            ),

            /// Nội dung
            TextField(
              controller: _contentController,
              minLines: 5,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: AppTranslations.of(context).text('feedback_content'),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: AppColors.colorPrimary, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 1,
              color: AppColors.colorGreyStroke,
            ),
            SizedBox(
              height: 10,
            ),

            /// Thêm ảnh
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppTranslations.of(context).text('add_image') + ': ',
                  style: TextStyle(
                    color: AppColors.colorBlack,
                  ),
                ),
//                InkWell(
//                  onTap: () {},
//                  child: Icon(
//                    Icons.add_circle_outline,
//                    color: AppColors.colorPrimary,
//                    size: ScreenUtil().setWidth(15),
//                  ),
//                )
              ],
            ),
            Container(
              width: ScreenUtil().setWidth(100),
              height: ScreenUtil().setHeight(100),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: fullSize.width,
                    height: fullSize.height,
                    margin: EdgeInsets.all(ScreenUtil().setHeight(7)),
                    decoration: BoxDecoration(
                        color: AppColors.colorGreyLight,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  Container(
                    width: fullSize.width,
                    height: fullSize.height,
                    margin: EdgeInsets.all(ScreenUtil().setHeight(12)),
                    child: _imageFile != null
                        ? Image.file(
                            _imageFile,
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                          )
                        : SvgPicture.asset(
                            'assets/images/phone/im_image.svg',
                            color: AppColors.colorGreyStroke,
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                          ),
                  ),
                  Positioned(
                    right: 1,
                    top: 1,
                    child: GestureDetector(
                      onTap: () {
                        _getImage();
                      },
                      child: Container(
                        width: ScreenUtil().setHeight(17),
                        height: ScreenUtil().setHeight(17),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.colorAccent),
                        child: Icon(
                          Icons.edit,
                          color: AppColors.colorWhite,
                          size: ScreenUtil().setHeight(13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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
          _imageFile = File(file.path);
        });
      }
    }
  }

  void _sendFeedback() async {
    if (_labelController.text.isEmpty) {
      showSnackBar(
          context, AppTranslations.of(context).text('feedback_label_empty'));
      return;
    }
    if (_contentController.text.isEmpty) {
      showSnackBar(
          context, AppTranslations.of(context).text('feedback_content_empty'));
      return;
    }

    setState(() {
      _loading = true;
    });
    var request = FeedbackRequest(
        hasImage: _imageFile != null,
        name: _labelController.text,
        feedback: _contentController.text);

    _bloc.add(SendFeedbackEvent(
        request, _imageFile != null ? _imageFile.path : null));
  }

}
