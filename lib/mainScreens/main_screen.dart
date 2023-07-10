// ignore_for_file: library_private_types_in_public_api

import 'package:e_shop/cartScreens/cart_screen_home.dart';
import 'package:e_shop/mainScreens/help_screen.dart';
import 'package:e_shop/mainScreens/home_screen.dart';
import 'package:e_shop/mainScreens/notification_screen.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:e_shop/testing/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const HomeScreen(),
    const CartScreenHome(),
    const NotificationScreen(),
    const HelpScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 1),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.5),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.black, spreadRadius: 0.2),
            ],
          ),
          // color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: GNav(
              backgroundColor: Colors.white,
              color: Colors.black,
              activeColor: Colors.black,
              tabBackgroundColor: Colors.grey.shade300,
              gap: 8,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              padding: const EdgeInsets.all(8),
              tabs: [
                const GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  gap: 12,
                  leading: badges.Badge(
                    showBadge:
                        context.read<PCart>().getItems.isEmpty ? false : true,
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: AppColors.contentColorGreen,
                    ),
                    badgeContent: Text(
                      context.watch<PCart>().getItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    ),
                  ),
                  icon: Icons.home,
                  text: 'Cart',
                ),
                const GButton(
                  icon: Icons.notifications,
                  text: 'Notifications',
                ),
                const GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
      // BottomNavigationBar(
      //   backgroundColor: Colors.blueAccent,
      //   elevation: 0,
      //   type: BottomNavigationBarType.fixed,
      //   selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      //   selectedItemColor: Colors.white,
      //   currentIndex: _selectedIndex,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notifications),
      //       label: 'Notification',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.help),
      //       label: 'Help',
      //     ),
      //     // BottomNavigationBarItem(
      //     //   icon: Badge(
      //     //       showBadge: context.read<Cart>().getItems.isEmpty ? false : true,
      //     //       padding: const EdgeInsets.all(2),
      //     //       badgeColor: Colors.yellow,
      //     //       badgeContent: Text(
      //     //         context.watch<Cart>().getItems.length.toString(),
      //     //         style: const TextStyle(
      //     //             fontSize: 16, fontWeight: FontWeight.w600),
      //     //       ),
      //     //       child: const Icon(Icons.shopping_cart)),
      //     //   label: 'Notification with badges',
      //     // ),
      //   ],
      // onTap: (index) {
      //   setState(() {
      //     _selectedIndex = index;
      //   });
      // },
      // ),
    );
  }
}
