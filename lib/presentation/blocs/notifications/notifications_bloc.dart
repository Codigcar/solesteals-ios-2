import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solesteals/config/local_notifications/local_notifications.dart';

import 'package:solesteals/domain/entities/push_message.dart';
import 'package:solesteals/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  int pushNumberId = 0;

  final Future<void> Function() requestLocalNotificationPermission;
  final void Function({
    required int id,
    String? title,
    String? body,
    String? data,
  })? showLocalNotification;

  NotificationsBloc({
    this.showLocalNotification,
    required this.requestLocalNotificationPermission,
  }) : super(const NotificationsState()) {
    on<NotificationsStatusChanged>(_notificationStatusChanged);
    on<NotificationReceived>(_onPushMessageReceived);

    // Verificar estado de las notificaciones
    _initialStatusCheck();

    // Listener para notificaciones foreground
    _onForegroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // eventos
  void _notificationStatusChanged(
      NotificationsStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  void _onPushMessageReceived(
      NotificationReceived event, Emitter<NotificationsState> emit) {
    emit(state
        .copyWith(notifications: [event.pushMessage, ...state.notifications]));
    _getFCMToken();
  }

  void _initialStatusCheck() async {
    // saber el estado actual
    final settings = await messaging.getNotificationSettings();
    add(NotificationsStatusChanged(settings.authorizationStatus));
    // _getFCMToken();
  }

  void _getFCMToken() async {
    // final settings = await messaging.getNotificationSettings();
    // if(settings.authorizationStatus != AuthorizationStatus.authorized) return;
    if (state.status != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    print(token);
  }

  // remote notification
  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;
    final messageId = message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '';
    final notification = PushMessage(
      messageId:messageId,
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      path: message.data['path'] ?? '/',
      imageUrl: Platform.isAndroid
          ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl,
    );

    if (showLocalNotification != null) {
      showLocalNotification!(
        id: ++pushNumberId,
        title: notification.title,
        body: notification.body,
        data:  notification.path,
      );
    }

    add(NotificationReceived(notification));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }
  //

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    // Solicitar permisos local notifications
    // await LocalNotifications.requestPermissionLocalNotifications();
    await requestLocalNotificationPermission();

    // añadir nuevo evento
    add(NotificationsStatusChanged(settings.authorizationStatus));
    // _getFCMToken();
  }

  PushMessage? getMessageById(String pushMessageId) {
    final exist = state.notifications
        .any((element) => element.messageId == pushMessageId);
    if (!exist) return null;

    return state.notifications
        .firstWhere((element) => element.messageId == pushMessageId);
  }
}
