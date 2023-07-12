// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:e_shop/mainScreens/profile_screen.dart';
import 'package:e_shop/mainScreens/notification_screen.dart';
import 'package:e_shop/posRetur/pos_retur_screen.dart';
import 'package:flutter/material.dart';

class MainPosReturScreen extends StatefulWidget {
  const MainPosReturScreen({Key? key}) : super(key: key);

  @override
  _MainPosReturScreenState createState() => _MainPosReturScreenState();
}

class _MainPosReturScreenState extends State<MainPosReturScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const PosReturScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
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
