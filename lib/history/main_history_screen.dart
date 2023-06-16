// ignore_for_file: library_private_types_in_public_api

import 'package:e_shop/history/main_history.dart';
import 'package:e_shop/mainScreens/help_screen.dart';
import 'package:e_shop/mainScreens/notification_screen.dart';
import 'package:flutter/material.dart';

class MainHistoryScreen extends StatefulWidget {
  const MainHistoryScreen({Key? key}) : super(key: key);

  @override
  _MainHistoryScreenState createState() => _MainHistoryScreenState();
}

class _MainHistoryScreenState extends State<MainHistoryScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const MainHistory(),
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
