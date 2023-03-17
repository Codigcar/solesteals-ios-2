part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationsStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;
  NotificationsStatusChanged(this.status);
}

//TODO: NotificationReceived #PushMessage
class NotificationReceived extends NotificationsEvent {
  final PushMessage pushMessage;
  NotificationReceived(this.pushMessage);
}
