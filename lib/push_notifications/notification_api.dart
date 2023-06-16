// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationApi {
//   static final _notifications = FlutterLocalNotificationsPlugin();

//   static Future notificationDetails() async {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails('channelId', 'channelName'),
//       // iOS: DarwinNotificationDetails(),
//     );
//   }

//   static Future showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//   }) async =>
//       _notifications.show(id, title, body, await notificationDetails(),
//           payload: payload);
// }

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:e_shop/global/global.dart';
import 'package:http/http.dart' as http;

class NotificationApi {
  final HttpClient httpClient = HttpClient();
  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final fcmKey = fcmServerToken;

  void sendFcm(String title, String body, String fcmToken) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmKey'
    };
    var request = http.Request('POST', Uri.parse(fcmUrl));
    request.body =
        '''{"to":"$fcmToken","priority":"high","notification":{"title":"$title","body":"$body","sound": "default"}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
