// ignore_for_file: avoid_print, prefer_const_constructors, use_build_context_synchronously, unused_element, prefer_const_literals_to_create_immutables, override_on_non_overriding_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/POSToko/main_posToko_screen.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/api/api_services.dart';
import 'package:e_shop/cartScreens/cart_screen.dart';
import 'package:e_shop/database/db_allitems_toko.dart';
import 'package:e_shop/global/global.dart';
import 'package:badges/badges.dart' as badges;
import 'package:e_shop/history/history_invoice_screen.dart';
import 'package:e_shop/history/history_kembalibarang_screen.dart';
import 'package:e_shop/history/history_titipan_screen.dart';
import 'package:e_shop/history/main_history.dart';
import 'package:e_shop/history/main_history_screen.dart';
import 'package:e_shop/posRetur/main_posRetur_screen.dart';
import 'package:e_shop/posSales/main_posSales_screen.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:e_shop/provider/provider_cart_retur.dart';
import 'package:e_shop/provider/provider_cart_toko.dart';
import 'package:e_shop/qr/qr_scanner.dart';
import 'package:e_shop/report/main_report_screen.dart';
import 'package:e_shop/toko/main_addToko_screen.dart';
import 'package:e_shop/widgets/alert_dialog.dart';
import 'package:e_shop/widgets/fake_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../splashScreen/my_splas_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLoading = false;
  // late FirebaseMessaging messaging;
  QRViewController? controller;
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  @override
  void initState() {
    print('sales id : ${sharedPreferences!.getString('id')!}');
    super.initState();
    loadCartFromApiPOSSALES();
    controller?.stopCamera();
    // strat push notification
    // PushNotificationsSystem pushNotificationsSystem = PushNotificationsSystem();
    // pushNotificationsSystem.whenNotificationReceived(context);
    // pushNotificationsSystem.generateDeviceRecognitionToken();
    // end push notification

    // messaging = FirebaseMessaging.instance;
    // messaging.getToken().then((value) {
    //   print(value);
    // });
    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   print("message recieved");
    //   print(event.notification!.body);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('Message clicked!');
    // });
    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   print("message recieved");
    //   print(event.notification!.body);
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: Text("Notification"),
    //           content: Text(event.notification!.body!),
    //           actions: [
    //             TextButton(
    //               child: Text("Ok"),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             )
    //           ],
    //         );
    //       });
    // });
    // messaging.subscribeToTopic("messaging");
  }

  @override
  // Future<void> _messageHandler(RemoteMessage message) async {
  //   // print('background message ${message.notification!.body}');
  // }

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();
    // FirebaseMessaging.onBackgroundMessage(_messageHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _bodyatas(),
                  _bodytengah(),
                  SizedBox(height: 15),
                  _bodybawah(),
                  const Padding(
                    padding: EdgeInsets.only(
                        bottom: 7.0, top: 10.0, left: 40.0, right: 40.0),
                    child: Divider(
                      height: 1,
                      thickness: 5,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Text(
                    version,
                    style: TextStyle(
                        color: Colors.grey[800], fontStyle: FontStyle.italic),
                  )
                  // if (sharedPreferences!.getString("role")! != "SALES")
                  //   _widget3()
                ],
              )),
        ],
      ),
      // bottomNavigationBar: BottomAppBar(
      //     child: ElevatedButton(
      //   onPressed: () async {
      //     if (Platform.isAndroid) {
      //       SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
      //     }
      //     exit(0);

      //     // await _deleteAlldetailtransaksifirebase();
      //     // await _deleteAlltransaksifirebase();
      //     // await _deleteAllitemsfirebase();
      //     // await _deleteAllitemstokofirebase();
      //     // await _loadAllDataApi();
      //   },
      //   child: const Icon(
      //     Icons.home,
      //     color: Colors.white,
      //     size: 50,
      //   ),
      // )
      // ),
    );
  }

  Widget _bodyatas() {
    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Morning';
      }
      if (hour < 17) {
        return 'Afternoon';
      }
      return 'Evening';
    }

    return Container(
        width: MediaQuery.of(context).size.width * 1.0,
        height: 90,
        decoration: BoxDecoration(color: Colors.blue),
        // decoration: const BoxDecoration(
        //     image: DecorationImage(
        //   image: AssetImage("images/bgatas2.png"),
        //   fit: BoxFit.cover,
        // )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        backgroundColor: Colors.blue,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                          // side: BorderSide(color: Colors.white)
                        ),
                      ),
                      onPressed: () {
                        MyAlertDilaog.showMyDialog(
                            context: context,
                            title: 'Sign-Out',
                            content: 'Are you sure to sign-out ?',
                            tabNo: () {
                              Navigator.pop(context);
                            },
                            tabYes: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              // await DbAllitems.db.deleteAllitems();
                              // await DbAllitemsToko.db.deleteAllitemsToko();
                              // await DbAlltransaksi.db.deleteAlltransaksi();
                              // await DbAlldetailtransaksi.db
                              //     .deleteAlldetailtransaksi();
                              prefs.clear();
                              prefs.setString('token', 'null');
                              // FirebaseAuth.instance.signOut();
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => const MySplashScreen()));
                            });
                      },
                      child: Transform.scale(
                        scale: 1.8,
                        child: ClipOval(
                            child: Image.asset(
                          "images/user.png",
                        )
                            //     child: CachedNetworkImage(
                            //   imageUrl: sharedPreferences!.getString("photoUrl")!,
                            //   fit: BoxFit.cover,
                            // )
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 42.0, right: 40),
              child: Column(
                children: [
                  Text(
                    "Good ${greeting()}, \n${sharedPreferences!.getString("name")!}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 20),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const CartScreen()));
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: badges.Badge(
                        showBadge: context.read<PCart>().getItems.isEmpty
                            ? false
                            : true,
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: Colors.green,
                        ),
                        badgeContent: Text(
                          context.watch<PCart>().getItems.length.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _bodytengah() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.50,
      decoration: BoxDecoration(color: Colors.grey),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            // title: Text("History"),
            // title: FakeSearchHistory(),
            title: FakeSearch(),
            automaticallyImplyLeading: false,
            centerTitle: true,
            // bottom: const TabBar(
            //     indicatorColor: Colors.blue,
            //     indicatorWeight: 8,
            //     tabs: [
            //       RepeatedTab(label: 'ACTIVE'),
            //       RepeatedTab(label: 'MIDDLE'),
            //       RepeatedTab(label: 'INACTIVE'),
            //     ]),
            // ),
            // body: const TabBarView(children: [
            // ActiveScreen(),
            // MidScreen(),
            // InactiveScreen(),
            // ]),
            bottom: const TabBar(
                indicatorColor: Colors.blue,
                indicatorWeight: 8,
                tabs: [
                  RepeatedTab(label: 'Invoice'),
                  RepeatedTab(label: 'Kembali Barang'),
                  RepeatedTab(label: 'Titipan'),
                ]),
          ),
          body: const TabBarView(children: [
            HistoryInvoiceScreen(),
            HistoryKembalibarangScreen(),
            HistoryTitipanScreen(),
          ]),
        ),
      ),
    );
  }

  Widget _bodybawah() {
    return Container(
        height: 200,
        width: MediaQuery.of(context).size.width * 0.83,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              //bagian atas
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //HISTORY
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Transform.scale(
                        scale: 1.2,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => MainHistoryScreen()));
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueAccent),
                            shape: const CircleBorder(),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => MainHistoryScreen()));
                            },
                            icon: Image.asset(
                              "images/refresh.png",
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      const Text(
                        "HISTORY",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                      ),
                    ],
                  ),
                  //report
                  // if (sharedPreferences!.getString("role")! != "SALES")
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Transform.scale(
                        scale: 1.2,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => MainReportScreen()));
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueAccent),
                            shape: const CircleBorder(
                                // borderRadius: BorderRadius.circular(360),
                                ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => MainReportScreen()));
                            },
                            icon: Image.asset(
                              "images/seo-report.png",
                              // "images/offer.png",
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      const Text(
                        "REPORT",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                      ),
                    ],
                  ),

                  //ADD TOKO
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Transform.scale(
                        scale: 1.2,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => const MainAddTokoScreen()));
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueAccent),
                            shape: const CircleBorder(
                                // borderRadius: BorderRadius.circular(360),
                                ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) =>
                                          const MainAddTokoScreen()));
                            },
                            icon: Image.asset(
                              "images/franchise.png",
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      const Text(
                        "ADD TOKO",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                      ),
                    ],
                  ),

                  //setting
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Transform.scale(
                        scale: 1.2,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueAccent),
                            shape: const CircleBorder(
                                // borderRadius: BorderRadius.circular(360),
                                ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Fluttertoast.showToast(msg: "Not Available");
                            },
                            icon: Image.asset(
                              "images/settings.png",
                              // "images/offer.png",
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      const Text(
                        "SETTINGS",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                      ),
                    ],
                  ),

                  //     //dashboard report
                  //     Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         Transform.scale(
                  //           scale: 1.2,
                  //           child: OutlinedButton(
                  //             onPressed: () {},
                  //             style: OutlinedButton.styleFrom(
                  //               side: const BorderSide(color: Colors.blueAccent),
                  //               shape: const CircleBorder(
                  //                   // borderRadius: BorderRadius.circular(360),
                  //                   ),
                  //             ),
                  //             child: IconButton(
                  //               onPressed: () {
                  //                 Fluttertoast.showToast(msg: "Not Available");
                  //                 // Navigator.push(
                  //                 //     context,
                  //                 //     MaterialPageRoute(
                  //                 //         builder: (c) => ChartScreen()));
                  //               },
                  //               icon: Image.asset(
                  //                 "images/settings.png",
                  //                 // "images/offer.png",
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         const Padding(
                  //           padding: EdgeInsets.only(top: 10.0),
                  //         ),
                  //         const Text(
                  //           "DASHBOARD",
                  //           style:
                  //               TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                  //         ),
                  //       ],
                  //     ),
                ],
              ),

              //slot 2 widget
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //POS SALES
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Transform.scale(
                        scale: 1.2,
                        child: OutlinedButton(
                          onPressed: () async {
                            sharedPreferences!
                                .setString('total_product_sales', '0');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => MainPosSalesScreen()));
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueAccent),
                            shape: const CircleBorder(),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              sharedPreferences!
                                  .setString('total_product_sales', '0');

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => MainPosSalesScreen()));
                            },
                            icon: Image.asset(
                              "images/sales.png",
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      const Text(
                        "POS SALES",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                      ),
                    ],
                  ),

                  //pos retur
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Transform.scale(
                        scale: 1.2,
                        child: OutlinedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('customer_id', 0.toString());
                            context.read<PCartRetur>().clearCart();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) =>
                                        const MainPosReturScreen()));
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueAccent),
                            shape: const CircleBorder(),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('customer_id', 0.toString());
                              context.read<PCartRetur>().clearCart();
                              // _loadFromApiPOSTOKO();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) =>
                                          const MainPosReturScreen()));
                            },
                            icon: Image.asset(
                              "images/product-return.png",
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      const Text(
                        "POS RETUR",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                      ),
                    ],
                  ),

                  //POS TOKO
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Transform.scale(
                        scale: 1.2,
                        child: OutlinedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('customer_id', 0.toString());
                            prefs.setString('total_product', 0.toString());
                            context.read<PCartToko>().clearCart();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => const MainPosTokoScreen()));
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueAccent),
                            shape: const CircleBorder(),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('customer_id', 0.toString());
                              prefs.setString('total_product', 0.toString());

                              context.read<PCartToko>().clearCart();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) =>
                                          const MainPosTokoScreen()));
                            },
                            icon: Image.asset(
                              "images/store.png",
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      const Text(
                        "POS TOKO",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                      ),
                    ],
                  ),

                  //SCAN QR
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Transform.scale(
                        scale: 1.2,
                        child: OutlinedButton(
                          onPressed: () {
                            // scanQR();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => const QrScanner()));
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blueAccent),
                            shape: const CircleBorder(),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => const QrScanner()));
                            },
                            icon: Image.asset(
                              "images/qr-code.png",
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      const Text(
                        "QR",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 12.0),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ]));
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

      print(existingitemcart);
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

  _loadFromApiPOSTOKO() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = ApiServices();
    DbAllitemsToko.db.deleteAllitemsToko();
    await apiProvider.getAllItemsToko();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
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
}
