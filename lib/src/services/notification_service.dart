import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seda_driver/main.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';

class NotificationService {
  NotificationService();

  final notificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await notificationService.initialize(settings,
        onDidReceiveNotificationResponse: (NotificationResponse nr) {
          if(nr.id==2){navigatorKey.currentState?.pushNamed(AppRouterNames.chat);
      }
    });
  }

  Future<NotificationDetails> notificationDetails() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channelId",
      "channelName",
      sound: RawResourceAndroidNotificationSound('mixkit'),
      channelDescription: "description",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    return NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  Future<NotificationDetails> notificationDetailsForOrder() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "orderChannelId",
      "orderChannelName",
      channelDescription: "description",
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    return NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await notificationDetails();
    await notificationService.show(id, title, body, details);
  }

  Future<void> showOrderNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await notificationDetailsForOrder();
    await notificationService.show(id, title, body, details);
  }

  Future<void> cancelNotification() async {
    await notificationService.cancelAll();
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    logWarning("id $id");
  }
}
