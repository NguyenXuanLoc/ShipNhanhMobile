// @dart = 2.9
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smartship_partner/base/base_state.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/data/model/create_order_contact.dart';
import 'package:smartship_partner/data/model/order/new_order.dart';
import 'package:smartship_partner/data/model/order_type.dart';
import 'package:smartship_partner/eventbus/create_order_event.dart';
import 'package:smartship_partner/ui/create_order/create_order_images/create_order_images.dart';
import 'package:smartship_partner/ui/location_select/location_select_page.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/alert_dialog_two_button.dart';
import 'package:smartship_partner/widget/app_bar_widget.dart';
import 'package:smartship_partner/widget/confirm_order_dialog.dart';
import 'package:smartship_partner/widget/image_picker_bottom_sheet.dart';
import 'package:smartship_partner/widget/long_button.dart';

class CreateOrderImagesPage extends StatefulWidget {
  @override
  _CreateOrderImagesPageState createState() => _CreateOrderImagesPageState();
}

class _CreateOrderImagesPageState
    extends BaseOrderState<CreateOrderImagesPage> {
  static const MAX_IMAGES = 5;
  bool _createdOrder = false;
  final List<File> _imageList = [];
  StreamSubscription<CreateOrderAutoFillEvent> _autoFillDataStream;

// Thông tin lấy hàng
  CreateOrderContact _contactInfo;

  final _bloc = CreateOrderImagesBloc(CreateOrderImagesStartState());

  // UI
  BuildContext currentContext;
  var _loading = false;
  final TextEditingController _addressController = TextEditingController();
  final _imagePicker = ImagePicker();

  // For update progress
  AlertDialog _dialogProgress;
  BuildContext _dialogContext;
  StateSetter _setState;
  int _currentProgress = 0;
  int _totalOrderCount = 0;

  @override
  void initState() {
    super.initState();
    _handleDefaultAddress();
    _setupHandleLoading();
    _bloc.add(CreateOrderImagesStartEvent());
  }

  void _handleDefaultAddress() {
    Utils.eventBus.on<CreateOrderAutoFillEvent>().listen((event) async {
      setState(() {
        _contactInfo = event.data;
        _addressController.text = _contactInfo.address;
      });
    });
  }

  void _setupHandleLoading() {
    /* Handle loading */
//     Utils.eventBus.on<CreateOrderResultEvent>().listen((event) async {
//       setState(() {
//         _loading = false;
//       });
//       if (event.success) {
// //        showSnackBar(
// //            context, AppTranslations.of(context).text('create_order_success'));
//         /// Tạo đơn thành công, show dialog
//         _showCreateSuccessDialog();
//       } else {
//         if (event.message.isNotEmpty) {
//           showSnackBar(context, event.message);
//         } else {
//           showSnackBar(
//               context, AppTranslations.of(context).text('create_order_failed'));
//         }
//       }
//     });

    Utils.eventBus.on<ProgressCreateOrderImagesEBEvent>().listen((event) async {
      var success = event.success;
      var msg = event.message;
      debugPrint('Update: ${event.index}');
      _currentProgress = event.index + 1;
      _totalOrderCount = event.total;
      if (!success) {
        if (msg.isNotEmpty) {
          showSnackBar(context, msg);
        } else {
          showSnackBar(
              context, AppTranslations.of(context).text('create_order_failed'));
        }
      } else {
        _createdOrder = true;
      }
      if (event.index == event.total) {
        // If current dialog context is not null (dialog is showing) => dismiss dialog
        await _dismissProgressDialog();
        _showCreateSuccessDialog();
      } else {
        // update dialog progress if is showing
        if (_dialogContext != null && _setState != null) {
          _setState(() {});
        }
      }
    });
  }

  Future _dismissProgressDialog() async {
    if (_dialogContext != null && Navigator.of(_dialogContext).canPop()) {
      await Navigator.of(_dialogContext).pop();
      _setState = null;
      _dialogContext = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.close();
    _autoFillDataStream?.cancel();
  }

  @override
  Widget getLayout(BuildContext context) {
    _initProgressDialog(context);
    currentContext = context;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarWidget(
        onActionTap: _onBackPressed,
        title: AppTranslations.of(context).text('create_order_with_images'),
        showIcon: true,
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          return ModalProgressHUD(
            child: _buildContent(),
            inAsyncCall: _loading,
          );
        },
      ),
    );
  }

  void _initProgressDialog(BuildContext context) {
    _dialogProgress = AlertDialog(
      content: StatefulBuilder(
        builder: (context, setState) {
          _dialogContext = context;
          _setState = setState;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppTranslations.of(context).text('creating_order'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(FontConfig.font_large),
                    color: AppColors.colorAccent),
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                color: AppColors.colorAccent,
                height: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.colorAccent),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${AppTranslations.of(context).text('create_order_progress')} $_currentProgress / $_totalOrderCount',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(FontConfig.font_normal),
                        color: AppColors.colorTextNormal),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }

  /// return true to apply backpressed from system
  bool _onBackPressed([bool force = true]) {
    if (force) {
      Navigator.of(context).pop(_createdOrder);
    }
    return true;
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.only(bottom: 5, right: 10, left: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddress(),
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 1,
            color: AppColors.colorGreyStroke,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            AppTranslations.of(context).text('order_list_need_created'),
            style: TextStyle(
                fontSize: ScreenUtil().setSp(FontConfig.font_medium),
                fontWeight: FontWeight.bold,
                color: AppColors.colorAccent),
          ),
          SizedBox(
            height: 5,
          ),

          /// Note
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: '${AppTranslations.of(context).text('attention')}: ',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(FontConfig.font_small),
                      fontWeight: FontWeight.bold,
                      fontFamily: FontConfig.fontPrimary,
                      color: AppColors.colorAccent)),
              TextSpan(
                  text:
                      '${AppTranslations.of(context).text('create_order_images_note')}',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(FontConfig.font_small),
                      fontFamily: FontConfig.fontPrimary,
                      color: AppColors.colorAccent))
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 1 / 1),
                itemCount: _imageList.length == MAX_IMAGES
                    ? _imageList.length
                    : _imageList.length + 1,
                itemBuilder: (context, index) {
                  if (index == _imageList.length &&
                      _imageList.length < MAX_IMAGES) {
                    return _buildAddImageButton();
                  } else {
                    return _buildImageItem(index);
                  }
                }),
          ),
          SizedBox(
            height: 5,
          ),

          /// Create order button
          LongButton(
            height: null,
            text: AppTranslations.of(context).text('confirm_and_create_order'),
            onPressed: _requestCreateOrder,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            fontSize: ScreenUtil().setSp(FontConfig.font_medium),
          )
        ],
      ),
    );
  }

  Widget _buildImageItem(int index) {
    var item = _imageList[index];
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(5),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(image: FileImage(item), fit: BoxFit.cover),
              color: AppColors.colorWhite,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          Positioned(
              top: ScreenUtil().setWidth(2),
              right: ScreenUtil().setWidth(2),
              child: GestureDetector(
                onTap: (){
                  _removeImageItem(index);
                },
                child: Container(
                  width: ScreenUtil().setWidth(22),
                  height: ScreenUtil().setWidth(22),
                  decoration: BoxDecoration(
                    color: AppColors.colorAccent,
                    shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Icon(Icons.clear, color: AppColors.colorWhite, size: ScreenUtil().setWidth(15),),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _getImage,
      child: Container(
        margin: EdgeInsets.all(5),
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.colorWhite,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: AppColors.colorGreyStroke, width: 1)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: AppColors.colorGreyStroke,
              size: ScreenUtil().setWidth(31),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              AppTranslations.of(context).text('add_image'),
              style: TextStyle(
                  color: AppColors.colorGreyStroke,
                  fontSize: ScreenUtil().setSp(FontConfig.font_x_small)),
            )
          ],
        ),
      ),
    );
  }

  void _showAddressConfirmDialog() async {
    var result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ConfirmOrderDialog(_contactInfo, LocationSelectPage.TYPE_FROM,
              true, OrderType.NORMAL.value);
        });
    if (result != null) {
      _contactInfo = result;
      setState(() {
        _addressController.text = _contactInfo.address;
      });
    }
  }

  Widget _buildAddress() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTranslations.of(context).text('your_address'),
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(FontConfig.font_medium),
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorAccent),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                enabled: false,
                controller: _addressController,
                style: TextStyle(
                  color: AppColors.colorTextNormal,
                  fontSize: ScreenUtil().setSp(FontConfig.font_medium),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      AppTranslations.of(context).text('not_enter_address'),
                  hintStyle: TextStyle(
                    color: AppColors.colorGreyStroke,
                    fontSize: ScreenUtil().setSp(FontConfig.font_medium),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.colorGreyStroke,
          ),
          iconSize: ScreenUtil().setWidth(15),
          onPressed: _showAddressConfirmDialog,
        )
      ],
    );
  }

  _requestCreateOrder() async {
    /// Check the address
    /// bắt buộc có thông tin lấy hàng
    if (_contactInfo == null ||
        _contactInfo.userName == null ||
        _contactInfo.phone == null ||
        _contactInfo.userName.isEmpty ||
        _contactInfo.phone.isEmpty) {
      showSnackBar(
          context, AppTranslations.of(context).text('missing_from_user_info'));
      return;
    }

    if (_imageList.isEmpty) {
      showSnackBar(context,
          AppTranslations.of(context).text('create_order_images_not_added'));
      return;
    }

    /// Create order
    var order = NewOrder();
    order.notes = '';
    order.fromAddress = _contactInfo.address;
    order.toAddress = '';
    order.receiverPhone = '';
    order.receiverName = '';
    order.category = OrderType.NORMAL.value;
    order.onbehalfName = _contactInfo.userName;
    order.onbehalfPhoneNumber = _contactInfo.phone;
    order.isOnbehalf = false;
    order.fromLat = _contactInfo.lat ?? 0;
    order.fromLng = _contactInfo.long ?? 0;
    order.toLat = 0;
    order.toLng = 0;
    order.amount = 0;
    order.shipFee = 0;

    _currentProgress = 1;
    _totalOrderCount = _imageList.length;
    showDialog(
        context: context,
        builder: (context) {
          return _dialogProgress;
        });

    Future.delayed(Duration(seconds: 1), () {
      // wait about 1s for the dialog show first
      _bloc.add(RequestCreateOrderImagesEvent(order, _imageList));
    });
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

        /// Each image only can be add once
        if (_imageList.any((element) {
          debugPrint('compare: ${element.path} -- ${file.path}');
          return element.path == file.path;
        })) {
          showSnackBar(
              context, AppTranslations.of(context).text('image_already_added'));
        } else {
          _imageList.add(File(file.path));
          setState(() {});
        }
      }
    }
//    var file = await FilePicker.getFile(type: FileType.image);
//    if (file != null) {
//      print('hoan.dv: file: ' + file.path);
//      setState(() {
//        _imageFile = file;
//      });
//    }
  }

  void _showCreateSuccessDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialogTwoButton(
            title: AppTranslations.of(context).text('create_order_success'),
            message: AppTranslations.of(context).text('back_to_previous_page'),
            onYesClicked: () {
              _onBackPressed(true);
            },
          );
        });
  }

  /// Remove the image from image list by the index after user click on delete icon
  void _removeImageItem(int index) {
    setState(() {
      _imageList.removeAt(index);
    });
  }
}
