// @dart = 2.9
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/data/repository/db_repository.dart';
import 'package:smartship_partner/ui/notification/notification.dart';
import 'package:smartship_partner/util/utils.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final _dbRepository = DatabaseRepository.get();

  NotificationBloc(NotificationState initialState) : super(initialState);

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    print('map Event to State');
    switch (event.runtimeType) {
      case NotificationStartEvent:
        // Load notification
        await _loadNotification();
        return;
      case NotificatioReadEvent:
        await _setNotificationRead(
            (event as NotificatioReadEvent).notificationId);
        return;
    }
  }

  void _loadNotification() async {
    print('Load notification data');
    var result = await _dbRepository.loadNotification();
    print('result: $result');
    Utils.eventBus.fire(NotificationLoadedEvent(result));
  }

  void _setNotificationRead(int id) async {
    try {
      var result = await _dbRepository.setNotificationRead(id, true);
    } catch (error) {
      print('set read notification failed: $error');
    }
  }
}
