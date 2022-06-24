// @dart = 2.9
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/config/font_config.dart';
import 'package:smartship_partner/config/localizations/app_translations.dart';
import 'package:smartship_partner/config/style/style.dart';
import 'package:smartship_partner/data/network/response/statistic/statistic_response.dart';
import 'package:smartship_partner/ui/statistic/statistic.dart';
import 'package:smartship_partner/ui/statistic/statistic_bloc.dart';
import 'package:smartship_partner/util/date_time_utils.dart';
import 'package:smartship_partner/util/utils.dart';
import 'package:smartship_partner/widget/app_bar_widget.dart';
import '../../base/base_state.dart';

class StatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends BaseState<StatisticPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  final _bloc = StatisticBloc(StatisticStartState());
  ScrollController controller; // load more

  final List<UserHistory> _historyList = [];
  static const PAGE_SIZE = 100;
  StatisticResponse _statisticData;
  DateTime _fromDate;
  DateTime _toDate;
  int _pageIndex = 1;

  @override
  void initState() {
    super.initState();
    /* by default we will load the 7 last days */
    _toDate = DateTime.now();
    _fromDate = _toDate.subtract(Duration(days: 7));
    controller = ScrollController();
    controller.addListener(_scrollListener);
    /* handle Result */
    _setupHandleData();
  }

  void _setupHandleData() {
    /* handle Result */
    Utils.eventBus.on<StatisticResultEvent>().listen((event) {
      _refreshController.refreshCompleted();
      if (event.isSuccess) {
        var statisticList = event.data.userHistory;
        _pageIndex = event.pageIndex;
        setState(() {
          _statisticData = event.data;
          if (event.isNewData) {
            // refresh -> assign to new data
            _historyList.clear();
            _historyList.addAll(statisticList);
          } else {
            _historyList.addAll(statisticList);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.colorWhite,
      appBar: AppBarWidget(
        title: AppTranslations.of(context).text('statistic'),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        return Column(
          children: <Widget>[
            _timeLayout(),
            _totalMoneyLayout(),
            _orderDetailList()
          ],
        );
      },
    );
  }

  Widget _timeLayout() {
    var dateFormat = DateFormat('dd/MM/yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _divider(),
        Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: AppTranslations.of(context).text('from') + ': ',
                  style: _labelTextStyle),
              TextSpan(
                  text: DateTimeUtil.dateToString(_fromDate, dateFormat),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      _selectDate(true);
                    },
                  style: _contentTextStyle)
            ]),
          ),
        ),
        AppStyle.heightSizedBox(height: 5),
        _divider(),
        AppStyle.heightSizedBox(height: 5),
        Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: AppTranslations.of(context).text('to') + ': ',
                  style: _labelTextStyle),
              TextSpan(
                  text: DateTimeUtil.dateToString(_toDate, dateFormat),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      _selectDate(false);
                    },
                  style: _contentTextStyle)
            ]),
          ),
        ),
        _divider(),
      ],
    );
  }

  Widget _totalMoneyLayout() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppTranslations.of(context).text('total_goods_money'),
                      style: _labelTextStyle,
                    )),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      AppTranslations.of(context).text('order_num'),
                      style: _labelTextStyle,
                    )),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      AppTranslations.of(context).text('total_ship_fee'),
                      style: _labelTextStyle,
                    )),
              )
            ],
          ),
          AppStyle.heightSizedBox(height: 10),
          Row(
            children: <Widget>[
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _statisticData != null
                          ? '${Utils.formatCurrency(context).format(_statisticData.totalAmount.round())}'
                          : '0đ',
                      style: _contentTextStyle,
                    )),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      _statisticData != null
                          ? '${_statisticData.totalRecords.toInt()}'
                          : '0',
                      style: _contentTextStyle,
                    )),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _statisticData != null
                          ? '${Utils.formatCurrency(context).format(_statisticData.totalShipFee.round())}'
                          : '0đ',
                      style: _contentTextStyle,
                    )),
              )
            ],
          ),
          AppStyle.heightSizedBox(height: 5),
          _divider(),
        ],
      ),
    );
  }

  Widget _orderDetailList() {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppTranslations.of(context).text('goods_money'),
                        style: _labelTextStyle,
                      )),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        AppTranslations.of(context).text('order_id'),
                        style: _labelTextStyle,
                      )),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        AppTranslations.of(context).text('ship_fee'),
                        style: _labelTextStyle,
                      )),
                )
              ],
            ),
            AppStyle.heightSizedBox(height: 5),
            Expanded(
              child: SmartRefresher(
                header: MaterialClassicHeader(),
                onRefresh: _onReload,
                controller: _refreshController,
                child: LazyLoadScrollView(
                  onEndOfPage: () => _onLoadMore,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _historyList.length,
                      itemBuilder: (context, index) {
                        return _buildOrderItem(_historyList[index]);
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 2, color: const Color(0xffE4E4E4));
  }

  Widget _buildOrderItem(UserHistory item) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 7, bottom: 7),
      child: Row(
        children: <Widget>[
          /// Amount
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${Utils.formatCurrency(context).format(item.amount.round())}',
                  style: _contentTextStyle,
                )),
          ),

          /// order Id
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Container(
                alignment: Alignment.center,
                child: Text(
                  '${item.orderId}',
                  style: _contentTextStyle,
                )),
          ),

          /// Ship fee
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  '${Utils.formatCurrency(context).format(item.shipFee.round())}',
                  style: _contentTextStyle,
                )),
          )
        ],
      ),
    );
  }

  void _onLoadMore() async {
    print('on Load more page: $_pageIndex');
    if (_historyList.length % PAGE_SIZE == 0) {
      _bloc.add(LoadStatisticEvent(
          to: _toDate, from: _fromDate, pageIndex: _pageIndex + 1));
    }
  }

  void _onReload([bool force = false]) async {
    print('reload: $force');
    if (_toDate.isBefore(_fromDate)) {
      showSnackBar(context,
          AppTranslations.of(context).text('to_date_smaller_than_from_date'));
      if (_refreshController.isLoading) _refreshController.refreshCompleted();
      return;
    }
    _pageIndex = 1;
    if (force) {
      await _refreshController.requestRefresh();
      return;
    } else {
      _bloc.add(LoadStatisticEvent(
          pageIndex: _pageIndex, from: _fromDate, to: _toDate));
    }
  }

  /// Select date, pass true if choose from date
  void _selectDate(bool selectFrom) async {
    var result = await showDatePicker(
      context: context,
      firstDate: selectFrom ? DateTime(2019) : _fromDate,
      lastDate: DateTime(2100),
      initialDate: selectFrom
          ? _fromDate
          : _toDate.isBefore(_fromDate) ? _fromDate : _toDate,
    );

    if (result != null) {
      setState(() {
        if (selectFrom) {
          _fromDate = result;
        } else {
          _toDate = result;
        }
        _onReload(true);
      });
    }
  }

  void _scrollListener() {
    print('scroll position: ${controller.position}');
    print('scroll Listener ${controller.position.extentAfter}');
    if (controller.position.extentAfter < 500) {
      _onLoadMore();
    }
  }
}

const _labelTextStyle = TextStyle(
    color: AppColors.colorAccent,
    fontSize: FontConfig.font_medium,
    fontWeight: FontWeight.bold);

const _contentTextStyle = TextStyle(
  color: AppColors.colorGrey,
  fontSize: FontConfig.font_medium,
);
