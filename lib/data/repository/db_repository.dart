// @dart = 2.9
import 'package:smartship_partner/constant/constants.dart';
import 'package:smartship_partner/data/local/db/dao/notification_dao.dart';
import 'package:smartship_partner/data/local/db/database.dart';
import 'package:smartship_partner/data/local/db/entity/notification_entity.dart';

import 'base_service_repository.dart';

class DatabaseRepository extends BaseServiceRepository {
  AppDatabase _database;
  NotificationDao _notificationDao;
  static DatabaseRepository _instance;

  void init() async {
    _database = _database ??
        await $FloorAppDatabase
            .databaseBuilder(DatabaseConstant.DB_NAME)
            .build();
    _notificationDao = _notificationDao ?? _database.notificationDao;
  }

  static DatabaseRepository get() {
    _instance ??= DatabaseRepository();
    return _instance;
  }

  Future<List<Notification>> loadNotification() async {
    return _notificationDao.loadNotification();
  }

  Future<void> insertNotification(Notification notification) async {
    return _notificationDao.insertNotification(notification);
  }

  Future<void> setNotificationRead(int notificationId,
      [bool read = true]) async {
    return _notificationDao.setNotificationRead(notificationId, read ? 1 : 0);
  }

  Future<void> clearNotifications() async {
    return _notificationDao.clearNotifications();
  }
}
