import 'package:floor/floor.dart';
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/local/db/entity/notification_entity.dart';

@dao
abstract class NotificationDao {
  @Query('Select * from ${DatabaseConstant.TABLE_NOTIFICATION} order by id desc')
  Future<List<Notification>> loadNotification();

  @insert
  Future<void> insertNotification(Notification notification);

  @Query('UPDATE ${DatabaseConstant.TABLE_NOTIFICATION} SET read = :read WHERE id = :id')
  Future<void> setNotificationRead(int id, int read);

  @Query('DELETE FROM ${DatabaseConstant.TABLE_NOTIFICATION}')
  Future<void> clearNotifications();
}
