// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, avoid_print, unused_import

import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:e_shop/api/api_services.dart';
import 'package:e_shop/database/db_allcustomer.dart';
import 'package:e_shop/database/db_alltransaksi.dart';
import 'package:e_shop/database/db_alltransaksi_baru.dart';
import 'package:e_shop/database/db_crm.dart';
import 'package:e_shop/database/db_notification_dummy.dart';
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/database/model_alltransaksi_baru.dart';
import 'package:e_shop/event/pos_event_screen.dart';
import 'package:e_shop/models/customer_metier.dart';
import 'package:e_shop/provider/provider_notification.dart';
import 'package:e_shop/search/new_search.dart';
import 'package:e_shop/setDiskon/set_diskon.dart';
import 'package:e_shop/toko/add_customer_metier.dart';
import 'package:e_shop/widgets/app_colors.dart';
import 'package:e_shop/widgets/color_extensions.dart';
import 'package:e_shop/widgets/shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/CRM/crm_screen.dart';
import 'package:e_shop/global/currency_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/eTICKETING/ticketing_screen.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/history/main_history.dart';
import 'package:e_shop/posRetur/pos_retur_screen.dart';
import 'package:e_shop/posSales/pos_sales_screen.dart';
import 'package:e_shop/posToko/pos_toko_screen.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:e_shop/provider/provider_cart_retur.dart';
import 'package:e_shop/provider/provider_cart_toko.dart';
import 'package:e_shop/push_notifications/push_notifications_system.dart';
import 'package:e_shop/qr/qr_scanner.dart';
import 'package:e_shop/widgets/alert_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_alldetailtransaksi.dart';
import '../database/db_allitems.dart';
import '../database/db_allitems_retur.dart';
import '../database/db_allitems_toko.dart';
import '../database/model_allitems_toko.dart';
import '../splashScreen/my_splas_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// static const colorizeColors = [
//   Colors.black,
//   Colors.blue,
//   Colors.orange,
//   Colors.red,
// ];

