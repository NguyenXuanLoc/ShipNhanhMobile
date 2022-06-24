// @dart = 2.9
import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/local/db/entity/notification_entity.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NotificationStartEvent extends NotificationEvent {}

class NotificatioReadEvent extends NotificationEvent {
  int notificationId;

  NotificatioReadEvent(this.notificationId);
  @override
  List<Object> get props => [notificationId];
}

///************EventBus***********/
class NewNotificationEBEvent {
  Notification notification;

  NewNotificationEBEvent([this.notification]);
}

class NotificationTriggeredEBEvent{
  String orderId;

  NotificationTriggeredEBEvent(this.orderId);
}

class NotificationLoadedEvent {
  List<Notification> data;

  NotificationLoadedEvent(this.data);
}
//
//class NotificationBadgeEBEvent {
//  bool showBadge;
//
//  NotificationBadgeEBEvent([this.showBadge = true]);
//}
