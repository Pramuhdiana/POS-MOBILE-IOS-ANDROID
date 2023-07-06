// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, avoid_print

import 'dart:math';
import 'package:intl/intl.dart';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/CRM/home_report.dart';
import 'package:e_shop/global/currency_format.dart';
import 'package:e_shop/testing/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/cartScreens/cart_screen.dart';
import 'package:e_shop/database/db_alltransaksi.dart';
import 'package:e_shop/eTICKETING/home_ticketing.dart';
import 'package:e_shop/global/global.dart';
import 'package:badges/badges.dart' as badges;
import 'package:e_shop/history/main_history.dart';
import 'package:e_shop/posRetur/pos_retur_screen.dart';
import 'package:e_shop/posSales/pos_sales_screen.dart';
import 'package:e_shop/posToko/pos_toko_screen.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:e_shop/provider/provider_cart_retur.dart';
import 'package:e_shop/provider/provider_cart_toko.dart';
import 'package:e_shop/push_notifications/push_notifications_system.dart';
import 'package:e_shop/qr/qr_scanner.dart';
import 'package:e_shop/toko/upload_toko_screen.dart';
import 'package:e_shop/widgets/alert_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../splashScreen/my_splas_screen.dart';
import '../testing/app_colors.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //start color chart
  List<Color> get availableColors => const <Color>[
        AppColors.contentColorPurple,
        AppColors.contentColorYellow,
        AppColors.contentColorBlue,
        AppColors.contentColorOrange,
        AppColors.contentColorPink,
        AppColors.contentColorRed,
      ];
  final Color barBackgroundColor =
      AppColors.contentColorWhite.darken().withOpacity(0.3);
  final Color barColor = AppColors.contentColorWhite;
  final Color touchedBarColor = AppColors.contentColorGreen;
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;
  bool isPlaying = false;
  double percentYear = 0.0;
  double percentMonth = 0.0;
  double percentWeek = 0.0;
  int barJan = 0;
  int barFeb = 0;
  int barMar = 0;
  int barApr = 0;
  int barMay = 0;
  int barJun = 0;
  int barJul = 0;
  int barAug = 0;
  int barSep = 0;
  int barOct = 0;
  int barNov = 0;
  int barDec = 0;
  int targetByMonth = 10000000;
  //end chart color

  String? year = '';
  var listNominal = [];
  int list = 0;

  var isLoading = false;
  late FirebaseMessaging messaging;
  QRViewController? controller;
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();
    year = DateFormat('y').format(DateTime.now());
    //jan
    DbAlltransaksi.db.getAlltransaksiNominalByMonth('1', year).then((value) {
      for (var i = 0; i < value.length; i++) {
        barJan += int.parse(value[i].total_rupiah!); //menjumlahkan ke list
      }
      setState(() {
        barJan = (barJan / targetByMonth).round();
      });
    });
    //feb
    DbAlltransaksi.db.getAlltransaksiNominalByMonth('2', year).then((value) {
      for (var i = 0; i < value.length; i++) {
        barFeb += int.parse(value[i].total_rupiah!); //menjumlahkan ke list
      }
      setState(() {
        barFeb = (barFeb / targetByMonth).round();
      });
    });
    //mar
    DbAlltransaksi.db.getAlltransaksiNominalByMonth('3', year).then((value) {
      for (var i = 0; i < value.length; i++) {
        barMar += int.parse(value[i].total_rupiah!); //menjumlahkan ke list
      }
      setState(() {
        barMar = (barMar / targetByMonth).round();
      });
    });
    //apr
    DbAlltransaksi.db.getAlltransaksiNominalByMonth('4', year).then((value) {
      for (var i = 0; i < value.length; i++) {
        barApr += int.parse(value[i].total_rupiah!); //menjumlahkan ke list
      }
      setState(() {
        barApr = (barApr / targetByMonth).round();
      });
    });
    //may
    DbAlltransaksi.db.getAlltransaksiNominalByMonth('5', year).then((value) {
      for (var i = 0; i < value.length; i++) {
        barMay += int.parse(value[i].total_rupiah!); //menjumlahkan ke list
      }
      setState(() {
        barMay = (barMay / targetByMonth).round();
      });
    });
    //jun
    DbAlltransaksi.db.getAlltransaksiNominalByMonth('6', year).then((value) {
      for (var i = 0; i < value.length; i++) {
        barJun += int.parse(value[i].total_rupiah!); //menjumlahkan ke list
      }
      setState(() {
        barJun = (barJun / targetByMonth).round();
      });
    });
    //jul
    DbAlltransaksi.db.getAlltransaksiNominalByMonth('7', year).then((value) {
      for (var i = 0; i < value.length; i++) {
        barJul += int.parse(value[i].total_rupiah!); //menjumlahkan ke list
      }
      setState(() {
        barJul = (barJul / targetByMonth).round();
      });
    });
    //agus
    DbAlltransaksi.db.getAlltransaksiNominalByMonth('8', year).then((value) {
      for (var i = 0; i < value.length; i++) {
        barAug += int.parse(value[i].total_rupiah!); //menjumlahkan ke list
      }
      setState(() {
        barAug = (barAug / targetByMonth).round();
      });
    });
    //sept
    DbAlltransaksi.db.getAlltransaksiNominalByMonth('9', year).then((value) {
      for (var i = 0; i < value.length; i++) {
        barSep += int.parse(value[i].total_rupiah!); //menjumlahkan ke list
      }
      setState(() {
        barSep = (barSep / targetByMonth).round();
      });
    });
    //okt
    DbAlltransaksi.db.getAlltransaksiNominalByMonth('10', year).then((value) {
      for (var i = 0; i < value.length; i++) {
        barOct += int.parse(value[i].total_rupiah!); //menjumlahkan ke list
      }
      setState(() {
        barOct = (barOct / targetByMonth).round();
      });
    });
    //nov
    DbAlltransaksi.db.getAlltransaksiNominalByMonth('11', year).then((value) {
      for (var i = 0; i < value.length; i++) {
        barNov += int.parse(value[i].total_rupiah!); //menjumlahkan ke list
      }
      setState(() {
        barNov = (barNov / targetByMonth).round();
      });
    });
    //desc
    DbAlltransaksi.db.getAlltransaksiNominalByMonth('12', year).then((value) {
      for (var i = 0; i < value.length; i++) {
        barDec += int.parse(value[i].total_rupiah!); //menjumlahkan ke list
      }
      setState(() {
        barDec = (barDec / targetByMonth).round();
      });
    });

    DbAlltransaksi.db.getAlltransaksiNominal(year).then((value) {
      for (var i = 0; i < value.length; i++) {
        list += int.parse(value[i].total_rupiah!); //menjumlahkan ke list
        listNominal.add(value[i].total_rupiah); //memasukan ke list
      }
      setState(() {
        // CurrencyFormat.convertToIdr(list, 2);
        // print(list / 10000000000 * 100);
        percentYear = (list / 1000000000000 * 100);
      });
    });
    // percentYear = 0.7;
    percentMonth = 0.3;
    percentWeek = 0.1;
    loadCartFromApiPOSSALES();
    controller?.stopCamera();
    //star notifi
    PushNotificationsSystem pushNotificationsSystem = PushNotificationsSystem();
    // pushNotificationsSystem.notificationPopUp(context);
    pushNotificationsSystem.whenNotificationReceived(context);
    //end notif
  }

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future refresh() async {
    setState(() {
      context.read<PCart>().clearCart(); //clear cart
      loadCartFromApiPOSSALES();
      DbAlltransaksi.db.getAlltransaksi(1);
      // Fluttertoast.showToast(msg: "Refresh done");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                color: Colors.white,
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: Column(
                    children: <Widget>[
                      _bodyatas(),
                      const SizedBox(height: 15),
                      _bodytengah(),
                      const SizedBox(height: 15),
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
                            color: Colors.grey[800],
                            fontStyle: FontStyle.italic),
                      )
                      // if (sharedPreferences!.getString("role")! != "SALES")
                      //   _widget3()
                    ],
                  ),
                )),
          ],
        ),
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

    return RefreshIndicator(
      onRefresh: refresh,
      child: Container(
          width: MediaQuery.of(context).size.width * 1.0,
          height: 90,
          decoration: const BoxDecoration(color: Colors.blue),
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
                                        builder: (c) =>
                                            const MySplashScreen()));
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
          )),
    );
  }

  Widget _bodytengah() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.50,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 100, bottom: 5),
              child: Text(
                'Sales progress this year',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
            LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 20,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 2500, //kecepatan animasi
              percent: percentYear,
              center: Text(
                '${(percentYear * 100).round()}%',
              ),
              // ignore: deprecated_member_use
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: const Color.fromARGB(255, 17, 221, 82),
            ),
            Text('${CurrencyFormat.convertToIdr(list, 2)} / 10.000.000.000,00'),
            // CircularPercentIndicator(
            //   radius: 120.0,
            //   lineWidth: 13.0,
            //   animation: true,
            //   percent: percentYear,
            //   center: Text(
            //     '${percentYear * 100}%',
            //     style: const TextStyle(
            //         fontWeight: FontWeight.bold, fontSize: 50.0),
            //   ),
            //   footer: const Text(
            //     "Sales this year",
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            //   ),
            //   circularStrokeCap: CircularStrokeCap.round,
            //   progressColor: Colors.green,
            // ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              // aspectRatio: 1.1,
              height: MediaQuery.of(context).size.height * 0.40,
              child: Card(
                color: Colors.white70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Monthly',
                            style: TextStyle(
                              color: AppColors.contentColorBlue,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: AppColors.contentColorBlue,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPlaying = !isPlaying;
                                  if (isPlaying) {
                                    refreshState();
                                  }
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      // height: 250,
                      height: MediaQuery.of(context).size.height * 0.31,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: BarChart(
                          isPlaying ? randomData() : mainBarData(),
                          swapAnimationDuration: animDuration,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodybawah() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Container(
          height: 200,
          width: 320,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.blue,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
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
                                      builder: (c) => const MainHistory()));
                              // builder: (c) => MainHistoryScreen()));
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
                                        builder: (c) => const MainHistory()));
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
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 12.0),
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
                                      builder: (c) => HomeReport()));
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
                                        builder: (c) => HomeReport()));
                                // builder: (c) => MainReportScreen()));
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
                          "CRM",
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 12.0),
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
                                      builder: (c) =>
                                          const UploadTokoScreen()));
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
                                            const UploadTokoScreen()));
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
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 12.0),
                        ),
                      ],
                    ),

                    //e-ticketing report
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
                                      builder: (c) => HomeEticketing()));
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
                                        builder: (c) => HomeEticketing()));
                              },
                              icon: Image.asset(
                                "images/ticket.png",
                                // "images/offer.png",
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        const Text(
                          "E-TICKETING",
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 12.0),
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
                                // DbCRM.db.deleteAllcrm();
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (c) => BarChartSample1()));
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
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 12.0),
                        ),
                      ],
                    ),
                  ],
                ),

                //slot 2 widget
                const SizedBox(
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => PosSalesScreen()));
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.blueAccent),
                              shape: const CircleBorder(),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => PosSalesScreen()));
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
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 12.0),
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
                                      builder: (c) => const PosReturScreen()));
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
                                            const PosReturScreen()));
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
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 12.0),
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
                                      builder: (c) => const PosTokoScreen()));
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
                                        builder: (c) => const PosTokoScreen()));
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
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 12.0),
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
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 12.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ])),
    );
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

