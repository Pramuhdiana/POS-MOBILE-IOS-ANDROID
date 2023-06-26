// ignore_for_file: avoid_print

import 'package:e_shop/global/global.dart';
import 'package:e_shop/push_notifications/push_notifications_system.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  late FirebaseMessaging messaging;

  @override
  void initState() {
    //  strat push notification
    PushNotificationsSystem pushNotificationsSystem = PushNotificationsSystem();
    pushNotificationsSystem.notificationPopUp(context);
    // pushNotificationsSystem.whenNotificationReceived(context); //popup dari bottom tanpa confirmasi oke
    // end push notification
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.white,
      body: Row(children: [
        Center(
          child: IconButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "Not Available");
              sendMotificationToBc(
                  "eTPAF2EIQga8UyApDCLeT-:APA91bF-AN95GI30lsGH-ErYuAEiqRAQ9yuhlNYppYpMaE6U0F832nCv4DtXJ7hCdgHkZtF1vYs2ky9xI4BZF8CUloKRXPyc3oyAUBCpOK1QYEW4i8uotKZShxvJJs3Y9ZHF1ipIjKJ4",
                  123.toString());

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (c) => const CartScreen()));
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.black,
              // size: 350,
            ),
          ),
        ),
      ]),
    );
  }

  //initinfo
//   initInfo() {
//     var androidInitialize =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOSInitialize = const DarwinInitializationSettings();
//     // ignore: unused_local_variable
//     var initializationsSettings =
//         InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

// //         FlutterLocalNotificationsPlugin.initialize(initializationsSettings, onSe: (String? payload) async
// //         {
// //  try {
// //         if(payload != null && payload.isNotEmpty) {

// //         }else {

// //         } catch(e) {

// //         }
// //         return;
// //       }
// //   });
//   }

  sendMotificationToBc(tokenBC, orderIdDiskon) {
    String bcDeviceToken = tokenBC;
    notificationFormat(
      bcDeviceToken,
      orderIdDiskon,
      sharedPreferences!.getString("name"),
    );
  }

  notificationFormat(bcDeviceToken, orderIdDiskon, userName) {
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmServerToken',
    };

    Map bodyNotification = {
      'body': "Dear BC, Request diskon has approved. \nPlease check now.",
      'title': "Request Diskon",
    };

    // Map dataMap = {
    //   "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //   "id": "1",
    //   "status": "done",
    //   "bcOrderId": orderIdDiskon,
    // };

    Map officialNotificationFormat = {
      'notification': bodyNotification,
      // 'data': dataMap,
      'priority': 'high',
      'to': bcDeviceToken,
    };

    http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }
}
