// ignore_for_file: library_private_types_in_public_api

import 'package:e_shop/cartScreens/cart_screen_home.dart';
import 'package:e_shop/mainScreens/profile_screen.dart';
import 'package:e_shop/mainScreens/home_screen.dart';
import 'package:e_shop/mainScreens/notification_screen.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:e_shop/provider/provider_notification.dart';
import 'package:e_shop/testing/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  DateTime backPressedTime = DateTime.now();

  final List<Widget> _tabs = [
    const HomeScreen(),
    const CartScreenHome(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonClicked(context),
      child: Scaffold(
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
              // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 20, top: 10),

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
                padding: const EdgeInsets.all(7),
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
                    icon: Icons.shopping_cart,
                    text: 'Cart',
                  ),
                  GButton(
                    gap: 12,
                    leading: badges.Badge(
                      showBadge: true,
                      // showBadge:
                      //     context.read<PCart>().getItems.isEmpty ? false : true,
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: AppColors.contentColorGreen,
                      ),
                      badgeContent: Text(
                        context.watch<PNewNotif>().getItems.length.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.black,
                      ),
                    ),
                    icon: Icons.notifications,
                    text: 'Notification',
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
      ),
    );
  }

  Future<bool> _onBackButtonClicked(BuildContext context) async {
    //in time
    final difference = DateTime.now().difference(backPressedTime);
    backPressedTime = DateTime.now();

    if (difference >= const Duration(seconds: 2)) {
      Fluttertoast.showToast(msg: "Click again to close the app");
      return false;
    } else {
      SystemNavigator.pop(animated: true);
      return true;
    }
  }
}
