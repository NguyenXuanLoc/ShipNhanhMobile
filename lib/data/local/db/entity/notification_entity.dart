// @dart = 2.9
import 'package:floor/floor.dart';
import 'package:smartship_partner/util/date_time_utils.dart';

Notification notificationFromJson(Map<String, dynamic> json) =>
    Notification.fromJson(json);

@entity
class Notification {
  @PrimaryKey(autoGenerate: true)
  final int id;

  @ColumnInfo(name: 'userId')
  final String userId;
  @ColumnInfo(name: 'message')
  final String message;
  @ColumnInfo(name: 'type')
  final String type;
  @ColumnInfo(name: 'title')
  final String title;
  @ColumnInfo(name: 'orderId')
  final String orderId;
  @ColumnInfo(name: 'time')
  final int time;
  @ColumnInfo(name: 'read')
  int read; //1:read 0:unread

  Notification(this.id, this.userId, this.message, this.type, this.title,
      this.orderId, this.time, this.read);

  factory Notification.fromJson(Map<String, dynamic> json) {
    print('craete notification: $json');
    return Notification(
        null,
        json["UserId"] == null ? null : json["UserId"],
        json["Message"] == null ? null : json["Message"],
        json["Type"] == null ? null : json["Type"],
        json["Title"] == null ? null : json["Title"],
        json["OrderId"] == null ? null : json["OrderId"],
        DateTimeUtil.getCurrentTimeInt(),
        0);
  }

  Map<String, dynamic> toJson() => {
        "UserId": userId == null ? null : userId,
        "Message": message == null ? null : message,
        "Type": type == null ? null : type,
        "Title": title == null ? null : title,
        "OrderId": orderId == null ? null : orderId,
      };
}
