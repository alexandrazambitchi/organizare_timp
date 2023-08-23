import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotification = BehaviorSubject<String?>();

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload
  }) async => notificationsPlugin.show(id, title, body, await notificationDetails(), payload: payload);

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');
    DarwinInitializationSettings initializationSettingsiOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsiOS);

    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
              onNotification.add(notificationResponse.payload);
            });

    final details = await notificationsPlugin.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp) {
      onNotification.add(details.notificationResponse!.payload);
    }
    
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future<void> scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduleNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduleNotificationDateTime, tz.local),
      await notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleRecurrentNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduleNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduleNotificationDateTime, tz.local),
      
      await notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // static tz.TZDateTime scheduleRecurrency(Time time, )

}