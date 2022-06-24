import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
import 'package:floor/floor.dart';
import 'package:smartship_partner/data/local/db/dao/notification_dao.dart';
import 'package:smartship_partner/data/local/db/entity/notification_entity.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Notification])
abstract class AppDatabase extends FloorDatabase {
  NotificationDao get notificationDao;
}
