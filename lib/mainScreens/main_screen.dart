// ignore_for_file: library_private_types_in_public_api

import 'package:e_shop/mainScreens/help_screen.dart';
import 'package:e_shop/mainScreens/home_screen.dart';
import 'package:e_shop/mainScreens/notification_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const HomeScreen(),
    const NotificationScreen(),
    const HelpScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help',
          ),
          // BottomNavigationBarItem(
          //   icon: Badge(
          //       showBadge: context.read<Cart>().getItems.isEmpty ? false : true,
          //       padding: const EdgeInsets.all(2),
          //       badgeColor: Colors.yellow,
          //       badgeContent: Text(
          //         context.watch<Cart>().getItems.length.toString(),
          //         style: const TextStyle(
          //             fontSize: 16, fontWeight: FontWeight.w600),
          //       ),
          //       child: const Icon(Icons.shopping_cart)),
          //   label: 'Notification with badges',
          // ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
