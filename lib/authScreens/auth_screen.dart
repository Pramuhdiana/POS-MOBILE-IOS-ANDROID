import 'package:e_shop/authScreens/login_tab_page.dart';
// import 'package:e_shop/authScreens/registration_tab_page.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 1,
      child: Scaffold(
        body: TabBarView(children: [LoginTabPage()]),
      ),
    );
  }
}
