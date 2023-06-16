// // ignore_for_file: avoid_print, avoid_unnecessary_containers

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// // ignore: use_key_in_widget_constructors
// class MainNotification extends StatefulWidget {
//   @override
//   // ignore: library_private_types_in_public_api
//   _MainNotificationState createState() => _MainNotificationState();
// }

// class _MainNotificationState extends State<MainNotification> {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   String _message = '';

//   _registerOnFirebase() {
//     _firebaseMessaging.subscribeToTopic('all');
//     _firebaseMessaging.getToken().then((token) => print(token));
//   }

//   @override
//   void initState() {
//     _registerOnFirebase();
//     getMessage();
//     super.initState();
//   }

//   void getMessage() {
//     FirebaseMessaging.onMessage.listen((Map<String, dynamic> message) async {
//       print('received message');
//       setState(() => _message = message["notification"]["body"]);
//     } as void Function(RemoteMessage event)?);
//   }
//   // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   //     RemoteNotification notification = message.notification;
//   //     AndroidNotification android = message.notification?.android;
//   //   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Push Notifications Test'),
//       ),
//       body: Container(
//           child: Center(
//         child: Text("Message: $_message"),
//       )),
//     );
//   }
// }
