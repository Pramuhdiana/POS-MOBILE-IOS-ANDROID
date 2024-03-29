// ignore_for_file: avoid_print, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';

import 'package:e_shop/database/db_notification_dummy.dart';
import 'package:e_shop/database/model_notification_dummy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';
import '../global/global.dart';
import '../provider/provider_notification.dart';

class PushNotificationsSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //notifications arrived/received
  Future whenNotificationReceived(BuildContext context) async {
    //1. Terminated
    //When the app is completely closed and opened directly from the push notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        var cek = sharedPreferences!.getString("msg");
        print(cek);
        if (cek == '3 done') {
          print("message recieved no 1 stop");
        } else {
          print("message recieved no 1");
          sharedPreferences!.setString('msg', '1 done');
          context.read<PNewNotif>().addItem(
                1,
              );
          //add to database
          DbNotifDummy.db.saveNotifDummy(ModelNotificationDummy(
              title: remoteMessage.notification!.title,
              body: remoteMessage.notification!.body,
              created_at: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
              status: 1));
        }

        // //open app and show notification data
        // showNotificationWhenOpenApp(
        //   context,
        // );
      } else {}
    });

    //2. Foreground
    //When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) async {
      if (remoteMessage != null) {
        print("message recieved no 2");
        //add to notif
        print("add notif");
        context.read<PNewNotif>().addItem(
              1,
            );
        //add to database
        DbNotifDummy.db.saveNotifDummy(ModelNotificationDummy(
            title: remoteMessage.notification!.title,
            body: remoteMessage.notification!.body,
            created_at: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
            status: 1));
        // //open app and show notification data
        showSimpleNotification(
          Text(remoteMessage.notification!.title.toString()),
          subtitle: Text(remoteMessage.notification!.body.toString()),
          background: Colors.orange.shade700,
          duration: const Duration(seconds: 5),
        );
        // showNotificationWhenOpenApp(
        //   context,
        // );
      } else {}
    });

    // 3. Background
    // When the app is in the background and opened directly from the push notification.

    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage? remoteMessage3) async {
      if (remoteMessage3 != null) {
        var cek = sharedPreferences!.getString("msg");
        print(cek);
        if (cek == '1 done') {
          print("message recieved no 1 stop");
        } else {
          print("message recieved no 3");
          sharedPreferences!.setString('msg', '3 done');
          print('msg${sharedPreferences!.getString("msg")}');
          context.read<PNewNotif>().addItem(
                1,
              );
          print("add message no 3");
          //add to database
          await DbNotifDummy.db.saveNotifDummy(ModelNotificationDummy(
              title: remoteMessage3.notification!.title,
              body: remoteMessage3.notification!.body,
              created_at: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
              status: 1));

          //open the app - show notification data
          showSimpleNotification(
            Text(remoteMessage3.notification!.title.toString()),
            subtitle: Text(remoteMessage3.notification!.body.toString()),
            background: Colors.orange.shade700,
            duration: const Duration(seconds: 5),
          );
          // showNotificationWhenOpenApp(
          //   context,
          // );
        }
      } else {}
    });
  }

  Future whenNotificationReceivedInPricing(BuildContext context) async {
    //1. Terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        var cek = sharedPreferences!.getString("msg");
        print(cek);
        if (cek == '3 done') {
          print("message recieved no 1 stop");
        } else {
          print("message recieved no 1");
        }
      } else {}
    });

    //2. Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) async {
      if (remoteMessage != null) {
        print("message recieved no 2");
        showSimpleNotification(
          Text(remoteMessage.notification!.title.toString()),
          subtitle: Text(remoteMessage.notification!.body.toString()),
          background: Colors.orange.shade700,
          duration: const Duration(seconds: 5),
        );
        // showNotificationWhenOpenApp(
        //   context,
        // );
      } else {}
    });

    // 3. Background
    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage? remoteMessage3) async {
      if (remoteMessage3 != null) {
        var cek = sharedPreferences!.getString("msg");
        print(cek);
        if (cek == '1 done') {
          print("message recieved no 1 stop");
        } else {
          print("message recieved no 3");
          showSimpleNotification(
            Text(remoteMessage3.notification!.title.toString()),
            subtitle: Text(remoteMessage3.notification!.body.toString()),
            background: Colors.orange.shade700,
            duration: const Duration(seconds: 5),
          );
          // showNotificationWhenOpenApp(
          //   context,
          // );
        }
      } else {}
    });
  }

  // //device recognition token
  // Future generateDeviceRecognitionToken() async {
  //   String? registrationDeviceToken = await messaging.getToken();

  //   FirebaseFirestore.instance
  //       .collection("UserTokens")
  //       .doc(sharedPreferences!.getString("name"))
  //       .update({
  //     "token": registrationDeviceToken,
  //   });

  //   messaging.subscribeToTopic("allSellers");
  //   messaging.subscribeToTopic("allUsers");
  // }

  showNotificationWhenOpenApp(context) {
    showReusableSnackBar(
        context, "you have new Notification. \n\n Please Check now.");
  }

  showReusableSnackBar(BuildContext context, String title) {
    SnackBar snackBar = SnackBar(
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 5),
      content: Text(
        title.toString(),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future notificationPopUp(BuildContext context) async {
    messaging = FirebaseMessaging.instance;
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('Message clicked!');
    // });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("message recieved");
      await DbNotifDummy.db.saveNotifDummy(ModelNotificationDummy(
          title: event.notification!.title,
          body: event.notification!.body,
          created_at: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
          status: 1));
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text(event.notification!.title!),
      //         content: Text(event.notification!.body!),
      //         actions: [
      //           TextButton(
      //             child: const Text("Ok"),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //           )
      //         ],
      //       );
      //     });
    });
    // messaging.subscribeToTopic("messaging");
  }
}
