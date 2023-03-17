import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:solesteals/config/router/app_router.dart';

class LocalNotifications {
  static Future<void> requestPermissionLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

// cuando hace click en el local notification
  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    // appRouter.push('/push-details/${response.payload}');
    //  final path = response.data['path'];

    // appRouter.pushReplacementNamed('homeWithPath',
    //     params: {'path': response.payload ?? '/'});
    appRouter.goNamed('homeWithPath',
        params: {'path': response.payload ?? '/'});
    
    // print(response);
  }

  static Future<void> initializeLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initSettingsAndroid = AndroidInitializationSettings('app_icon');

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: data,
    );
  }
}
