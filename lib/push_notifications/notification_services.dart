import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService();

  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Future<void> setup() async {
  //   const androidInitializationSetting =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const iosInitializationSetting = DarwinInitializationSettings();
  //   const initSettings = InitializationSettings(
  //       android: androidInitializationSetting, iOS: iosInitializationSetting);
  //   await _flutterLocalNotificationsPlugin.initialize(initSettings);
  // }

  Future<void> setup() async {
    const androidInitializationSetting =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitializationSetting = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
        android: androidInitializationSetting, iOS: iosInitializationSetting);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void showLocalNotification(String title, String body) {
    const androidNotificationDetail = AndroidNotificationDetails(
        '2', // channel Id
        'general' // channel Name
        );
    const iosNotificatonDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificatonDetail,
      android: androidNotificationDetail,
    );
    _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }
}
