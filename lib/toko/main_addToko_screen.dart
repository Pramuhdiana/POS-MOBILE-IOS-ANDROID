// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:e_shop/mainScreens/profile_screen.dart';
import 'package:e_shop/mainScreens/notification_screen.dart';
import 'package:e_shop/toko/upload_toko_screen.dart';
import 'package:flutter/material.dart';

class MainAddTokoScreen extends StatefulWidget {
  const MainAddTokoScreen({Key? key}) : super(key: key);

  @override
  _MainAddTokoScreenState createState() => _MainAddTokoScreenState();
}

class _MainAddTokoScreenState extends State<MainAddTokoScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const UploadTokoScreen(),
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
