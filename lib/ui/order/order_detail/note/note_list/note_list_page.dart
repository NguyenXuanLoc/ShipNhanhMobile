// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/data/model/note_item_model.dart';
import 'package:smartship_partner/data/model/order_info.dart';
import 'package:smartship_partner/data/model/order_status.dart';
import 'package:smartship_partner/data/model/order_type.dart';
import 'package:smartship_partner/data/model/user_info.dart';
import 'package:smartship_partner/ui/order/order_detail/note/create_note/create_note_page.dart';
import 'package:smartship_partner/ui/order/order_detail/note/note_list/note_list_bloc.dart';
import 'package:smartship_partner/ui/order/order_detail/note/note_list/note_list_event.dart';
import 'package:smartship_partner/ui/order/order_detail/note/note_list/note_list_state.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/app_bar_icon.dart';
import 'package:smartship_partner/widget/note_list_item.dart';
import 'package:smartship_partner/widget/popup_menu.dart';
import 'package:smartship_partner/widget/progress_hud.dart';

class NoteListPage extends StatefulWidget {
  OrderInfoModel order;

  NoteListPage({@required this.order});

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  final _noteListBloc = NoteListBloc();
  GlobalKey filterPopupKey = GlobalKey();
  PopupMenu filterPopup;

  GlobalKey createOrderPopupKey = GlobalKey();
  PopupMenu createOrderPopup;
  OrderInfoModel order;

  @override
  void initState() {
    super.initState();
    order = widget.order;
  }

  @override
  void dispose() {
    super.dispose();
    _noteListBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    _noteListBloc..add(NoteListFetch(orderId: order.orderId));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: AppBarIcon(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Ghi chú đơn hàng',
          style: TextStyle(color: AppColors.colorAccent),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CreateNoteDialog(
                        onSendNoteClicked: (note) {
                          _noteListBloc
                            ..add(CreateNote(
                                orderId: order.orderId,
                                note: note));
                        });
                  });
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Icon(Icons.add_circle_outline, color: AppColors.colorAccent,),
            ),
          )
        ],
      ),
      body: BlocListener<NoteListBloc, NoteListState>(
          bloc: _noteListBloc,
          listener: (context, state) {},
          child: BlocBuilder<NoteListBloc, NoteListState>(
            bloc: _noteListBloc,
            builder: (context, state) {
              switch (state.runtimeType) {
                case NoteListUninitialized:
                  return ProgressHUD();
                case NoteListError:
                  return Container(
                    decoration: BoxDecoration(color: AppColors.colorGreyLight),
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(
                        AppTranslations.of(context)
                            .text('failed_to_fetch_order_list'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.colorAccent),
                      ),
                    ),
                  );
                case NoteListLoaded:
                  var stateLoaded = state as NoteListLoaded;
                  var generalOrderInfo = _getGeneralOrderInfo(stateLoaded.userInfo);
                  if (stateLoaded.noteList.isEmpty) {
                    return generalOrderInfo;
                  }
                  final noteList = stateLoaded.noteList;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      generalOrderInfo,
                      _getNoteListWidget(noteList, context)
                    ],
                  );
                default:
                  return ProgressHUD();
              }
            },
          )),
    );
  }

  Widget _getGeneralOrderInfo(UserInfoModel userInfoModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Divider(
          height: 1,
          color: AppColors.colorGreyStroke,
        ),
        _getOrderInfo(),
        Divider(
          height: 1,
          color: AppColors.colorNoteItemDivider,
        ),
        VerticalDivider(
          width: 1,
          color: AppColors.colorWhiteLight,
        ),
      ],
    );
  }

  Widget _getOrderInfo() {

    return Container(
      color: AppColors.colorWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            color: AppColors.colorBlueLight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '#${order.orderId}',
                  style: TextStyle(
                    color: AppColors.colorBlueDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '${order.orderStatus.name(context).toUpperCase()}',
                  style: TextStyle(
                    color: AppColors.colorBlueDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '${order.orderType.name(context).toString()}',
                  style: TextStyle(
                    color: AppColors.colorBlueDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/phone/ic_marker_from.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.scaleDown,
                        ),
                        Container(
                          width: 1,
                          color: AppColors.colorNoteItemDivider,
                          height: 45,
                        ),
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: AppColors.colorAccent,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Column(
                        children: <Widget>[
                          _getOrderInfoElement(
                            '${order.supplier.location.address}',
                            '',
                            delimiter: ''
                          ),
                          _getOrderInfoElement(
                            'Phí',
                            '${Utils.formatCurrency(context).format(order.deliverFee)}',
                          ),
                          _getOrderInfoElement(
                            'Tiền hàng',
                            '${Utils.formatCurrency(context).format(order.orderPrice)}',
                          ),
                          _getOrderInfoElement(
                            '${order.receiver.location.address}',
                            '',
                            delimiter: ''
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Ghi chú',
                      style: TextStyle(
                        color: AppColors.colorBlack,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      ': ',
                      style: TextStyle(
                        color: AppColors.colorBlackFade,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${order.description}',
                        style: TextStyle(
                          color: AppColors.colorBlackFade,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                  height: 8,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getOrderInfoElement(String label, String content, {String delimiter = ':'}) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorBlackFade),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  delimiter,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.colorBlackFade),
                ),
              ),
              Expanded(
                child: Text(
                  content,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: AppColors.colorBlackFade),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              )
            ],
          ),
        ),
    );
  }

  Widget _getNoteListWidget(
      List<NoteItemModel> noteList, BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: noteList.length,
        itemBuilder: (context, index) {
          return NoteListItem(
              noteItem: noteList[index], onNoteItemClicked: (noteItem) {});
        },
      ),
    );
  }
}
