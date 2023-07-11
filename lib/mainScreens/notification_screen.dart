// ignore_for_file: avoid_print

import 'package:e_shop/CRM/list_crm_telephone.dart';
import 'package:e_shop/database/db_notification_dummy.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/history/main_history.dart';
import 'package:e_shop/push_notifications/list_Newnotif.dart';
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

  @override
  void initState() {
    //  strat push notification
    // PushNotificationsSystem pushNotificationsSystem = PushNotificationsSystem();
    // pushNotificationsSystem.notificationPopUp(context);
    // pushNotificationsSystem.whenNotificationReceived(context); //popup dari bottom tanpa confirmasi oke
    // end push notification
    super.initState();
    DbNotifDummy.db.getAllNotif();
    print(fcmTokensandy);
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
          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back_ios_new,
          //     color: Colors.black,
          //   ),
          //   onPressed: () {
          //     // Navigator.push(
          //     //     context, MaterialPageRoute(builder: (c) => PosSalesScreen()));
          //     Navigator.pop(context);
          //   },
          // ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Notification",
            style: TextStyle(color: Colors.black),
          ),
          // title: const FakeSearch(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          bottom: const TabBar(
              indicatorColor: Colors.black,
              indicatorWeight: 5,
              tabs: [
                RepeatedTab(label: 'New Notif'),
                RepeatedTab(label: 'Notifictaion'),
              ]),
        ),
        body: const TabBarView(children: [
          ListNewNotif(),
          ListCrmTelephone(),
        ]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            DbNotifDummy.db.deleteAllnotif();
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (c) => AddFormCRM()));
          },
          label: const Text(
            "Delete Data",
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(
            Icons.add_circle_outline_sharp,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
  // body: RefreshIndicator(
  //   onRefresh: refresh,
  //   child: Padding(
  //     padding: const EdgeInsets.only(top: 150),
  //     child: Center(
  //       child: Form(
  //         key: formKey,
  //         child: Column(
  //           children: [
  //             SizedBox(
  //               width: 257,
  //               child: TextFormField(
  //                   textAlign: TextAlign.center,
  //                   controller: title,
  //                   decoration: InputDecoration(
  //                     hintStyle: const TextStyle(
  //                         fontSize: 18.0, color: Colors.black),
  //                     hintText: "Title",
  //                     // suffixIcon: IconButton(
  //                     //   onPressed: title.clear,
  //                     //   icon: const Icon(Icons.clear),
  //                     //   color: Colors.red,
  //                     // ),
  //                     fillColor: Colors.white,
  //                     filled: true,
  //                     enabledBorder: OutlineInputBorder(
  //                       borderSide: const BorderSide(
  //                           color: Colors.black, width: 1),
  //                       borderRadius: BorderRadius.circular(100.0),
  //                     ),
  //                   )),
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             SizedBox(
  //               width: 257,
  //               child: TextFormField(
  //                   textAlign: TextAlign.center,
  //                   controller: body,
  //                   decoration: InputDecoration(
  //                     hintStyle: const TextStyle(
  //                         fontSize: 18.0, color: Colors.black),
  //                     hintText: "Body",
  //                     fillColor: Colors.white,
  //                     filled: true,
  //                     enabledBorder: OutlineInputBorder(
  //                       borderSide: const BorderSide(
  //                           color: Colors.black, width: 1),
  //                       borderRadius: BorderRadius.circular(100.0),
  //                     ),
  //                   )),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   ),
  // ),
  // bottomNavigationBar: Padding(
  //   padding: const EdgeInsets.only(left: 50, right: 50, bottom: 5),
  //   child: CustomLoadingButton(
  //     backgroundColor: Colors.black,
  //     controller: btnController,
  //     onPressed: () {
  //       Future.delayed(const Duration(seconds: 1)).then((value) async {
  //         btnController.success(); //sucses
  //         await notif.sendNotificationTo(
  //             fcmTokensandy, title.text, body.text);
  //         Future.delayed(const Duration(seconds: 2)).then((value) {
  //           btnController.reset(); //reset
  //           title.clear();
  //           body.clear();
  //         });
  //       });
  //     },
  //     //  c: Colors.blue,
  //     child: const Text(
  //       "Send Notification",
  //       style: TextStyle(color: Colors.white),
  //     ),
  //   ),
  // )
}
