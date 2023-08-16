// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:badges/badges.dart' as badges;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';

import 'approval_pricing_eticketing.dart';
import 'approval_pricing_brj_screen.dart';
import 'approved_pricing_brj_screen.dart';
import 'approved_pricing_eticketing.dart';

class MainScreenApprovePricing extends StatefulWidget {
  const MainScreenApprovePricing({Key? key}) : super(key: key);

  @override
  _MainScreenApprovePricingState createState() =>
      _MainScreenApprovePricingState();
}

class _MainScreenApprovePricingState extends State<MainScreenApprovePricing> {
  int _selectedIndex = 0;
  DateTime backPressedTime = DateTime.now();

  final List<Widget> _tabs = [
    ApprovalPricingBrjScreen(),
    ApprovedPricingBrjScreen(),
    ApprovalPricingEticketingScreen(),
    ApprovedPricingEticketingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonClicked(context),
      child: Scaffold(
        body: _tabs[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.5),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.black, spreadRadius: 0.2),
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
              tabs: const [
                GButton(
                  iconActiveColor: Colors.white,
                  backgroundColor: Colors.black,
                  icon: Iconsax.home_25,
                  text: 'Waiting Approval BRJ',
                  textStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                GButton(
                  iconActiveColor: Colors.white,
                  backgroundColor: Colors.black,
                  icon: Iconsax.home_25,
                  text: 'Approved BRJ',
                  textStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                GButton(
                  iconActiveColor: Colors.white,
                  backgroundColor: Colors.black,
                  icon: Icons.person,
                  text: 'Waiting Approval E-Ticketing',
                  textStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                GButton(
                  iconActiveColor: Colors.white,
                  backgroundColor: Colors.black,
                  icon: Icons.approval,
                  text: 'Approved E-Ticketing',
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
