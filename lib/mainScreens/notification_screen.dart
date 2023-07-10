// ignore_for_file: avoid_print

import 'package:e_shop/global/global.dart';
import 'package:e_shop/widgets/custom_loading.dart';
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
  }

  Future refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )),
          ),
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back_ios_new,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          title: const Text(
            "Notification",
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 3,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: refresh,
          child: Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 257,
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: title,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                fontSize: 18.0, color: Colors.black),
                            hintText: "Title",
                            // suffixIcon: IconButton(
                            //   onPressed: title.clear,
                            //   icon: const Icon(Icons.clear),
                            //   color: Colors.red,
                            // ),
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 257,
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: body,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                fontSize: 18.0, color: Colors.black),
                            hintText: "Body",
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, bottom: 5),
          child: CustomLoadingButton(
            backgroundColor: Colors.black,
            controller: btnController,
            onPressed: () {
              Future.delayed(const Duration(seconds: 1)).then((value) async {
                btnController.success(); //sucses
                await notif.sendNotificationTo(
                    fcmTokensandy, title.text, body.text);
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  btnController.reset(); //reset
                  title.clear();
                  body.clear();
                });
              });
            },
            //  c: Colors.blue,
            child: const Text(
              "Send Notification",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}
