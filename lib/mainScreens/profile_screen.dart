import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   //star notifi
  //   PushNotificationsSystem pushNotificationsSystem = PushNotificationsSystem();
  //   pushNotificationsSystem.whenNotificationReceived(context);
  //   // pushNotificationsSystem.notificationPopUp(context);
  //   //end notif
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Icon(
          Icons.help,
          size: 150,
        ),
      ),
    );
  }
}
