// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, unused_element

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/api/api_services.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/mainScreens/main_screen.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../database/db_allitems.dart';

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
    // await DbAllitems.db.deleteAllitems();
    sharedPreferences!.setString('newOpenPosSales', 'true');
    // await DbAllitemsToko.db.deleteAllitemsToko();
    sharedPreferences!.setString('newOpenPosToko', 'true');
    // await DbAllitemsRetur.db.deleteAllitemsRetur();
    // await DbAlltransaksiNewVoucher.db.deleteAlltransaksiNewVoucher();
    // await DbAlldetailtransaksi.db.deleteAlldetailtransaksi();
    await DbAllKodekeluarbarang.db.deleteAllkeluarbarang();
    // try {
    //   await apiProvider.getAllItems();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all items");
    // }
    // try {
    //   await apiProvider.getAllItemsToko();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all items toko");
    // }
    // try {
    //   await apiProvider.getAllItemsRetur();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all items retur");
    // }
    // try {
    //   await apiProvider.getAllTransaksiNewVoucher();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all transaksi");
    // }
    // try {
    //   await apiProvider.getAllDetailTransaksi();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all details transaksi");
    // }
    try {
      apiProvider.getAllKodekeluarbarang();
    } catch (c) {
      Fluttertoast.showToast(msg: "Failed To Load Data all code refrence");
    }
    // try {
    //   await apiProvider.getAllCustomer();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all customer");
    // }
    // try {
    //   await apiProvider.getUsers();
    // } catch (c) {
    //   sharedPreferences!.setString('name', 'Failed To Load Data');

    //   Fluttertoast.showToast(msg: "Failed To Load Data User");
    // }
    // try {
    //   await apiProvider.getAllTCRM();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data CRM");
    // }

    setState(() {
      isLoading = false;
    });
  }

  // _loadAllDataApi() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   var apiProvider = ApiServicesFirebase();
  //   await apiProvider.getAllItems();
  //   await apiProvider.getAllItemsToko();
  //   await apiProvider.getAllDetailTransaksi();
  //   // await apiProvider.getAllTransaksi();

  //   // wait for 2 seconds to simulate loading of data
  //   await Future.delayed(const Duration(seconds: 2));

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  splashScreenTimer() {
    Timer(const Duration(seconds: 1), () async {
      // await _deleteAlldetailtransaksifirebase();
      // await _deleteAllitemsfirebase();
      // await _deleteAllitemstokofirebase();
      // await _deleteAlltransaksifirebase();
      await _loadFromApi();
      context.read<PCart>().clearCart(); //clear cart
      await loadCartFromApiPOSSALES();
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
              Lottie.asset("json/success.json"),
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

  loadCartFromApiPOSSALES() async {
    String? tokens = sharedPreferences!.getString('token');
    var url = ApiConstants.baseUrl + ApiConstants.GETkeranjangsalesendpoint;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $tokens"}));

    return (response.data as List).map((cart) {
      var existingitemcart = context
          .read<PCart>()
          .getItems
          .firstWhereOrNull((element) => element.name == cart['lot']);

      if (existingitemcart == null) {
        print('Inserting Cart berhasil');
        context.read<PCart>().addItem(
              cart['lot'].toString(),
              cart['price'],
              cart['qty'],
              cart['image_name'].toString(),
              cart['product_id'].toString(),
              cart['user_id'].toString(),
              cart['description'].toString(),
              cart['keterangan_barang'].toString(),
            );
      } else {}
      // DbAllItems.db.createAllItems(AllItems.fromJson(items));
    }).toList();
  }
}
