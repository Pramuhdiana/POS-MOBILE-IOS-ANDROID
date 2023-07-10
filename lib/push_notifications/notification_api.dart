import 'dart:convert';

import 'package:e_shop/global/global.dart';
import 'package:http/http.dart' as http;

class Notification {
  sendNotificationTo(token, title, body) async {
    Map bodyNotification = {'title': title, 'body': body, 'sound': 'default'};
    Map<String, String> headersAPI = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmServerToken',
    };
    Map bodyAPI = {
      'to': token,
      'priority': 'high',
      'notification': bodyNotification,
      // 'data': dataMap,
    };
    http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headersAPI, body: jsonEncode(bodyAPI));
  }
}
