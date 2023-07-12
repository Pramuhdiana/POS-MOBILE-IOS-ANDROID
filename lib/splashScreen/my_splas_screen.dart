// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/api/api_services.dart';
import 'package:e_shop/authScreens/auth_screen.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/mainScreens/main_screen.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:e_shop/provider/provider_cart_retur.dart';
import 'package:e_shop/provider/provider_cart_toko.dart';
import 'package:e_shop/provider/provider_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/db_alldetailtransaksi.dart';
import '../database/db_allitems.dart';
import '../database/db_allitems_toko.dart';
import '../database/db_alltransaksi.dart';
import '../database/db_notification_dummy.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  String? mtoken = " ";
  String token = sharedPreferences!.getString("token").toString();

  var isLoading = false;
  splashScreenTimer() {
    Timer(const Duration(seconds: 2), () async {
      //user sudah login
      print('token $token');
      if (sharedPreferences!.getString("token").toString() != "null") {
        await requestPermission();
        await _loadFromApi();
        try {
          sharedPreferences!.setString('total_product_sales', '0');
          await getToken();
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const MainScreen()));
        } catch (c) {
          sharedPreferences!.setString('total_product_sales', '0');
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const MainScreen()));
        }
      } else //user is NOT already Logged-in
      {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      }
    });
  }

//get token
  getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("token notif is $mtoken");
      });
      saveToken(token!);
    });
  }

  //save token
  saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(sharedPreferences!.getString("name").toString())
        .set({
      'token': token,
    });
  }

  //request permission
  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provosional permission');
    } else {
      print('user declined or has not accepted permission');
    }
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance
        .collection("UserTokens")
        .doc('Sandy')
        .snapshots()
        .listen((event) {
      setState(() {
        fcmTokensandy = event.get("token");
        print('token sandy done');
      });
    });
    context.read<PCart>().clearCart();
    context.read<PCartToko>().clearCart();
    context.read<PCartRetur>().clearCart();
    var apiProvider = ApiServices();
    await DbAllitems.db.deleteAllitems();
    await DbAllitemsToko.db.deleteAllitemsToko();
    await DbAlltransaksi.db.deleteAlltransaksi();
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

    context.read<PNewNotif>().clearNotif();
    DbNotifDummy.db.getAllNotif(1).then((value) {
      for (var i = 0; i < value.length; i++) {
        context.read<PNewNotif>().addItem(
              1,
            );
      }
    });
    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

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

  @override
  void
      initState() //called automatically when user comes here to this splash screen
  {
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
            Colors.blueAccent,
            Colors.lightBlueAccent,
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset("images/welcomeIcon.png"),
              ),
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
}

// ignore_for_file: prefer_void_to_null

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:e_shop/api/api_constant.dart';
// import 'package:e_shop/global/global.dart';

// class EmployeeApiProvider {
//   String token = sharedPreferences!.getString("token").toString();
//   Future<List<Null>> getAllEmployees() async {
//     // var url = "https://hub.dummyapis.com/employee?noofRecords=10&idStarts=1001";
//     // Response response = await Dio().get(url);
//     var url = "http://110.5.102.154:8080/api/indexpossales";
//     Response response = await Dio().get(url,
//         options: Options(headers: {"Authorization": "Bearer $token"}));

//     return (response.data as List).map((employee) {
//       // print('Inserting $employee');
//       CollectionReference orderRef =
//           FirebaseFirestore.instance.collection('allitems');
//       orderRef.doc(employee['name'].toString()).set({
//         'id': employee['id'],
//         'name': employee['name'],
//         'slug': employee['slug'],
//         'image_name': employee['image_name'],
//         'description': employee['description'],
//         'price': employee['price'],
//         'category_id': employee['category_id'],
//         'posisi_id': employee['posisi_id'],
//         'cutomer_id': employee['cutomer_id'],
//         'kode_refrensi': employee['kode_refrensi'],
//         'sales_id': employee['sales_id'],
//         'brand_id': employee['brand_id'],
//         'qty': employee['qty'],
//         'status_titipan': employee['status_titipan'],
//         'keterangan_barang': employee['keterangan_barang'],
//         'created_at': employee['created_at'],
//         'updated_at': employee['updated_at'],
//       });
//       // DBProvider.db.createEmployee(Employee.fromJson(employee));
//     }).toList();
//   }