// static const colorizeTextStyle = TextStyle(
//   fontSize: 20.0,
//   fontWeight: FontWeight.bold,
// );

  Color? bgColors;

  List<Color> get availableColors => const <Color>[
        AppColors.contentColorPurple,
        AppColors.contentColorYellow,
        AppColors.contentColorBlue,
        AppColors.contentColorOrange,
        AppColors.contentColorPink,
        AppColors.contentColorRed,
        AppColors.contentColorBlack,
        AppColors.contentColorGreen,
        AppColors.contentColorCyan,
      ];
  final Color barBackgroundColor =
      AppColors.contentColorWhite.darken().withOpacity(0.3);
  final Color barColor = AppColors.contentColorWhite;
  final Color touchedBarColor = AppColors.contentColorGreen;
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;
  bool isPlaying = false;
  bool isButton = true;
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
  int targetByYear = 10000000000;
  //end chart color

  String? year = '';
  var listNominal = [];
  int list = 0;

  bool? isLoading;
  late FirebaseMessaging messaging;
  QRViewController? controller;
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  int? qtyProductSales = 0;
  int? qtyProductToko = 0;
  int? qtyProductRetur = 0;
  int? qtyProductHistory = 0;
  int? qtyProductCustomer = 0;
  int? qtyProductCRM = 0;
  int? qtyProductTicketing = 0;
  String token = sharedPreferences!.getString("token").toString();
  String newOpen = '';
  String rolePos = '0';

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (newOpen == 'true') {
  //     print('harus 1x');
  //     _getDataToko(token);
  //     _getDataRetur(token);
  //     _getDataSales(token);
  //   } else {
  //     print('stop');
  //   }
  // }

  @override
  void initState() {
    rolePos = sharedPreferences!.getString("role_pos").toString();

    print('role pos : $rolePos');
    super.initState();
    context.read<PCart>().clearCart(); //clear cart
    loadCartFromApiPOSSALES(); //ambil data cart
    isLoading = true;
    newOpen = sharedPreferences!.getString("newOpenHome").toString();
    controller?.stopCamera();
    if (newOpen == 'true') {
      print('masuk awal');
      _loadFromApi();
    } else {
      print('masuk second');
      _getDataToko(token);
      // _getDataRetur(token);
      _getDataSales(token);
      // DbAllitems.db.getAllitems().then((value) {
      //   setState(() {
      //     qtyProductSales = value.length;
      //   });
      // });
      // DbAllitemsToko.db.getAllToko().then((value) {
      //   setState(() {
      //     qtyProductToko = value.length;
      //   });
      // });
      // DbAllitemsRetur.db.getAllRetur().then((value) {
      //   setState(() {
      //     qtyProductRetur = value.length;
      //   });
      // });

      DbAlltransaksi.db.getAllHistoryBaru().then((value) {
        setState(() {
          qtyProductHistory = value.length;
        });
      });
      //initial customer name
      sharedPreferences!.getString('role_sales_brand')! == '3'
          ? getCustomerMetier().then((value) {
              setState(() {
                qtyProductCustomer = value.length;
              });
            })
          : DbAllCustomer.db.getAllcustomer().then((value) {
              setState(() {
                qtyProductCustomer = value.length;
              });
            });
      //initial customer
      DbCRM.db
          .getAllcrmBySales(sharedPreferences!.getString('id'))
          .then((value) {
        setState(() {
          qtyProductCRM = value.length;
        });
      });

      year = DateFormat('y').format(DateTime.now());
      //jan
      DbAlltransaksi.db
          .getAlltransaksiNominalByMonthBaru('1', year)
          .then((value) {
        for (var i = 0; i < value.length; i++) {
          barJan += value[i].nett!; //menjumlahkan ke list
        }

        setState(() {
          barJan = (barJan / targetByMonth).round();
        });
        print('ini januari : $barJan');
      });
      //feb
      DbAlltransaksi.db
          .getAlltransaksiNominalByMonthBaru('2', year)
          .then((value) {
        for (var i = 0; i < value.length; i++) {
          barFeb += value[i].nett!; //menjumlahkan ke list
        }
        print(barFeb);

        setState(() {
          barFeb = (barFeb / targetByMonth).round();
        });
      });
      //mar
      DbAlltransaksi.db
          .getAlltransaksiNominalByMonthBaru('3', year)
          .then((value) {
        for (var i = 0; i < value.length; i++) {
          barMar += value[i].nett!; //menjumlahkan ke list
        }
        setState(() {
          barMar = (barMar / targetByMonth).round();
        });
      });
      //apr
      DbAlltransaksi.db
          .getAlltransaksiNominalByMonthBaru('4', year)
          .then((value) {
        for (var i = 0; i < value.length; i++) {
          barApr += value[i].nett!; //menjumlahkan ke list
        }
        setState(() {
          barApr = (barApr / targetByMonth).round();
        });
      });
      //may
      DbAlltransaksi.db
          .getAlltransaksiNominalByMonthBaru('5', year)
          .then((value) {
        for (var i = 0; i < value.length; i++) {
          barMay += value[i].nett!; //menjumlahkan ke list
        }
        setState(() {
          barMay = (barMay / targetByMonth).round();
        });
      });
      //jun
      DbAlltransaksi.db
          .getAlltransaksiNominalByMonthBaru('6', year)
          .then((value) {
        for (var i = 0; i < value.length; i++) {
          barJun += value[i].nett!; //menjumlahkan ke list
        }
        setState(() {
          barJun = (barJun / targetByMonth).round();
        });
      });
      //jul
      DbAlltransaksi.db
          .getAlltransaksiNominalByMonthBaru('7', year)
          .then((value) {
        for (var i = 0; i < value.length; i++) {
          barJul += value[i].nett!; //menjumlahkan ke list
        }
        setState(() {
          barJul = (barJul / targetByMonth).round();
        });
      });
      //agus
      DbAlltransaksi.db
          .getAlltransaksiNominalByMonthBaru('8', year)
          .then((value) {
        for (var i = 0; i < value.length; i++) {
          barAug += value[i].nett!; //menjumlahkan ke list
        }
        setState(() {
          barAug = (barAug / targetByMonth).round();
        });
      });
      //sept
      DbAlltransaksi.db
          .getAlltransaksiNominalByMonthBaru('9', year)
          .then((value) {
        for (var i = 0; i < value.length; i++) {
          barSep += value[i].nett!; //menjumlahkan ke list
        }
        setState(() {
          barSep = (barSep / targetByMonth).round();
        });
      });
      //okt
      DbAlltransaksi.db
          .getAlltransaksiNominalByMonthBaru('10', year)
          .then((value) {
        for (var i = 0; i < value.length; i++) {
          barOct += value[i].nett!; //menjumlahkan ke list
        }
        setState(() {
          barOct = (barOct / targetByMonth).round();
        });
      });
      //nov
      DbAlltransaksi.db
          .getAlltransaksiNominalByMonthBaru('11', year)
          .then((value) {
        for (var i = 0; i < value.length; i++) {
          barNov += value[i].nett!; //menjumlahkan ke list
        }
        setState(() {
          barNov = (barNov / targetByMonth).round();
        });
      });
      //desc
      DbAlltransaksi.db
          .getAlltransaksiNominalByMonthBaru('12', year)
          .then((value) {
        for (var i = 0; i < value.length; i++) {
          barDec += value[i].nett!; //menjumlahkan ke list
        }
        setState(() {
          barDec = (barDec / targetByMonth).round();
        });
      });

      DbAlltransaksi.db.getAlltransaksiNominalBaru(year).then((value) {
        for (var i = 0; i < value.length; i++) {
          list += value[i].nett!; //menjumlahkan ke list
          listNominal.add(value[i].nett); //memasukan ke list
        }
        percentYear = (list / targetByYear);
        setState(() {
          (percentYear > 1.0)
              ? percentYear = 1.0
              : percentYear = list / targetByYear;
        });
      });
      // percentYear = 0.7;
      percentMonth = 0.3;
      percentWeek = 0.1;
      //star notifi
      PushNotificationsSystem pushNotificationsSystem =
          PushNotificationsSystem();
      pushNotificationsSystem.whenNotificationReceived(context);
      // pushNotificationsSystem.notificationPopUp(context);
      //end notif
    }
  }

  //get data toko
  Future<List<ModelAllitemsToko>> _getDataToko(token) async {
    var url = ApiConstants.baseUrl + ApiConstants.GETposTokoendpoint;
    final response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    if (response.statusCode == 200) {
      List jsonResponse = response.data;
      var g =
          jsonResponse.map((data) => ModelAllitemsToko.fromJson(data)).toList();
      if (sharedPreferences!.getString('role_sales_brand')! == '3') {
        setState(() {
          var filterByMetier = g.where((element) =>
              element.sales_id.toString() ==
              sharedPreferences!.getString('id'));
          g = filterByMetier.toList();
          qtyProductToko = g.length;
          // sharedPreferences!.setInt('qtyProductToko', g.length);
        });
      } else {
        setState(() {
          // sharedPreferences!.setInt('qtyProductToko', g.length);
          qtyProductToko = g.length;
        });
      }

      return g;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  //get data retur
  // Future<List<ModelAllitemsRetur>> _getDataRetur(token) async {
  //   try {
  //     var url = ApiConstants.baseUrl + ApiConstants.GETposReturendpoint;
  //     final response = await Dio().get(url,
  //         options: Options(headers: {"Authorization": "Bearer $token"}));
  //     if (response.statusCode == 200) {
  //       List jsonResponse = response.data;

  //       var g = jsonResponse
  //           .map((data) => ModelAllitemsRetur.fromJson(data))
  //           .toList();
  //       setState(() {
  //         // sharedPreferences!.setInt('qtyProductRetur', g.length);
  //         qtyProductRetur = g.length;
  //       });
  //       return g;
  //     } else {
  //       throw Exception('Unexpected error occured!');
  //     }
  //   } catch (c) {
  //     throw Exception('Unexpected error occured!');
  //   }
  // }

  //get data sales
  Future<List<ModelAllitems>> _getDataSales(token) async {
    try {
      var url = ApiConstants.baseUrl + ApiConstants.GETposSalesendpoint;
      final response = await Dio().get(url,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        List jsonResponse = response.data;

        var g =
            jsonResponse.map((data) => ModelAllitems.fromJson(data)).toList();
        setState(() {
          // sharedPreferences!.setInt('qtyProductSales', g.length);
          qtyProductSales = g.length;
          print(qtyProductSales);
        });
        return g;
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (c) {
      throw Exception('Unexpected error occured!');
    }
  }

  //get data history
  // ignore: unused_element
  Future<List<ModelAlltransaksiBaru>> _getDataHistoryBaru(token) async {
    try {
      var url = ApiConstants.baseUrl + ApiConstants.GETtransaksiendpoint;
      final response = await Dio().get(url,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        List jsonResponse = response.data;

        var g = jsonResponse
            .map((data) => ModelAlltransaksiBaru.fromJson(data))
            .toList();
        setState(() {
          // sharedPreferences!.setInt('qtyProductHistory', g.length);
          qtyProductHistory = g.length;
        });
        return g;
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (c) {
      throw Exception('Unexpected error occured!');
    }
  }
  // Future<List<ModelAlltransaksi>> _getDataHistory(token) async {
  //   try {
  //     var url = ApiConstants.baseUrl + ApiConstants.GETtransaksiendpoint;
  //     final response = await Dio().get(url,
  //         options: Options(headers: {"Authorization": "Bearer $token"}));
  //     if (response.statusCode == 200) {
  //       List jsonResponse = response.data;

  //       var g = jsonResponse
  //           .map((data) => ModelAlltransaksi.fromJson(data))
  //           .toList();
  //       setState(() {
  //         // sharedPreferences!.setInt('qtyProductHistory', g.length);
  //         qtyProductHistory = g.length;
  //         print(qtyProductHistory);
  //       });
  //       return g;
  //     } else {
  //       throw Exception('Unexpected error occured!');
  //     }
  //   } catch (c) {
  //     Fluttertoast.showToast(msg: "Failed To Load Data all items retur");
  //     throw Exception('Unexpected error occured!');
  //   }
  // }

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future refresh() async {
    context.read<PCart>().clearCart(); //clear cart
    await loadCartFromApiPOSSALES(); //ambil data cart
    context.read<PNewNotif>().clearNotif(); //clear notif
    DbNotifDummy.db.getAllNotif(1).then((value) {
      for (var i = 0; i < value.length; i++) {
        context.read<PNewNotif>().addItem(
              1,
            );
      }
    }); //ambil data notif
    sharedPreferences!.setString('newOpen', 'true');
    sharedPreferences!.setString('newOpenPosSales', 'true');
    sharedPreferences!.setString('newOpenPosToko', 'true');
    sharedPreferences!.setString('newOpenPosRetur', 'true');
    await DbAlltransaksi.db.deleteAlltransaksiBaru();
    await DbAlldetailtransaksi.db.deleteAlldetailtransaksi();
    var apiProvider = ApiServices();
    try {
      await apiProvider.getAllTransaksiBaru();
    } catch (c) {
      Fluttertoast.showToast(msg: "Failed To Load Data all transaksi");
    }
    try {
      await apiProvider.getAllDetailTransaksi();
    } catch (c) {
      Fluttertoast.showToast(msg: "Failed To Load Data all details transaksi");
    }
    await DbAlltransaksi.db.getAllHistoryBaru().then((value) {
      setState(() {
        qtyProductHistory = value.length;
      });
    });
    await DbCRM.db
        .getAllcrmBySales(sharedPreferences!.getString('id'))
        .then((value) {
      setState(() {
        qtyProductCRM = value.length;
      });
    });
    //? refresh pos sales
    await DbAllitems.db.deleteAllitems();
    try {
      _getDataSales(token);
    } catch (c) {
      Fluttertoast.showToast(msg: "Failed To Load Data all items");
    }

    //? refresh pos toko
    await DbAllitemsToko.db.deleteAllitemsToko();
    try {
      _getDataToko(token);
    } catch (c) {
      Fluttertoast.showToast(msg: "Failed To Load Data all items toko");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading == false
          ? shimmerEffect()
          : RefreshIndicator(
              onRefresh: refresh,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: ListView(
                  children: [
                    Container(
                        color: Colors.white,
                        child: RefreshIndicator(
                          onRefresh: refresh,
                          child: Column(
                            children: <Widget>[
                              _bodyatas(),
                              _bodytengah(),
                              const Padding(
                                padding: EdgeInsets.only(
                                    bottom: 7.0,
                                    top: 10.0,
                                    left: 40.0,
                                    right: 40.0),
                                child: Divider(
                                  height: 1,
                                  thickness: 5,
                                  color: Colors.black,
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
            ),
    );
  }

  Widget shimmerEffect() {
    return Shimmer.fromColors(
        baseColor: Colors.black,
        period: const Duration(seconds: 2),
        highlightColor: Colors.grey[300]!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //atas
            const Padding(
                padding: EdgeInsets.only(top: 83, left: 7, right: 7),
                child: ListTile(
                  leading: ShimmerWidget.circular(height: 45, width: 45),
                  trailing: ShimmerWidget.circular(height: 45, width: 45),
                )),
            //atas 2
            Padding(
                padding: const EdgeInsets.only(top: 23, left: 7, right: 7),
                child: ListTile(
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: ShimmerWidget.rectangular(
                      height: 25,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ),
                  subtitle: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: ShimmerWidget.rectangular(
                        height: 20,
                        width: MediaQuery.of(context).size.width * 0.25,
                      ),
                    ),
                  ),
                )),
            //atas 3
            Padding(
                padding: const EdgeInsets.only(top: 18, left: 7, right: 17),
                child: ListTile(
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.9,
                      // color: Colors.black,

                      child: const ShimmerWidget.rectangular(
                        height: 35,
                      ),
                    ),
                  ),
                  trailing: const ShimmerWidget.circular(height: 45, width: 45),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 17, right: 7),
              child: ListTile(
                  title: Align(
                      alignment: Alignment.centerLeft,
                      child: ShimmerWidget.rectangular(
                        height: 20,
                        width: MediaQuery.of(context).size.width * 0.4,
                      )),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                        ),
                        height: 20,
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                    ),
                  )),
            ),
            //motnhly
            Padding(
                padding: const EdgeInsets.only(left: 7, right: 7),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[400]!,
                        border: Border.all(),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(36))),
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 210,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(36))),
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                    Container(
                      height: 210,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(36))),
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                    Container(
                      height: 210,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(36))),
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                    Container(
                      height: 210,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(36))),
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                    Container(
                      height: 210,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(36))),
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                    Container(
                      height: 210,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(36))),
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                    Container(
                      height: 210,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(36))),
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                    Container(
                      height: 210,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(36))),
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                    Container(
                      height: 210,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]!,
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(36))),
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                  ],
                )),
          ],
        ));
  }
  // Widget shimmerEffect() => const ListTile(
  //       leading: ShimmerWidget.circular(height: 64, width: 64),
  //       // title: ShimmerWidget.rectangular(height: 16),
  //       // subtitle: ShimmerWidget.rectangular(height: 14),
  //       trailing: ShimmerWidget.circular(height: 64, width: 64),
  //     );

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

    return Padding(
      padding: const EdgeInsets.only(top: 53),
      child: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: Column(children: [
                            Transform.scale(
                              scale: 1.4,
                              child: IconButton(
                                  onPressed: () {
                                    myMenu();
                                  },
                                  icon: Image.asset(
                                    "assets/menu.png",
                                  )),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 1.4,
                    child: IconButton(
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
                              prefs.clear();
                              prefs.setString('token', 'null');
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => const MySplashScreen()));
                              await sharedPreferences?.setBool(
                                  'dbDummy', false);
                            });
                      },
                      icon: Image.asset(
                        // "assets/user (1).png",
                        "assets/account.png",
                        // size: 50,
                      ),
                    ),
                  ),
                ]),
            Padding(
              padding: const EdgeInsets.only(top: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good ${greeting()},",
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          sharedPreferences!.getString("name")!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodytengah() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFBF3F4F5),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(
                                        color: Colors.grey.shade200)))),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => NewSearchScreen()));
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.search_normal_14,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Text('Search by Lot...',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                                overflow: TextOverflow.fade,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Transform.scale(
                    scale: 1.5,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => NewSearchScreen()));
                      },
                      icon: Image.asset(
                        "assets/filtter.png",
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 100, bottom: 5, top: 19),
                  child: Text(
                    'Sales progress ${year.toString()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
                LinearPercentIndicator(
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 2500, //kecepatan animasi
                  percent: percentYear,
                  center: Text(
                    '${(list / targetByYear * 100).round()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                  // ignore: deprecated_member_use
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: AppColors.contentColorBlack,
                ),
                Text(CurrencyFormat.convertToIdr(list, 0)),
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
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Monthly',
                                style: TextStyle(
                                  color: AppColors.contentColorBlack,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              // child: Align(
                              //   alignment: Alignment.topRight,
                              //   child: IconButton(
                              //     icon: Icon(
                              //       isPlaying ? Icons.pause : Icons.play_arrow,
                              //       color: AppColors.contentColorBlack,
                              //     ),
                              //     onPressed: () {
                              //       setState(() {
                              //         isPlaying = !isPlaying;
                              //         if (isPlaying) {
                              //           refreshState();
                              //         }
                              //       });
                              //     },
                              //   ),
                              // ),
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
        ],
      ),
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
    barColor ??= AppColors.contentColorBlack;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? (y).toDouble() : y.toDouble(),
          // toY: isTouched ? y + 1 : y,
          color: isTouched ? AppColors.contentColorGreen : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: AppColors.contentColorGreen.darken(80))
              : const BorderSide(color: Colors.black, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 0, //ruang or target bar
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
      //tampilan awal
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
                        // ${(rod.toY).round()}%\n
                        text:
                            '${(rod.toY * 10).toString()[0]},${(rod.toY * 10).toString()[1]}M',
                        style: const TextStyle(
                          color: AppColors.contentColorWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : TextSpan(
                        text:
                            '${(rod.toY * 10).toString()[0]}${(rod.toY * 10).toString()[1]}${(rod.toY * 10).toString()[2]}JT',
                        style: const TextStyle(
                          color: AppColors.contentColorWhite,
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
      color: Colors.black,
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

  void loopingColor(List<String> colors) {
    for (var color in colors) {
      print(color);
    }
  }

  //show popup dialog
  myMenu() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          print(DateTime.now().millisecond);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: const Text(
                  'Please choose menu to select',
                ),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //pos sales
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                // side: BorderSide(color: Colors.grey.shade200)
                              ))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => PosSalesScreen()));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Image.asset(
                                      "images/sales-team.png",
                                      color: Colors.white,
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'Pos Sales',
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '$qtyProductSales Products',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 11),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //pos toko
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                // side: BorderSide(color: Colors.grey.shade200)
                              ))),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Image.asset(
                                      "images/shop.png",
                                      color: Colors.white,
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                  Expanded(
                                    child: sharedPreferences!.getString(
                                                'role_sales_brand')! ==
                                            '3'
                                        ? const Text(
                                            'Pos Toko Metier',
                                            style: TextStyle(fontSize: 16),
                                            maxLines: 1,
                                          )
                                        : const Text(
                                            'Pos Toko',
                                            style: TextStyle(fontSize: 16),
                                            maxLines: 1,
                                          ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '$qtyProductToko Products',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 11),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //pos retur
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                // side: BorderSide(color: Colors.grey.shade200)
                              ))),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    'customer_id_retur', 0.toString());
                                context.read<PCartRetur>().clearCart();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            const PosReturScreen()));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Image.asset(
                                      "images/return.png",
                                      color: Colors.white,
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'Pos Retur',
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 1,
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      // '${CurrencyFormat.convertToTitik(qtyProductRetur, 0)} Products',
                                      '999+ Products',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 11),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //QR
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                // side: BorderSide(color: Colors.grey.shade200)
                              ))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => const QrScanner()));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Image.asset(
                                      "images/qr-code-scan.png",
                                      color: Colors.white,
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'QR',
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '$qtyProductSales Products',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 11),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //history
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                // side: BorderSide(color: Colors.grey.shade200)
                              ))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => const MainHistory()));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Image.asset(
                                      "images/history.png",
                                      color: Colors.white,
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'History',
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '$qtyProductHistory Transaksi',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 11),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //add toko baru
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            AddCustomerMetierScreen()));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Image.asset(
                                      "images/store (2).png",
                                      color: Colors.white,
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'Add Customer',
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 2,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${CurrencyFormat.convertToTitik(qtyProductCustomer, 0)} Customers',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 11),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //CRM
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                // side: BorderSide(color: Colors.grey.shade200)
                              ))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => CrmScreen()));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Image.asset(
                                      "images/crm (1).png",
                                      color: Colors.white,
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'CRM',
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '$qtyProductCRM Reports',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 11),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //E TICKETING
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                // side: BorderSide(color: Colors.grey.shade200)
                              ))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => TicketingScreen()));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Image.asset(
                                      "images/ticket (1).png",
                                      color: Colors.white,
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'E-Ticketing',
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '$qtyProductTicketing Reports',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 11),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //SET DISKON
                        rolePos != '1'
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 1,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      // side: BorderSide(color: Colors.grey.shade200)
                                    ))),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) =>
                                                  SetDiskonScreen()));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Image.asset(
                                            "images/discount2.png",
                                            color: Colors.white,
                                            width: 25,
                                            height: 25,
                                          ),
                                        ),
                                        const Expanded(
                                          child: Text(
                                            'SET Discount',
                                            style: TextStyle(fontSize: 16),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => PosEventScreen()));
                },
                child: SizedBox(
                  height: 110,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60)),
                    backgroundColor: Colors.white,
                    content: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: SizedBox(
                        height: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: Transform.scale(
                                    scale: 2.5,
                                    child:
                                        Lottie.asset("json/iconEvent.json"))),
                            SizedBox(
                              child: DefaultTextStyle(
                                style: TextStyle(
                                    color: availableColors[Random()
                                        .nextInt(availableColors.length)],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => PosEventScreen()));
                                  },
                                  child: AnimatedTextKit(
                                    repeatForever: true,
                                    isRepeatingAnimation: true,
                                    animatedTexts: [
                                      for (var i = 0; i < 15; i++)
                                        TypewriterAnimatedText('Pos Event !',
                                            curve: Curves.easeIn,
                                            speed: const Duration(
                                                milliseconds: 80),
                                            textStyle: TextStyle(
                                              color: availableColors[Random()
                                                  .nextInt(
                                                      availableColors.length)],
                                            )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  _loadFromApi() async {
    setState(() {
      isLoading = false;
    });
    sharedPreferences!.setString('msg', 'refresh');
    // context.read<PCart>().clearCart();
    // context.read<PCartToko>().clearCart();
    // context.read<PCartRetur>().clearCart();
    // await DbAllitems.db.deleteAllitems();
    // await DbAllitemsToko.db.deleteAllitemsToko();
    // await DbAlltransaksiNew.db.deleteAlltransaksiNew();
    // await DbAllCustomer.db.deleteAllcustomer();
    // await DbAllitemsRetur.db.deleteAllitemsRetur();
    // await DbAllKodekeluarbarang.db.deleteAllkeluarbarang();
    // await DbAlldetailtransaksi.db.deleteAlldetailtransaksi();
    // await DbCRM.db.deleteAllcrm();
    //  DbAllitems.db.getAllitems().then((value) {
    //     setState(() {
    //       qtyProductSales = value.length;
    //     });
    //   });
    // DbAllitemsToko.db.getAllToko().then((value) {
    //   setState(() {
    //     qtyProductToko = value.length;
    //   });
    // });
    // DbAllitemsRetur.db.getAllRetur().then((value) {
    //   setState(() {
    //     qtyProductRetur = value.length;
    //   });
    // });
    try {
      await _getDataToko(token);
    } catch (c) {
      throw Exception('Unexpected error occured!');
    }
    // try {
    //   await _getDataHistoryNew(token);
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all history");
    // }
    // try {
    //   await _getDataRetur(token);
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all retur");
    // }
    try {
      await _getDataSales(token);
    } catch (c) {
      Fluttertoast.showToast(msg: "Failed To Load Data all items");
    }

    // try {
    //   apiProvider.getAllItems();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all items");
    // }
    // try {
    //   apiProvider.getAllItemsToko();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all items");
    // }
    // try {
    //   apiProvider.getAllItemsRetur();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all items");
    // }
    // try {
    //   await apiProvider.getAllTransaksiNew();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all transaksi");
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
    //   print('Error gett all customer : $c');
    //   throw Exception('error : $c');
    // }

    // try {
    //   await apiProvider.getAllTCRM();
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data CRM");
    // }

    context.read<PNewNotif>().clearNotif(); //? clear notif
    await DbNotifDummy.db.getAllNotif(1).then((value) {
      for (var i = 0; i < value.length; i++) {
        //* add notif
        context.read<PNewNotif>().addItem(
              1,
            );
      }
    });
    // DbAllitems.db.getAllitems().then((value) {
    //   setState(() {
    //     qtyProductSales = value.length;
    //   });
    // });
    // DbAllitemsToko.db.getAllToko().then((value) {
    //   setState(() {
    //     qtyProductToko = value.length;
    //   });
    // });
    // DbAllitemsRetur.db.getAllRetur().then((value) {
    //   setState(() {
    //     qtyProductRetur = value.length;
    //   });
    // });

    //initial qty history
    DbAlltransaksi.db.getAllHistoryBaru().then((value) {
      print('masuk get history');
      setState(() {
        qtyProductHistory = value.length;
      });
    });
    //initial customer name
    sharedPreferences!.getString('role_sales_brand')! == '3'
        ? getCustomerMetier().then((value) {
            setState(() {
              qtyProductCustomer = value.length;
            });
          })
        : DbAllCustomer.db.getAllcustomer().then((value) {
            setState(() {
              qtyProductCustomer = value.length;
            });
          });
    //initial crm
    DbCRM.db.getAllcrmBySales(sharedPreferences!.getString('id')).then((value) {
      setState(() {
        qtyProductCRM = value.length;
      });
    });

    year = DateFormat('y').format(DateTime.now());
    //jan
    DbAlltransaksi.db
        .getAlltransaksiNominalByMonthBaru('1', year)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        barJan += value[i].nett!; //menjumlahkan ke list
      }
      setState(() {
        barJan = (barJan / targetByMonth).round();
      });
      print('ini januari 2: $barJan');
    });
    //feb
    DbAlltransaksi.db
        .getAlltransaksiNominalByMonthBaru('2', year)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        barFeb += value[i].nett!; //menjumlahkan ke list
      }
      setState(() {
        barFeb = (barFeb / targetByMonth).round();
      });
    });
    //mar
    DbAlltransaksi.db
        .getAlltransaksiNominalByMonthBaru('3', year)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        barMar += value[i].nett!; //menjumlahkan ke list
      }
      setState(() {
        barMar = (barMar / targetByMonth).round();
      });
    });
    //apr
    DbAlltransaksi.db
        .getAlltransaksiNominalByMonthBaru('4', year)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        barApr += value[i].nett!; //menjumlahkan ke list
      }
      setState(() {
        barApr = (barApr / targetByMonth).round();
      });
    });
    //may
    DbAlltransaksi.db
        .getAlltransaksiNominalByMonthBaru('5', year)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        barMay += value[i].nett!; //menjumlahkan ke list
      }
      setState(() {
        barMay = (barMay / targetByMonth).round();
      });
    });
    //jun
    DbAlltransaksi.db
        .getAlltransaksiNominalByMonthBaru('6', year)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        barJun += value[i].nett!; //menjumlahkan ke list
      }
      setState(() {
        barJun = (barJun / targetByMonth).round();
      });
    });
    //jul
    DbAlltransaksi.db
        .getAlltransaksiNominalByMonthBaru('7', year)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        barJul += value[i].nett!; //menjumlahkan ke list
      }
      setState(() {
        barJul = (barJul / targetByMonth).round();
      });
    });
    //agus
    DbAlltransaksi.db
        .getAlltransaksiNominalByMonthBaru('8', year)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        barAug += value[i].nett!; //menjumlahkan ke list
      }
      setState(() {
        barAug = (barAug / targetByMonth).round();
      });
    });
    //sept
    DbAlltransaksi.db
        .getAlltransaksiNominalByMonthBaru('9', year)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        barSep += value[i].nett!; //menjumlahkan ke list
      }
      setState(() {
        barSep = (barSep / targetByMonth).round();
      });
    });
    //okt
    DbAlltransaksi.db
        .getAlltransaksiNominalByMonthBaru('10', year)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        barOct += value[i].nett!; //menjumlahkan ke list
      }
      setState(() {
        barOct = (barOct / targetByMonth).round();
      });
    });
    //nov
    DbAlltransaksi.db
        .getAlltransaksiNominalByMonthBaru('11', year)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        barNov += value[i].nett!; //menjumlahkan ke list
      }
      setState(() {
        barNov = (barNov / targetByMonth).round();
      });
    });
    //desc
    DbAlltransaksi.db
        .getAlltransaksiNominalByMonthBaru('12', year)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        barDec += value[i].nett!; //menjumlahkan ke list
      }
      setState(() {
        barDec = (barDec / targetByMonth).round();
      });
    });

    DbAlltransaksi.db.getAlltransaksiNominalBaru(year).then((value) {
      for (var i = 0; i < value.length; i++) {
        list += value[i].nett!; //menjumlahkan ke list
        listNominal.add(value[i].nett); //memasukan ke list
      }
      percentYear = (list / targetByYear);
      setState(() {
        (percentYear > 1.0)
            ? percentYear = 1.0
            : percentYear = list / targetByYear;
      });
    });
    // percentYear = 0.7;
    percentMonth = 0.3;
    percentWeek = 0.1;
    //star notifi
    PushNotificationsSystem pushNotificationsSystem = PushNotificationsSystem();
    pushNotificationsSystem.whenNotificationReceived(context);
    // pushNotificationsSystem.notificationPopUp(context);
    //end notif
    setState(() {
      sharedPreferences!.setString('newOpenHome', 'false');
      isLoading = true;
    });
  }

  Future<List<CustomerMetierModel>> getCustomerMetier() async {
    String token = sharedPreferences!.getString("token").toString();
    var response = await Dio().get(
      ApiConstants.baseUrl + ApiConstants.GETcustomerMetier,
      options: Options(headers: {"Authorization": 'Bearer $token'}),
    );

    final data = response.data;
    if (data != null) {
      return CustomerMetierModel.fromJsonList(data);
    }

    return [];
  }
}
