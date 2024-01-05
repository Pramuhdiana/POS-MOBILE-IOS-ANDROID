// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/authScreens/auth_screen.dart';
import 'package:e_shop/buStephanie/main_screen_approve_pricing.dart';
import 'package:e_shop/database/db_allcustomer.dart';
import 'package:e_shop/database/db_alldetailtransaksi.dart';
import 'package:e_shop/database/db_allitems.dart';
import 'package:e_shop/database/db_allitems_retur.dart';
import 'package:e_shop/database/db_allitems_toko.dart';
import 'package:e_shop/database/db_alltransaksi_baru.dart';
import 'package:e_shop/database/db_crm.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/mainScreens/main_screen.dart';
import 'package:e_shop/models/version_model.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../api/api_services.dart';
import '../provider/provider_waiting_brj.dart';
import '../provider/provider_waiting_eticketing.dart';
import '../push_notifications/push_notifications_system.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  int noBuild = 25;
  String? mtoken = " ";
  String token = sharedPreferences!.getString("token").toString();
  int role = 0;
  String? version = '';

  var isLoading = true;
  splashScreenTimer() {
    Timer(const Duration(seconds: 0), () async {
      //user sudah login
      print('token $token');
      if (sharedPreferences!.getString("token").toString() != "null") {
        await requestPermission();

        try {
          await _loadFromApi();
          try {
            sharedPreferences?.setBool('isDinamis', false);

            sharedPreferences!.setString('newOpen', 'true');
            sharedPreferences!.setString('newOpenHome', 'true');
            sharedPreferences!.setString('newOpenPosSales', 'true');
            sharedPreferences!.setString('newOpenPosToko', 'true');
            sharedPreferences!.setString('newOpenPosRetur', 'true');
            sharedPreferences?.setBool('loading', true);
            // sharedPreferences!.setString('newOpenHistory', 'true');
            sharedPreferences!.setString('total_product_sales', '0');
            print('wait token');
            getToken();
            if (version != noBuild.toString()) {
              dialogBoxVersion();
            } else {
              role == 15
                  ? dialogBox()
                  : Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const MainScreen()));
            }
          } catch (c) {
            sharedPreferences!.setString('newOpen', 'true');
            sharedPreferences?.setBool('loading', true);
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
          Fluttertoast.showToast(msg: "Failed To Load user data");
          sharedPreferences?.setBool('dbDummy', false);
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const AuthScreen()));
        }
      } else //user is NOT already Logged-in
      {
        Fluttertoast.showToast(msg: "Failed To Load All Data");
        sharedPreferences?.setBool('dbDummy', false);
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
    print('token save');
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
    // setState(() {
    //   isLoading = true;
    // });
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
    await DbAllitems.db.deleteAllitems();
    await DbAllitemsToko.db.deleteAllitemsToko();
    await DbAlltransaksiBaru.db.deleteAlltransaksiBaru();
    await DbAllCustomer.db.deleteAllcustomer();
    await DbAllitemsRetur.db.deleteAllitemsRetur();
    await DbAllKodekeluarbarang.db.deleteAllkeluarbarang();
    await DbAlldetailtransaksi.db.deleteAlldetailtransaksi();
    await DbCRM.db.deleteAllcrm();

    try {
      apiProvider.getAllItems();
    } catch (c) {
      print('Error all transaksi : $c');
      throw Exception('error : $c');
    }
    // try {
    //   apiProvider.getAllItemsToko();
    // } catch (c) {
    //   throw Exception('Unexpected error occured!');
    // }
    // try {
    //   apiProvider.getAllItemsRetur();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all items");
    // }
    try {
      print('in function all transaksi');
      await apiProvider.getAllTransaksiBaru();
    } catch (c) {
      print('Error all transaksi : $c');
      throw Exception('error : $c');
    }
    try {
      print('in function detail transaksi');
      await apiProvider.getAllDetailTransaksi();
    } catch (c) {
      print('Error detail transaksi : $c');
      throw Exception('error : $c');
    }
    try {
      await apiProvider.getAllKodekeluarbarang();
    } catch (c) {
      print('Error all kode keluar barang : $c');
      throw Exception('error : $c');
    }
    // try {
    //   await apiProvider.getAllCustomer();
    // } catch (c) {
    //   print('Error gett all customer : $c');
    //   throw Exception('error : $c');
    // }
    try {
      await apiProvider.getAllCustomer();
    } catch (c) {
      print('Error gett all customer : $c');
      throw Exception('error : $c');
    }
    try {
      await apiProvider.getAllTCRM();
    } catch (c) {
      print('Error all crm : $c');
      throw Exception('error : $c');
    }

    try {
      print('in function get user');
      await apiProvider.getUsers();
      setState(() {
        role = int.parse(sharedPreferences!.getString('role_sales_brand')!);
        print('Role user : $role');
      });
    } catch (c) {
      print('Error ambil user : $c');
      sharedPreferences!.setString('name', 'Failed To Load Data');
      Fluttertoast.showToast(msg: "Failed To Load Data User");
    }
    await loadCartFromApiPOSSALES();
    setState(() {
      isLoading = false;
    });
  }

  loadCartFromApiPOSSALES() async {
    String? tokens = sharedPreferences!.getString('token');
    var url = ApiConstants.baseUrl + ApiConstants.GETkeranjangsalesendpoint;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $tokens"}));
    print('cart sales ke');
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

  @override
  void
      initState() //called automatically when user comes here to this splash screen
  {
    super.initState();
    PushNotificationsSystem pushNotificationsSystem = PushNotificationsSystem();
    pushNotificationsSystem.whenNotificationReceivedInPricing(context);
    context.read<PApprovalBrj>().clearNotif(); //clear cart
    context.read<PApprovalEticketing>().clearNotif(); //clear cart
    print('No Version : $noBuild');
    print('url : ${ApiConstants.baseUrl}');
    print('bool : ${sharedPreferences?.getBool('dbDummy')}');

    try {
      getVersion();
    } catch (c) {
      print('No Version DB : $noBuild');
      setState(() {
        version = noBuild.toString();
        sharedPreferences!.setString('version', noBuild.toString());
        // notif.sendNotificationTo(fcmTokensandy, 'Error Version',
        //     'version database dan mobile tidak');
        print('No Version DB : $noBuild');
      });
      throw Fluttertoast.showToast(msg: "Database Off");
    }
    try {
      loadListBRJ(); //ambil data cart
    } catch (c) {
      throw Fluttertoast.showToast(msg: "Database Off");
    }
    try {
      loadListEticketing(); //ambil data cart
    } catch (c) {
      throw Fluttertoast.showToast(msg: "Database Off");
    }

    splashScreenTimer();
  }

  Future<List<VersionModel>> getVersion() async {
    final response = await http.get(
        Uri.parse('http://110.5.102.154:1212/Api_flutter/spk/get_version.php'));
    print('No Version DB : ${response.body}');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var allData =
          jsonResponse.map((data) => VersionModel.fromJson(data)).toList();
      setState(() {
        version = allData.first.version;
        sharedPreferences!.setString('version', version!);
      });
      return allData;
    } else {
      setState(() {
        version = noBuild.toString();
        sharedPreferences!.setString('version', noBuild.toString());
        notif.sendNotificationTo(fcmTokensandy, 'Error Version',
            'version database dan mobile tidak');
        print('No Version DB : $noBuild');
      });
      throw Fluttertoast.showToast(msg: "Database Off");
    }
  }

  loadListBRJ() async {
    var url =
        ApiConstants.baseUrlPricing + ApiConstants.GETapprovelPricingWaiting;
    Response response = await Dio().get(
      url,
    );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Fluttertoast.showToast(msg: "Database Off");
    } else {
      return (response.data as List).map((cart) {
        context.read<PApprovalBrj>().addItem(
              1,
            );
      }).toList();
    }
  }

  loadListEticketing() async {
    var url =
        '${ApiConstants.baseUrlsandy}${ApiConstants.GETapprovelPricingEticketing}?status_approval=1';
    Response response = await Dio().get(
      url,
    );
    return (response.data as List).map((cart) {
      context.read<PApprovalEticketing>().addItem(
            1,
          );
    }).toList();
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
          child: isLoading == true
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(12.0),
                      //   child: Image.asset("images/splashLogo.png"),
                      // ),
                      Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Lottie.asset(
                            'json/logo567kb.json',
                            // width: 250,
                            // height: 250,
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
                )
              : const Center(child: SizedBox())),
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
            title: const Text('Please choose application'),
            content: SizedBox(
              height: 100,
              // height: MediaQuery.of(context).size.height * 0.5,
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

  dialogBoxVersion() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please update application'),
            content: SizedBox(
              height: 100,
              // height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      _launchURLInApp();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.flight),
                        Text('Test Flight'),
                      ],
                    ),
                  ),
                  sharedPreferences!
                              .getString('email')
                              .toString()
                              .toLowerCase() ==
                          'andy@sanivokasi.com'
                      ? ElevatedButton(
                          //if user click this button, user can upload image from gallery
                          onPressed: () {
                            Navigator.pop(context);
                            dialogBox();
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.developer_mode),
                              Text('Fitur Admin'),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          );
        });
  }

  _launchURLInApp() async {
    var url = 'https://beta.itunes.apple.com';

    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
