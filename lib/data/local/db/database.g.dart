// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NotificationDao? _notificationDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Notification` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `userId` TEXT NOT NULL, `message` TEXT NOT NULL, `type` TEXT NOT NULL, `title` TEXT NOT NULL, `orderId` TEXT NOT NULL, `time` INTEGER NOT NULL, `read` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NotificationDao get notificationDao {
    return _notificationDaoInstance ??=
        _$NotificationDao(database, changeListener);
  }
}

class _$NotificationDao extends NotificationDao {
  _$NotificationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _notificationInsertionAdapter = InsertionAdapter(
            database,
            'Notification',
            (Notification item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'message': item.message,
                  'type': item.type,
                  'title': item.title,
                  'orderId': item.orderId,
                  'time': item.time,
                  'read': item.read
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Notification> _notificationInsertionAdapter;

  @override
  Future<List<Notification>> loadNotification() async {
    return _queryAdapter.queryList(
        'Select * from notification order by id desc',
        mapper: (Map<String, Object?> row) => Notification(
            row['id'] as int,
            row['userId'] as String,
            row['message'] as String,
            row['type'] as String,
            row['title'] as String,
            row['orderId'] as String,
            row['time'] as int,
            row['read'] as int));
  }

  @override
  Future<void> setNotificationRead(int id, int read) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE notification SET read = ?2 WHERE id = ?1',
        arguments: [id, read]);
  }

  @override
  Future<void> clearNotifications() async {
    await _queryAdapter.queryNoReturn('DELETE FROM notification');
  }

  @override
  Future<void> insertNotification(Notification notification) async {
    await _notificationInsertionAdapter.insert(
        notification, OnConflictStrategy.abort);
  }
}
