// ignore_for_file: library_private_types_in_public_api

import 'package:e_shop/cartScreens/cart_screen_home.dart';
import 'package:e_shop/global/global.dart';
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
import 'package:iconsax/iconsax.dart';

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
    // ignore: avoid_print
    print('No Version : $noBuild');
    return WillPopScope(
      onWillPop: () => _onBackButtonClicked(context),
      child: Scaffold(
        body: _tabs[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey.shade400, spreadRadius: 0.5),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 30, right: 30, bottom: 25, top: 15),
            child: GNav(
              backgroundColor: Colors.white,
              color: Colors.black,
              activeColor: Colors.black,
              tabBackgroundColor: const Color(0xFBEEEEEE),
              gap: 8,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              padding: const EdgeInsets.all(5),
              tabs: [
                const GButton(
                  iconActiveColor: Colors.white,
                  backgroundColor: Colors.black,
                  icon: Iconsax.home_25,
                  text: 'Home',
                  textStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                GButton(
                  backgroundColor: Colors.black,
                  gap: 12,
                  leading: badges.Badge(
                    showBadge:
                        context.read<PCart>().getItems.isEmpty ? false : true,
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: AppColors.contentColorBlack,
                    ),
                    badgeContent: Text(
                      context.watch<PCart>().getItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: _selectedIndex != 1
                        ? const Icon(
                            Iconsax.shopping_cart5,
                            color: Colors.black,
                          )
                        : const Icon(
                            Iconsax.shopping_cart5,
                            color: Colors.white,
                          ),
                  ),
                  icon: Icons.shopping_cart,
                  text: 'Cart',
                  textStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                GButton(
                  backgroundColor: Colors.black,
                  gap: 12,
                  leading: badges.Badge(
                    showBadge: true,
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: AppColors.contentColorBlack,
                    ),
                    badgeContent: Text(
                      context.watch<PNewNotif>().getItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: _selectedIndex != 2
                        ? const Icon(
                            Iconsax.notification1,
                            color: Colors.black,
                          )
                        : const Icon(
                            Iconsax.notification1,
                            color: Colors.white,
                          ),
                  ),
                  icon: Icons.notifications,
                  text: 'Notification',
                  textStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const GButton(
                  iconActiveColor: Colors.white,
                  backgroundColor: Colors.black,
                  icon: Icons.person,
                  text: 'Profile',
                  textStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
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
