// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/authScreens/auth_screen.dart';
import 'package:e_shop/buStephanie/main_screen_approve_pricing.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/mainScreens/main_screen.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../api/api_services.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  String? mtoken = " ";
  String token = sharedPreferences!.getString("token").toString();
  int role = 0;

  var isLoading = false;
  splashScreenTimer() {
    Timer(const Duration(seconds: 1), () async {
      //user sudah login
      print('token $token');
      if (sharedPreferences!.getString("token").toString() != "null") {
        await requestPermission();
        try {
          await _loadFromApi();
          try {
            sharedPreferences!.setString('newOpen', 'true');
            sharedPreferences!.setString('newOpenHome', 'true');
            sharedPreferences!.setString('newOpenPosSales', 'true');
            sharedPreferences!.setString('newOpenPosToko', 'true');
            sharedPreferences!.setString('newOpenPosRetur', 'true');
            // sharedPreferences!.setString('newOpenHistory', 'true');
            sharedPreferences!.setString('total_product_sales', '0');
            await getToken();
            role == 15
                ? dialogBox()
                : Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const MainScreen()));
          } catch (c) {
            sharedPreferences!.setString('newOpen', 'true');
            sharedPreferences!.setString('newOpenHome', 'true');
            sharedPreferences!.setString('newOpenPosSales', 'true');
            sharedPreferences!.setString('newOpenPosToko', 'true');
            sharedPreferences!.setString('newOpenPosRetur', 'true');
            sharedPreferences!.setString('total_product_sales', '0');
            role == 15
                ? dialogBox()
                : Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const MainScreen()));
          }
        } catch (c) {
          Fluttertoast.showToast(msg: "Failed To Load Data");
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const AuthScreen()));
        }
      } else //user is NOT already Logged-in
      {
        Fluttertoast.showToast(msg: "Failed To Load Data");

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
    FirebaseMessaging.instance.subscribeToTopic("allUsers");
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
    // context.read<PCart>().clearCart();
    // context.read<PCartToko>().clearCart();
    // context.read<PCartRetur>().clearCart();
    var apiProvider = ApiServices();
    // await DbAllitems.db.deleteAllitems();
    // await DbAllitemsToko.db.deleteAllitemsToko();
    // await DbAlltransaksi.db.deleteAlltransaksi();
    // await DbAllCustomer.db.deleteAllcustomer();
    // await DbAllitemsRetur.db.deleteAllitemsRetur();
    // await DbAllKodekeluarbarang.db.deleteAllkeluarbarang();
    // await DbAlldetailtransaksi.db.deleteAlldetailtransaksi();
    // await DbCRM.db.deleteAllcrm();
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
    //   await apiProvider.getAllTransaksi();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all transaksi");
    // }
    // try {
    //   apiProvider.getAllItemsRetur();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all items retur");
    // }
    // try {
    //   await apiProvider.getAllDetailTransaksi();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all details transaksi");
    // }
    // try {
    //   await apiProvider.getAllKodekeluarbarang();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all code refrence");
    // }
    // try {
    //   await apiProvider.getAllCustomer();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all customer");
    // }
    try {
      await apiProvider.getUsers();
      setState(() {
        role = int.parse(sharedPreferences!.getString('role_sales_brand')!);
        print(role);
      });
    } catch (c) {
      sharedPreferences!.setString('name', 'Failed To Load Data');
      Fluttertoast.showToast(msg: "Failed To Load Data User");
    }
    // try {
    //   await apiProvider.getAllTCRM();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data CRM");
    // }

    // context.read<PNewNotif>().clearNotif();
    // DbNotifDummy.db.getAllNotif(1).then((value) {
    //   for (var i = 0; i < value.length; i++) {
    //     context.read<PNewNotif>().addItem(
    //           1,
    //         );
    //   }
    // });

    await loadCartFromApiPOSSALES();
    // wait for 2 seconds to simulate loading of data
    // await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset("images/splashLogo.png"),
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

  dialogBox() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose aplikasi'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const MainScreen()));
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.trending_up_sharp),
                        Text('Pos Mobile'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) =>
                                  const MainScreenApprovePricing()));
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.price_check_sharp),
                        Text('Approval Pricing'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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