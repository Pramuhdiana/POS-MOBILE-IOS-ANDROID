// ignore_for_file: file_names

import 'package:e_shop/database/db_notification_dummy.dart';
import 'package:e_shop/push_notifications/list_all_notif_screen.dart';
import 'package:flutter/material.dart';

class ListAllNotif extends StatelessWidget {
  const ListAllNotif({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DbNotifDummy.db.getAllNotif(2),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data.isEmpty) {
            return const Center(
                child: Text(
              'You Have not \n\nNotification',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Acne',
                  letterSpacing: 1.5),
            ));
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListAllNotifScreen(
                    // customer: snapshot2.data[index],
                    notif: snapshot.data[index],
                  );
                });
          }
        });
  }
}