//start chart
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  //end chart
  BarChartGroupData makeGroupData(
    int x,
    int y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= AppColors.contentColorGreen;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? (y).toDouble() : y.toDouble(),
          // toY: isTouched ? y + 1 : y,
          color: isTouched ? AppColors.contentColorBlue : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: AppColors.contentColorGreen.darken(80))
              : const BorderSide(color: Colors.blue, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100, //ruang or target bar
            color: AppColors.contentColorWhite.darken().withOpacity(0.9),
            // color: Colors.black,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  //show grop smt 1
  List<BarChartGroupData> showingGroupsSmt1() => List.generate(12, (i) {
        //DATA BAR
        switch (i) {
          //januari
          case 0:
            return makeGroupData(0, barJan, isTouched: i == touchedIndex);
          //februari
          case 1:
            return makeGroupData(1, barFeb, isTouched: i == touchedIndex);
          //maret
          case 2:
            return makeGroupData(2, barMar, isTouched: i == touchedIndex);
          //april
          case 3:
            return makeGroupData(3, barApr, isTouched: i == touchedIndex);
          //mei
          case 4:
            return makeGroupData(4, barMay, isTouched: i == touchedIndex);
          //juni
          case 5:
            return makeGroupData(5, barJun, isTouched: i == touchedIndex);
          //juli
          case 6:
            return makeGroupData(6, barJul, isTouched: i == touchedIndex);
          //agustus
          case 7:
            return makeGroupData(7, barAug, isTouched: i == touchedIndex);
          //septeember
          case 8:
            return makeGroupData(8, barSep, isTouched: i == touchedIndex);
          //oktober
          case 9:
            return makeGroupData(9, barOct, isTouched: i == touchedIndex);
          //november
          case 10:
            return makeGroupData(10, barNov, isTouched: i == touchedIndex);
          //desember
          case 11:
            return makeGroupData(11, barDec, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  //main bar data (awal)
  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String semester1;
            switch (group.x) {
              case 0:
                semester1 = 'Januari';
                break;
              case 1:
                semester1 = 'February';
                break;
              case 2:
                semester1 = 'March';
                break;
              case 3:
                semester1 = 'April';
                break;
              case 4:
                semester1 = 'May';
                break;
              case 5:
                semester1 = 'June';
                break;
              case 6:
                semester1 = 'July';
                break;
              case 7:
                semester1 = 'August';
                break;
              case 8:
                semester1 = 'September';
                break;
              case 9:
                semester1 = 'October';
                break;
              case 10:
                semester1 = 'November';
                break;
              case 11:
                semester1 = 'December';
                break;
              default:
                throw Error();
            }
            //tampilam UI bar
            return BarTooltipItem(
              '$semester1\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                (rod.toY).round().toString().length > 2
                    ? TextSpan(
                        text:
                            '${(rod.toY).round()}%\n${(rod.toY * 10).toString()[0]},${(rod.toY * 10).toString()[1]}M',
                        style: const TextStyle(
                          color: AppColors.contentColorGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : TextSpan(
                        text:
                            '${(rod.toY).round().toString()}%\n${(rod.toY * 10).toString()[0]}${(rod.toY * 10).toString()[1]}${(rod.toY * 10).toString()[2]}JT',
                        style: const TextStyle(
                          color: AppColors.contentColorGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitlesSmt1,
            reservedSize: 80,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroupsSmt1(),
      gridData: const FlGridData(show: false),
    );
  }

  //title semester 1
  Widget getTitlesSmt1(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('J\nA\nN', style: style);
        break;
      case 1:
        text = const Text('F\nE\nB', style: style);
        break;
      case 2:
        text = const Text('M\nA\nR', style: style);
        break;
      case 3:
        text = const Text('A\nP\nR', style: style);
        break;
      case 4:
        text = const Text('M\nA\nY', style: style);
        break;
      case 5:
        text = const Text('J\nU\nN', style: style);
        break;
      case 6:
        text = const Text('J\nU\nL', style: style);
        break;
      case 7:
        text = const Text('A\nU\nG', style: style);
        break;
      case 8:
        text = const Text('S\nE\nP', style: style);
        break;
      case 9:
        text = const Text('O\nC\nT', style: style);
        break;
      case 10:
        text = const Text('N\nO\nV', style: style);
        break;
      case 11:
        text = const Text('D\nE\nC', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitlesSmt1,
            reservedSize: 80,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(12, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
              0,
              Random().nextInt(7500).toInt() + 1000,
              barColor:
                  availableColors[Random().nextInt(availableColors.length)],
            );
          case 1:
            return makeGroupData(
              1,
              Random().nextInt(7500).toInt() + 1000,
              barColor:
                  availableColors[Random().nextInt(availableColors.length)],
            );
          case 2:
            return makeGroupData(
              2,
              Random().nextInt(7500).toInt() + 1000,
              barColor:
                  availableColors[Random().nextInt(availableColors.length)],
            );
          case 3:
            return makeGroupData(
              3,
              Random().nextInt(7500).toInt() + 1000,
              barColor:
                  availableColors[Random().nextInt(availableColors.length)],
            );
          case 4:
            return makeGroupData(
              4,
              Random().nextInt(7500).toInt() + 1000,
              barColor:
                  availableColors[Random().nextInt(availableColors.length)],
            );
          case 5:
            return makeGroupData(
              5,
              Random().nextInt(7500).toInt() + 1000,
              barColor:
                  availableColors[Random().nextInt(availableColors.length)],
            );
          case 6:
            return makeGroupData(
              6,
              Random().nextInt(7500).toInt() + 1000,
              barColor:
                  availableColors[Random().nextInt(availableColors.length)],
            );
          case 7:
            return makeGroupData(
              7,
              Random().nextInt(7500).toInt() + 1000,
              barColor:
                  availableColors[Random().nextInt(availableColors.length)],
            );
          case 8:
            return makeGroupData(
              8,
              Random().nextInt(7500).toInt() + 1000,
              barColor:
                  availableColors[Random().nextInt(availableColors.length)],
            );
          case 9:
            return makeGroupData(
              9,
              Random().nextInt(7500).toInt() + 1000,
              barColor:
                  availableColors[Random().nextInt(availableColors.length)],
            );
          case 10:
            return makeGroupData(
              10,
              Random().nextInt(7500).toInt() + 1000,
              barColor:
                  availableColors[Random().nextInt(availableColors.length)],
            );
          case 11:
            return makeGroupData(
              11,
              Random().nextInt(7500).toInt() + 1000,
              barColor:
                  availableColors[Random().nextInt(availableColors.length)],
            );
          default:
            return throw Error();
        }
      }),
      gridData: const FlGridData(show: false),
    );
  }
}
