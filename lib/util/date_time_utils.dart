// @dart = 2.9
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateTimeUtil {
  static var  FULL_DATE_FORMAT = DateFormat('yyyy-MM-dd hh:mm');
  /// convert UTC time to normal time
  static String utcToString(String utcTime, [DateFormat dateFormat]) {
    dateFormat ??= DateFormat.yMd();
    if (utcTime != null && utcTime.isNotEmpty) {
      DateTime time = DateTime.parse(utcTime);
      if (time != null) {
        return dateFormat.format(time);
      }
    }
    return '';
  }

  /// Convert DateTIme to String with specified format
  static String dateToString(DateTime time, [DateFormat dateFormat]) {
    dateFormat ??= DateFormat.yMd();
    return dateFormat.format(time);
  }


  /// Convert DateTIme to String with specified format
  static String dateMillisToString(int timeMillis, [DateFormat dateFormat]) {
    var time = DateTime.fromMillisecondsSinceEpoch(timeMillis);
    dateFormat ??= DateFormat.yMd();
    return dateFormat.format(time);
  }


  static int getCurrentTimeInt() {
    return DateTime
        .now()
        .millisecondsSinceEpoch;
  }
}
