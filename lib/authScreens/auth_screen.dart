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
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        // appBar: AppBar(
        //   flexibleSpace: Container(
        //     decoration: const BoxDecoration(
        //         gradient: LinearGradient(
        //       colors: [
        //         Colors.blueAccent,
        //         Colors.lightBlueAccent,
        //       ],
        //       begin: FractionalOffset(0.0, 0.0),
        //       end: FractionalOffset(1.0, 0.0),
        //       stops: [0.0, 1.0],
        //       tileMode: TileMode.clamp,
        //     )),
        //   ),
        //   title: const Text(
        //     "POS Mobile",
        //     style: TextStyle(
        //       fontSize: 30,
        //       letterSpacing: 3,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   centerTitle: true,
        //   bottom: const TabBar(
        //     indicatorColor: Colors.white54, //warna bottom bawah
        //     indicatorWeight: 3, //ukuran bottom bawah
        //     tabs: [
        //       Tab(
        //         text: "Login",
        //         icon: Icon(
        //           Icons.lock,
        //           color: Colors.white,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bg-blue.png"),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.lightBlueAccent,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
          child: const TabBarView(children: [LoginTabPage()]),
        ),
      ),
    );
  }
}
