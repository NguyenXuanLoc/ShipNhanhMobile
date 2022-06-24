// @dart = 2.9
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/network/response/statistic/statistic_response.dart';
import 'package:smartship_partner/data/repository/order_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/ui/statistic/statistic.dart';
import 'package:smartship_partner/util/date_time_utils.dart';
import 'package:smartship_partner/util/utils.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final _userRepository = UserRepository.get(PrefsManager.get);
  OrderRepository _orderRepository;

  StatisticBloc(StatisticState initialState) : super(initialState) {
    _orderRepository = OrderRepository.get(_userRepository);
  }

  @override
  Stream<StatisticState> mapEventToState(StatisticEvent event) async* {
    switch (event.runtimeType) {
      case LoadStatisticEvent:
        var pageIndex = (event as LoadStatisticEvent).pageIndex;
        var from = (event as LoadStatisticEvent).from;
        var to = (event as LoadStatisticEvent).to;
        await _loadStatistisData(pageIndex, from, to);
        return;
    }
  }

  Future<StatisticResponse> _loadStatistisData(
      int pageIndex, DateTime from, DateTime to) async {
    print('load statistic data: $pageIndex -- from $from to $to');
    try {
      var dateFormat = DateFormat('yyyy-MM-dd');
      var fromStr = DateTimeUtil.dateToString(from, dateFormat);
      var toStr = DateTimeUtil.dateToString(to, dateFormat);

      var result = await _orderRepository.getStatistic(
          pageIndex, fromStr, toStr);
      if (result != null && result.isSuccess) {
        var data = result.dataResponse;
        if (data == null) {
          Utils.eventBus.fire(StatisticResultEvent(isSuccess: false));
        } else {
          Utils.eventBus.fire(StatisticResultEvent(
              isSuccess: true,
              data: data,
              isNewData: pageIndex == 1,
              pageIndex: pageIndex));
        }
      } else {
        Utils.eventBus.fire(StatisticResultEvent(isSuccess: false));
      }
    }catch(error){
      Utils.eventBus.fire(StatisticResultEvent(isSuccess: false));
      print('load Statistic fata failed: $error');
    }
  }
}
