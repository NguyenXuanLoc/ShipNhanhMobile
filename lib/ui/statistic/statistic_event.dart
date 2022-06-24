// @dart = 2.9
import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/network/response/statistic/statistic_response.dart';
import 'package:smartship_partner/util/date_time_utils.dart';
import 'package:smartship_partner/util/utils.dart';

abstract class StatisticEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadStatisticEvent extends StatisticEvent {
  int pageIndex;
  DateTime from;
  DateTime to;

  LoadStatisticEvent({this.pageIndex, this.from, this.to});

  @override
  List<Object> get props => [
        pageIndex,
        DateTimeUtil.dateToString(from),
        DateTimeUtil.dateToString(to)
      ];
}

/// ************************Event Bus **************/
class StatisticResultEvent {
  bool isSuccess;
  StatisticResponse data;
  bool isNewData;
  int pageIndex;

  StatisticResultEvent(
      {this.isSuccess = false,
      this.data,
      this.isNewData = true,
      this.pageIndex = 0});
}
