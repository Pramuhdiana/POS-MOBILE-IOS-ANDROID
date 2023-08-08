// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/database/db_notification_dummy.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/history/main_history.dart';
import 'package:e_shop/push_notifications/list_Newnotif.dart';
import 'package:e_shop/push_notifications/list_all_notification.dart';
import 'package:e_shop/push_notifications/push_notifications_system.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  late FirebaseMessaging messaging;
  String? mtoken = " ";

  @override
  void initState() {
    super.initState();
//star notifi
    PushNotificationsSystem pushNotificationsSystem = PushNotificationsSystem();
    pushNotificationsSystem.whenNotificationReceived(context);
    // pushNotificationsSystem.notificationPopUp(context);
    //end notif
    DbNotifDummy.db.getAllNotif(1);
    getToken();
  }

  Future refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Notification",
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
          // title: const FakeSearch(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          bottom: const TabBar(
              indicatorColor: Colors.black,
              indicatorWeight: 5,
              tabs: [
                RepeatedTab(label: 'Unread'),
                RepeatedTab(label: 'Read'),
              ]),
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: const TabBarView(children: [
            ListNewNotif(),
            ListAllNotif(),
          ]),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     DbNotifDummy.db.deleteAllnotif();
        //     context.read<PNewNotif>().clearNotif();
        //   },
        //   label: const Text(
        //     "Delete Data",
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   icon: const Icon(
        //     Icons.add_circle_outline_sharp,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.black,
        // ),
      ),
    );
  }

  //get token
  getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("token notif is $mtoken");
      });
      saveToken(token!);
      // messaging.subscribeToTopic("allUsers");
    });
  }

  //save token
  saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(sharedPreferences!.getString("name").toString())
        .set({
      'token': token,
    });
  }

  //request permission
  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provosional permission');
    } else {
      print('user declined or has not accepted permission');
    }
  }
}
