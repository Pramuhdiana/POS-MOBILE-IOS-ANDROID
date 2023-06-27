import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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
        //open app and show notification data
        showNotificationWhenOpenApp(
          context,
        );
      }
    });

    //2. Foreground
    //When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //directly show notification data
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(remoteMessage.notification!.title!),
                content: Text(remoteMessage.notification!.body!),
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    });

    //3. Background
    //When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //open the app - show notification data
        showNotificationWhenOpenApp(
          context,
        );
      }
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
      duration: const Duration(seconds: 2),
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

    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   print("message recieved");
    //   print(event.notification!.body);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('Message clicked!');
    // });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(event.notification!.title!),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    messaging.subscribeToTopic("messaging");
  }
}
