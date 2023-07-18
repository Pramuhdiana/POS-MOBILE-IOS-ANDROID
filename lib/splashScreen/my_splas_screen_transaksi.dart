// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, unused_element

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/api/api_services.dart';
import 'package:e_shop/database/db_allitems_retur.dart';
import 'package:e_shop/mainScreens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';

import '../database/db_alldetailtransaksi.dart';
import '../database/db_allitems.dart';
import '../database/db_allitems_toko.dart';
import '../database/db_alltransaksi.dart';

class MySplashScreenTransaksi extends StatefulWidget {
  const MySplashScreenTransaksi({super.key});

  @override
  State<MySplashScreenTransaksi> createState() =>
      _MySplashScreenTransaksiState();
}

class _MySplashScreenTransaksiState extends State<MySplashScreenTransaksi>
    with TickerProviderStateMixin {
  late FlutterGifController controller1, controller2, controller3, controller4;
  var isLoading = false;

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = ApiServices();
    await DbAllitems.db.deleteAllitems();
    await DbAllitemsToko.db.deleteAllitemsToko();
    await DbAlltransaksi.db.deleteAlltransaksi();
    await DbAllitemsRetur.db.deleteAllitemsRetur();
    await DbAllKodekeluarbarang.db.deleteAllkeluarbarang();
    await DbAlldetailtransaksi.db.deleteAlldetailtransaksi();
    await apiProvider.getAllItems();
    await apiProvider.getAllItemsToko();
    await apiProvider.getAllTransaksi();
    await apiProvider.getAllItemsRetur();
    await apiProvider.getAllDetailTransaksi();
    await apiProvider.getAllKodekeluarbarang();
    await apiProvider.getAllCustomer();
    await apiProvider.getUsers();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _loadAllDataApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = ApiServicesFirebase();
    await apiProvider.getAllItems();
    await apiProvider.getAllItemsToko();
    await apiProvider.getAllDetailTransaksi();
    // await apiProvider.getAllTransaksi();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  splashScreenTimer() {
    Timer(const Duration(seconds: 1), () async {
      // await _deleteAlldetailtransaksifirebase();
      // await _deleteAllitemsfirebase();
      // await _deleteAllitemstokofirebase();
      // await _deleteAlltransaksifirebase();
      await _loadFromApi();
      // await _loadAllDataApi();
      await Navigator.push(
          context, MaterialPageRoute(builder: (c) => MainScreen()));
    });
  }

  @override
  void
      initState() //called automatically when user comes here to this splash screen
  {
    controller1 = FlutterGifController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller1.repeat(
        min: 0,
        max: 10,
        period: const Duration(milliseconds: 1000),
      );
    });
    super.initState();

    splashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GifImage(
                  image: const AssetImage("images/sukses.gif"),
                  controller: controller1),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "",
                style: TextStyle(
                  fontSize: 30,
                  letterSpacing: 3,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _deleteAllitemstokofirebase() {
    FirebaseFirestore.instance
        .collection('allitemstoko')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
        print('delete allitems toko in firebase berhasil');
      }
    });
  }

  _deleteAllitemsfirebase() {
    FirebaseFirestore.instance.collection('allitems').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
        print('delete allitems in firebase berhasil');
      }
    });
  }

  _deleteAlldetailtransaksifirebase() {
    FirebaseFirestore.instance
        .collection('alldetailtransaksi')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
        print('delete alldetailtransaksi in firebase berhasil');
      }
    });
  }

  _deleteAlltransaksifirebase() {
    FirebaseFirestore.instance
        .collection('alltransaksi')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
        print('delete alltransaksi in firebase berhasil');
      }
    });
  }
}