//   Future<List<Null>> getAllTransaksi() async {
//     // var url = "https://hub.dummyapis.com/employee?noofRecords=10&idStarts=1001";
//     // Response response = await Dio().get(url);
//     Response response = await Dio().get(
//         ApiConstants.baseUrl + ApiConstants.transaksiendpoint,
//         options: Options(headers: {"Authorization": "Bearer $token"}));

//     return (response.data as List).map((transaksi) {
//       // print('Inserting $transaksi');

//       CollectionReference orderRef =
//           FirebaseFirestore.instance.collection('alltransaksi');
//       orderRef.doc(transaksi['invoices_number'].toString()).set({
//         'invoices_number': transaksi['invoices_number'],
//         'user_id': transaksi['user_id'],
//         'customer_id': transaksi['customer_id'],
//         'customer_metier': transaksi['customer_metier'],
//         'jenisform_id': transaksi['jenisform_id'],
//         'sales_id': transaksi['sales_id'],
//         'total': transaksi['total'],
//         'total_quantity': transaksi['total_quantity'],
//         'total_rupiah': transaksi['total_rupiah'],
//         'created_at': transaksi['created_at'],
//         'updated_at': transaksi['updated_at'],
//       });
//       // DBProvider.db.createEmployee(Employee.fromJson(employee));
//     }).toList();
//   }

//   Future<List<Null>> getAllPosToko() async {
//     // var url = "https://hub.dummyapis.com/employee?noofRecords=10&idStarts=1001";
//     // Response response = await Dio().get(url);
//     var url = "http://110.5.102.154:8080/api/indexpossales";
//     Response response = await Dio().get(url,
//         options: Options(headers: {"Authorization": "Bearer $token"}));

//     return (response.data as List).map((itemstoko) {
//       // print('Inserting $itemstoko');
//       CollectionReference orderRef =
//           FirebaseFirestore.instance.collection('allitems');
//       orderRef.doc(itemstoko['name'].toString()).set({
//         'id': itemstoko['id'],
//         'name': itemstoko['name'],
//         'slug': itemstoko['slug'],
//         'image_name': itemstoko['image_name'],
//         'description': itemstoko['description'],
//         'price': itemstoko['price'],
//         'category_id': itemstoko['category_id'],
//         'posisi_id': itemstoko['posisi_id'],
//         'cutomer_id': itemstoko['cutomer_id'],
//         'kode_refrensi': itemstoko['kode_refrensi'],
//         'sales_id': itemstoko['sales_id'],
//         'brand_id': itemstoko['brand_id'],
//         'qty': itemstoko['qty'],
//         'status_titipan': itemstoko['status_titipan'],
//         'keterangan_barang': itemstoko['keterangan_barang'],
//         'created_at': itemstoko['created_at'],
//         'updated_at': itemstoko['updated_at'],
//       });
//       // DBProvider.db.createEmployee(Employee.fromJson(employee));
//     }).toList();
//   }
// }


// Widget _dialogContent; // Declare this outside the method, globally in the class

// // In your method:
// _dialogContent = CircularProgressIndicator();
// showDialog(
//         context: context,
//         builder: (BuildContext context) => Container(
//           child: AlertDialog(
//             content: _dialogContent, // The content inside the dialog
//           )
//         )
//     ); // Your Dialog
// Future.delayed(Duration(seconds: 15)); // Duration to wait
// setState((){
//   _dialogContent = Container(...), // Add your Button to try again and message text in this
// })