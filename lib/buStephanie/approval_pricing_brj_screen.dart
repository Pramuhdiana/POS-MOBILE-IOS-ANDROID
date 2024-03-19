// ignore_for_file: use_key_in_widget_constructors, avoid_print, use_build_context_synchronously, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/buStephanie/approve_pricing_model.dart';
import 'package:e_shop/buStephanie/main_screen_approve_pricing.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/provider/provider_waiting_brj.dart';
import 'package:e_shop/provider/provider_waiting_eticketing.dart';
import 'package:e_shop/widgets/custom_dialog.dart';
import 'package:e_shop/widgets/keyboard_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../global/currency_format.dart';
import 'package:http/http.dart' as http;
import '../push_notifications/push_notifications_system.dart';
import '../widgets/custom_loading.dart';
import 'item_photo_pricing.dart';

class ApprovalPricingBrjScreen extends StatefulWidget {
  final List<ApprovePricingModel>? dataApproved;

  const ApprovalPricingBrjScreen({required this.dataApproved});

  @override
  State<ApprovalPricingBrjScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<ApprovalPricingBrjScreen> {
  String searchInput = '';
  bool isLoading = false;
  FocusNode numberFocusNode = FocusNode();
  TextEditingController price = TextEditingController();
  TextEditingController url = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController textInput = TextEditingController();
  var baseUrlDinamis = sharedPreferences!.getString('urlDinamis');
  List<ApprovePricingModel>? filterPrice;
  List<ApprovePricingModel>? listHistory;
  RoundedLoadingButtonController btnControllerApproveBRJ =
      RoundedLoadingButtonController();
  int totalHistori = 0;
  int limitHistori = 0;
  String date = '';
  double awalPrice = 0;
  int apiPrice = 0;
  String apiNotes = '';
  bool isMargin = false;
  int valuePrice = 0;
  int hpp = 0;
  List<String> listTheme = [];
  bool isShowFilter = false;
  bool statusSendOk = false;
  String priceApi = '0';

  final NumberFormat _currencyFormatterRp =
      NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0, locale: 'id-ID');

  final NumberFormat _currencyFormatterDollar =
      NumberFormat.currency(symbol: '\$', decimalDigits: 0, locale: 'en_US');

  @override
  void initState() {
    super.initState();
    // ignore: unused_local_variable
    bool? isDinamis = sharedPreferences!.getBool('isDinamis');
    baseUrlDinamis = sharedPreferences!.getString('urlDinamis');
    filterPrice = widget.dataApproved;
    numberFocusNode.addListener(() {
      bool hasFocus = numberFocusNode.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    // _getData();
    context.read<PApprovalBrj>().clearNotif(); //clear cart
    loadListBRJ(); //ambil data cart
    context.read<PApprovalEticketing>().clearNotif(); //clear cart
    loadListEticketing(); //ambil data cart
    PushNotificationsSystem pushNotificationsSystem = PushNotificationsSystem();
    pushNotificationsSystem.whenNotificationReceivedInPricing(context);
  }

  @override
  void dispose() {
    // Clean up the focus node
    numberFocusNode.dispose();
    super.dispose();
  }

  int get margin {
    int total;
    valuePrice == 0
        ? total = 0
        : total = (((valuePrice - (hpp)) / valuePrice) * 100).round();

    return total;
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

  _getDataByModel2(kode) async {
    String fixKode = kode.toString().substring(
        0, 11); //mengambil data hanya 9 character get data hanya 9 charackter
    var filterBykode = filterPrice!
        .where((element) => element.marketingCode!.contains(fixKode))
        .toList();

    totalHistori = filterBykode.length;
    totalHistori <= 10 ? limitHistori = totalHistori : limitHistori = 10;
    // setState(() {
    listHistory = filterBykode;
    // });
  }

  Future _getData() async {
    listTheme = [];

    bool? isDinamis = sharedPreferences!.getBool('isDinamis');
    baseUrlDinamis = sharedPreferences!.getString('urlDinamis');

    try {
      final response = isDinamis == true
          ? await http.get(Uri.parse(
              baseUrlDinamis! + ApiConstants.GETapprovelPricingWaiting))
          : await http.get(Uri.parse(ApiConstants.baseUrlPricing +
              ApiConstants.GETapprovelPricingWaiting));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        var g = jsonResponse
            .map((data) => ApprovePricingModel.fromJson(data))
            .toList();

        for (var i = 0; i < g.length; i++) {
          listTheme.add(g[i].theme!); //! nanti ganti dengan theme
        }
        listTheme = listTheme
            .toSet()
            .toList(); //! remove duplicate dengan toset dan to list
        listTheme.removeWhere((value) => value == '');
        // try {
        //   final response2 = await http.get(Uri.parse(
        //       ApiConstants.baseUrlPricing +
        //           ApiConstants.GETapprovelPricingApproved));
        //   if (response2.statusCode == 200) {
        //     print('get data untuk history');
        //     List jsonResponse = json.decode(response2.body);
        //     filterPrice = jsonResponse
        //         .map((data) => ApprovePricingModel.fromJson(data))
        //         .toList();
        //   } else {
        //     throw Exception('err');
        //   }
        // } catch (c) {
        //   print('err :$c');
        // }
        return g;
      } else {
        showCustomDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error Get All Data',
            description: response.body,
            dismiss: false);
      }
    } catch (e) {
      return showCustomDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error Get All Data',
          description: '$e',
          dismiss: false);
    }
  }

  // Future _getDataByModel(model) async {
  //   print(model);
  //   String fixModel = model.toString().substring(
  //       0, 11); //mengambil data hanya 9 character get data hanya 9 charackter
  //   bool? isDinamis = sharedPreferences!.getBool('isDinamis');
  //   baseUrlDinamis = sharedPreferences!.getString('urlDinamis');

  //   try {
  //     final response = isDinamis == true
  //         ? await http.get(Uri.parse(baseUrlDinamis! +
  //             ApiConstants.GETapprovelPricingApproved +
  //             '/$fixModel'))
  //         : await http.get(Uri.parse(ApiConstants.baseUrlPricing +
  //             ApiConstants.GETapprovelPricingApproved +
  //             '/$fixModel'));
  //     if (response.statusCode == 200) {
  //       List jsonResponse = json.decode(response.body);
  //       var g = jsonResponse
  //           .map((data) => ApprovePricingModel.fromJson(data))
  //           .toList();
  //       totalHistori = g.length;
  //       totalHistori <= 10 ? limitHistori = totalHistori : limitHistori = 10;
  //       return g;
  //     } else {
  //       throw Exception('err');
  //     }
  //   } catch (c) {
  //     // print('err :$c');
  //     return throw Exception(c);
  //   }
  // }

//fungsi search
  Future _getDataSearch(search) async {
    bool? isDinamis = sharedPreferences!.getBool('isDinamis');
    baseUrlDinamis = sharedPreferences!.getString('urlDinamis');

    try {
      final response = isDinamis == true
          ? await http.get(Uri.parse(
              baseUrlDinamis! + ApiConstants.GETapprovelPricingWaiting))
          : await http.get(Uri.parse(ApiConstants.baseUrlPricing +
              ApiConstants.GETapprovelPricingWaiting));
      // if response successful
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        var g = jsonResponse
            .map((data) => ApprovePricingModel.fromJson(data))
            .toList();
        //! fungsi query untuk mencari data dari response body (kembalian dari API)
        var modifiedUserData = g.where((element) =>
            element.lotNo!
                .toString()
                .toLowerCase()
                .contains(search.toString().toLowerCase()) ||
            element.productTypeDesc!
                .toString()
                .toLowerCase()
                .contains(search.toString().toLowerCase()) ||
            element.theme!
                .toString()
                .toLowerCase()
                .contains(search.toString().toLowerCase()) ||
            element.marketingCode!
                .toString()
                .toLowerCase()
                .contains(search.toString().toLowerCase()) ||
            element.finalPrice3USD!
                .toString()
                .toLowerCase()
                .contains(search.toString().toLowerCase()));
        return modifiedUserData.toList();
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (e) {
      return showCustomDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error Get All Data',
          description: '$e',
          dismiss: false);
    }
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    await _getData();
    context.read<PApprovalBrj>().clearNotif(); //clear cart
    await loadListBRJ(); //ambil data cart
    setState(() {
      isLoading = false;
    });
  }

  loadListBRJ() async {
    bool? isDinamis = sharedPreferences!.getBool('isDinamis');
    baseUrlDinamis = sharedPreferences!.getString('urlDinamis');

    var url = isDinamis == true
        ? baseUrlDinamis! + ApiConstants.GETapprovelPricingWaiting
        : ApiConstants.baseUrlPricing + ApiConstants.GETapprovelPricingWaiting;
    Response response = await Dio().get(
      url,
    );
    return (response.data as List).map((cart) {
      context.read<PApprovalBrj>().addItem(
            1,
          );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, //? keyboard overflowed
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Image.asset(
              "assets/arrow.png",
              width: 35,
              height: 35,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: CupertinoSearchTextField(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            itemColor: Colors.black,
            // autofocus: false,
            controller: textInput,
            backgroundColor: Colors.black12,
            // keyboardType: TextInputType.number,
            // focusNode: numberFocusNode,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              setState(() {
                searchInput = value;
              });
            },
          ),
          actions: [
            Container(
              padding: const EdgeInsets.only(right: 5),
              child: Transform.scale(
                scale: 1.2,
                child: IconButton(
                  onPressed: () {
                    showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, widget) {
                          return Transform.scale(
                            scale: a1.value,
                            child: Opacity(
                              opacity: a1.value,
                              child: AlertDialog(
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                title: const Text('Select theme'),
                                content: Stack(
                                    clipBehavior: Clip.none,
                                    children: <Widget>[
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            maxHeight: 400),
                                        // ignore: avoid_unnecessary_containers
                                        child: Container(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Center(
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    for (var i = 0;
                                                        i < listTheme.length;
                                                        i++)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 15),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                          height: 40,
                                                          child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                shape: MaterialStateProperty.all<
                                                                        RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                              // side: BorderSide(color: Colors.grey.shade200)
                                                            ))),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {
                                                                textInput.text =
                                                                    listTheme[
                                                                        i];
                                                                searchInput =
                                                                    listTheme[
                                                                        i];
                                                              });
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                //icon
                                                                const Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
                                                                    child: Icon(
                                                                        Icons
                                                                            .arrow_forward_ios)),
                                                                Expanded(
                                                                  child: Text(
                                                                    listTheme[
                                                                        i],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: -50.0,
                                        top: -90.0,
                                        child: InkResponse(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          //! Cancel
                                          child: Transform.scale(
                                              scale: 2,
                                              child: SizedBox(
                                                  height: 40,
                                                  child: Lottie.asset(
                                                      "json/icon_delete.json"))),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 200),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation1, animation2) {
                          return const Text('');
                        });
                  },
                  icon: Image.asset(
                    "assets/filtter.png",
                  ),
                ),
              ),
            )
          ],
        ),
        body: isLoading != false
            ? Center(
                child: Container(
                    padding: const EdgeInsets.all(0),
                    width: 90,
                    height: 90,
                    child: Lottie.asset("json/loading_black.json")))
            : RefreshIndicator(
                onRefresh: refresh,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 35,
                      child: Text(
                        'Waiting for approval BRJ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: searchInput == ''
                            ? _getData()
                            : _getDataSearch(searchInput),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                'You Have Not \n\n Waiting List Pricing BRJ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Acne',
                                    letterSpacing: 1.5),
                              ),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Container(
                                    padding: const EdgeInsets.all(0),
                                    width: 90,
                                    height: 90,
                                    child: Lottie.asset(
                                        "json/loading_black.json")));
                          } else if (snapshot.data.isEmpty) {
                            return const Center(
                              child: Text(
                                'You Have Not \n\n Waiting List Pricing BRJ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Acne',
                                    letterSpacing: 1.5),
                              ),
                            );
                          } else {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = snapshot.data![index];

                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await _getDataByModel2(
                                            data.marketingCode);

                                        hpp = int.parse(data
                                                .grandSTDLabourPrice!
                                                .round()
                                                .toString()) +
                                            int.parse(data.stdGoldPrice!
                                                .round()
                                                .toString()) +
                                            int.parse(data.grandSTDDiamondPrice!
                                                .round()
                                                .toString());
                                        showGeneralDialog(
                                            transitionDuration: const Duration(
                                                milliseconds: 200),
                                            barrierDismissible: true,
                                            barrierLabel: '',
                                            context: context,
                                            pageBuilder: (context, animation1,
                                                animation2) {
                                              return const Text('');
                                            },
                                            barrierColor:
                                                Colors.black.withOpacity(0.5),
                                            transitionBuilder:
                                                (context, a1, a2, widget) {
                                              return Transform.scale(
                                                scale: a1.value,
                                                child: Opacity(
                                                  opacity: a1.value,
                                                  child: AlertDialog(
                                                    content: Stack(
                                                        clipBehavior: Clip.none,
                                                        children: <Widget>[
                                                          Positioned(
                                                            right: -50.0,
                                                            top: -50.0,
                                                            child: InkResponse(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              //! Cancel
                                                              child: Transform.scale(
                                                                  scale: 2,
                                                                  child: SizedBox(
                                                                      height:
                                                                          40,
                                                                      child: Lottie
                                                                          .asset(
                                                                              "json/icon_delete.json"))),
                                                            ),
                                                          ),
                                                          // FutureBuilder(
                                                          //     future: _getDataByModel(data
                                                          //         .marketingCode),
                                                          //     builder: (context,
                                                          //         snapshot2) {
                                                          //       if (snapshot2
                                                          //           .hasError) {
                                                          //         return SizedBox(
                                                          //           height: 550,
                                                          //           child: Column(
                                                          //             mainAxisSize:
                                                          //                 MainAxisSize
                                                          //                     .min,
                                                          //             children: [
                                                          //               Container(
                                                          //                 padding: const EdgeInsets
                                                          //                     .all(
                                                          //                     3),
                                                          //                 color: Colors
                                                          //                     .black,
                                                          //                 child:
                                                          //                     Text(
                                                          //                   '${data.lotNo} / ${data.marketingCode}',
                                                          //                   style: const TextStyle(
                                                          //                       color: Colors.white,
                                                          //                       fontWeight: FontWeight.bold),
                                                          //                 ),
                                                          //               ),
                                                          //               Align(
                                                          //                 alignment:
                                                          //                     Alignment.centerLeft,
                                                          //                 child:
                                                          //                     Row(
                                                          //                   mainAxisAlignment:
                                                          //                       MainAxisAlignment.spaceBetween,
                                                          //                   children: [
                                                          //                     const Text(
                                                          //                       'Price Per Carat',
                                                          //                       textAlign: TextAlign.left,
                                                          //                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                     ),
                                                          //                     const Text(':'),
                                                          //                     Text(
                                                          //                       'Rp.${CurrencyFormat.convertToDollar(data.pricePerCarat!, 0)}',
                                                          //                       textAlign: TextAlign.left,
                                                          //                       style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                     ),
                                                          //                   ],
                                                          //                 ),
                                                          //               ),
                                                          //               Align(
                                                          //                 alignment:
                                                          //                     Alignment.centerLeft,
                                                          //                 child:
                                                          //                     Row(
                                                          //                   mainAxisAlignment:
                                                          //                       MainAxisAlignment.spaceBetween,
                                                          //                   children: [
                                                          //                     const Text(
                                                          //                       'After Discount',
                                                          //                       textAlign: TextAlign.left,
                                                          //                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                     ),
                                                          //                     const Text(':'),
                                                          //                     Text(
                                                          //                       'Rp.${CurrencyFormat.convertToDollar(data.priceAfterDiscount!, 0)}',
                                                          //                       textAlign: TextAlign.left,
                                                          //                       style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                     ),
                                                          //                   ],
                                                          //                 ),
                                                          //               ),
                                                          //               const Divider(
                                                          //                 thickness:
                                                          //                     3,
                                                          //                 color: Colors
                                                          //                     .black,
                                                          //               ),
                                                          //               const Center(
                                                          //                 child:
                                                          //                     Text(
                                                          //                   'History Approve',
                                                          //                   style:
                                                          //                       TextStyle(fontWeight: FontWeight.bold),
                                                          //                 ),
                                                          //               ),
                                                          //               Expanded(
                                                          //                 child:
                                                          //                     SizedBox(
                                                          //                   width:
                                                          //                       MediaQuery.of(context).size.width * 1,
                                                          //                   child:
                                                          //                       const Center(child: Text('No Data')),
                                                          //                 ),
                                                          //               ),
                                                          //               Container(
                                                          //                 decoration:
                                                          //                     BoxDecoration(border: Border.all(width: 2.5, color: Colors.black)),
                                                          //                 padding: const EdgeInsets
                                                          //                     .all(
                                                          //                     5),
                                                          //                 child:
                                                          //                     Column(
                                                          //                   children: [
                                                          //                     Row(
                                                          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                       children: [
                                                          //                         const Text(
                                                          //                           'Labour',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                         ),
                                                          //                         Text(
                                                          //                           'Rp.${CurrencyFormat.convertToDollar(int.parse(data.grandSTDLabourPrice!.round().toString()), 0)}',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                         ),
                                                          //                       ],
                                                          //                     ),
                                                          //                     Row(
                                                          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                       children: [
                                                          //                         const Text(
                                                          //                           'Emas',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                         ),
                                                          //                         Text(
                                                          //                           'Rp.${CurrencyFormat.convertToDollar(int.parse(data.stdGoldPrice!.round().toString()), 0)}',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                         ),
                                                          //                       ],
                                                          //                     ),
                                                          //                     Row(
                                                          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                       children: [
                                                          //                         const Text(
                                                          //                           'Diamond',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                         ),
                                                          //                         Text(
                                                          //                           'Rp.${CurrencyFormat.convertToDollar(int.parse(data.grandSTDDiamondPrice!.round().toString()), 0)}',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                         ),
                                                          //                       ],
                                                          //                     ),
                                                          //                     const Divider(
                                                          //                       thickness: 3,
                                                          //                       color: Colors.black,
                                                          //                     ),
                                                          //                     Row(
                                                          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                       children: [
                                                          //                         const Text(
                                                          //                           'HPP',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                          //                         ),
                                                          //                         Text(
                                                          //                           'Rp.${CurrencyFormat.convertToDollar(hpp, 0)}',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                          //                         ),
                                                          //                       ],
                                                          //                     ),
                                                          //                   ],
                                                          //                 ),
                                                          //               ),
                                                          //             ],
                                                          //           ),
                                                          //         );
                                                          //       } else if (snapshot2
                                                          //               .connectionState ==
                                                          //           ConnectionState
                                                          //               .waiting) {
                                                          //         return SizedBox(
                                                          //           height: 350,
                                                          //           child: Column(
                                                          //             mainAxisSize:
                                                          //                 MainAxisSize
                                                          //                     .min,
                                                          //             children: [
                                                          //               Container(
                                                          //                 padding: const EdgeInsets
                                                          //                     .all(
                                                          //                     3),
                                                          //                 color: Colors
                                                          //                     .black,
                                                          //                 child:
                                                          //                     Text(
                                                          //                   '${data.lotNo} / ${data.marketingCode}',
                                                          //                   style: const TextStyle(
                                                          //                       color: Colors.white,
                                                          //                       fontWeight: FontWeight.bold),
                                                          //                 ),
                                                          //               ),
                                                          //               Align(
                                                          //                 alignment:
                                                          //                     Alignment.centerLeft,
                                                          //                 child:
                                                          //                     Row(
                                                          //                   mainAxisAlignment:
                                                          //                       MainAxisAlignment.spaceBetween,
                                                          //                   children: [
                                                          //                     const Text(
                                                          //                       'Price Per Carat',
                                                          //                       textAlign: TextAlign.left,
                                                          //                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                     ),
                                                          //                     const Text(':'),
                                                          //                     Text(
                                                          //                       'Rp.${CurrencyFormat.convertToDollar(data.pricePerCarat!, 0)}',
                                                          //                       textAlign: TextAlign.left,
                                                          //                       style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                     ),
                                                          //                   ],
                                                          //                 ),
                                                          //               ),
                                                          //               Align(
                                                          //                 alignment:
                                                          //                     Alignment.centerLeft,
                                                          //                 child:
                                                          //                     Row(
                                                          //                   mainAxisAlignment:
                                                          //                       MainAxisAlignment.spaceBetween,
                                                          //                   children: [
                                                          //                     const Text(
                                                          //                       'After Discount',
                                                          //                       textAlign: TextAlign.left,
                                                          //                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                     ),
                                                          //                     const Text(':'),
                                                          //                     Text(
                                                          //                       'Rp.${CurrencyFormat.convertToDollar(data.priceAfterDiscount!, 0)}',
                                                          //                       textAlign: TextAlign.left,
                                                          //                       style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                     ),
                                                          //                   ],
                                                          //                 ),
                                                          //               ),
                                                          //               const Divider(
                                                          //                 thickness:
                                                          //                     3,
                                                          //                 color: Colors
                                                          //                     .black,
                                                          //               ),
                                                          //               const Center(
                                                          //                 child:
                                                          //                     Text(
                                                          //                   'History Approve',
                                                          //                   style:
                                                          //                       TextStyle(fontWeight: FontWeight.bold),
                                                          //                 ),
                                                          //               ),
                                                          //               Expanded(
                                                          //                 child:
                                                          //                     SizedBox(
                                                          //                   width:
                                                          //                       MediaQuery.of(context).size.width * 1,
                                                          //                   child:
                                                          //                       Center(child: Container(padding: const EdgeInsets.all(0), width: 90, height: 90, child: Lottie.asset("json/loading_black.json"))),
                                                          //                 ),
                                                          //               ),
                                                          //               Container(
                                                          //                 decoration:
                                                          //                     BoxDecoration(border: Border.all(width: 2.5, color: Colors.black)),
                                                          //                 padding: const EdgeInsets
                                                          //                     .all(
                                                          //                     5),
                                                          //                 child:
                                                          //                     Column(
                                                          //                   children: [
                                                          //                     Row(
                                                          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                       children: [
                                                          //                         const Text(
                                                          //                           'Labour',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                         ),
                                                          //                         Text(
                                                          //                           'Rp.${CurrencyFormat.convertToDollar(int.parse(data.grandSTDLabourPrice!.round().toString()), 0)}',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                         ),
                                                          //                       ],
                                                          //                     ),
                                                          //                     Row(
                                                          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                       children: [
                                                          //                         const Text(
                                                          //                           'Emas',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                         ),
                                                          //                         Text(
                                                          //                           'Rp.${CurrencyFormat.convertToDollar(int.parse(data.stdGoldPrice!.round().toString()), 0)}',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                         ),
                                                          //                       ],
                                                          //                     ),
                                                          //                     Row(
                                                          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                       children: [
                                                          //                         const Text(
                                                          //                           'Diamond',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                         ),
                                                          //                         Text(
                                                          //                           'Rp.${CurrencyFormat.convertToDollar(int.parse(data.grandSTDDiamondPrice!.round().toString()), 0)}',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //                         ),
                                                          //                       ],
                                                          //                     ),
                                                          //                     const Divider(
                                                          //                       thickness: 3,
                                                          //                       color: Colors.black,
                                                          //                     ),
                                                          //                     Row(
                                                          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                       children: [
                                                          //                         const Text(
                                                          //                           'HPP',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                          //                         ),
                                                          //                         Text(
                                                          //                           'Rp.${CurrencyFormat.convertToDollar(hpp, 0)}',
                                                          //                           textAlign: TextAlign.left,
                                                          //                           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                          //                         ),
                                                          //                       ],
                                                          //                     ),
                                                          //                   ],
                                                          //                 ),
                                                          //               ),
                                                          //             ],
                                                          //           ),
                                                          //         );
                                                          //       } else {
                                                          SizedBox(
                                                            height: 550,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          3),
                                                                  color: Colors
                                                                      .black,
                                                                  child: Text(
                                                                    '${data.lotNo} / ${data.marketingCode}',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      const Text(
                                                                        'Price Per Carat',
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      const Text(
                                                                          ':'),
                                                                      Text(
                                                                        'Rp.${CurrencyFormat.convertToDollar(data.pricePerCarat!, 0)}',
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      const Text(
                                                                        'After Discount',
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      const Text(
                                                                          ':'),
                                                                      Text(
                                                                        'Rp.${CurrencyFormat.convertToDollar(data.priceAfterDiscount!, 0)}',
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                  thickness: 3,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                const Center(
                                                                  child: Text(
                                                                    'History Approve',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                limitHistori ==
                                                                        0
                                                                    ? const Expanded(
                                                                        child:
                                                                            Center(
                                                                        child: Text(
                                                                            'Tidak ada data'),
                                                                      ))
                                                                    : Expanded(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 1,
                                                                          child: SingleChildScrollView(
                                                                              scrollDirection: Axis.vertical,
                                                                              child: Column(
                                                                                children: [
                                                                                  for (var i = 0; i < limitHistori; i++)
                                                                                    Column(
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            listHistory![i].salesDefinitionCode.toString().toLowerCase() == "parva"
                                                                                                ? Text(
                                                                                                    '\$ ${CurrencyFormat.convertToDollar(listHistory![i].approvalPrice!, 0)}',
                                                                                                    style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                                  )
                                                                                                : listHistory![i].salesDefinitionCode.toString().toLowerCase() == "fine"
                                                                                                    ? Text(
                                                                                                        '\$ ${CurrencyFormat.convertToDollar(listHistory![i].approvalPrice!, 0)}',
                                                                                                        style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                                      )
                                                                                                    : Text(
                                                                                                        'Rp. ${CurrencyFormat.convertToDollar(listHistory![i].approvalPrice!, 0)}',
                                                                                                        style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                                      ),
                                                                                            Text(
                                                                                              // DateFormat('dd-MM-yyyy | HH:mm').format(DateTime.now()),
                                                                                              DateFormat('dd-MM-yyyy').format(DateTime.parse(listHistory![i].approvedDate ?? '')),
                                                                                              // listHistory![i].approvedDate,
                                                                                              style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        const Divider(
                                                                                          thickness: 1,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                ],
                                                                              )),
                                                                        ),
                                                                      ),
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
                                                                  child: Text(
                                                                    'Total Repeat :' +
                                                                        totalHistori
                                                                            .toString(),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          width:
                                                                              2.5,
                                                                          color:
                                                                              Colors.black)),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'Labour',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          Text(
                                                                            'Rp.${CurrencyFormat.convertToDollar(int.parse(data.grandSTDLabourPrice!.round().toString()), 0)}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'Emas',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          Text(
                                                                            'Rp.${CurrencyFormat.convertToDollar(int.parse(data.stdGoldPrice!.round().toString()), 0)}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'Diamond',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          Text(
                                                                            'Rp.${CurrencyFormat.convertToDollar(int.parse(data.grandSTDDiamondPrice!.round().toString()), 0)}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const Divider(
                                                                        thickness:
                                                                            3,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'HPP',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.blue),
                                                                          ),
                                                                          Text(
                                                                            'Rp.${CurrencyFormat.convertToDollar(hpp, 0)}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.blue),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            // } else {
                                                            //   return SizedBox(
                                                            //     height: 350,
                                                            //     child: Column(
                                                            //       mainAxisSize:
                                                            //           MainAxisSize
                                                            //               .min,
                                                            //       children: [
                                                            //         Container(
                                                            //           padding:
                                                            //               const EdgeInsets
                                                            //                   .all(
                                                            //                   3),
                                                            //           color: Colors
                                                            //               .black,
                                                            //           child:
                                                            //               Text(
                                                            //             '${data.lotNo} / ${data.marketingCode}',
                                                            //             style: const TextStyle(
                                                            //                 color:
                                                            //                     Colors.white,
                                                            //                 fontWeight: FontWeight.bold),
                                                            //           ),
                                                            //         ),
                                                            //         Align(
                                                            //           alignment:
                                                            //               Alignment
                                                            //                   .centerLeft,
                                                            //           child:
                                                            //               Row(
                                                            //             mainAxisAlignment:
                                                            //                 MainAxisAlignment.spaceBetween,
                                                            //             children: [
                                                            //               const Text(
                                                            //                 'Price Per Carat',
                                                            //                 textAlign:
                                                            //                     TextAlign.left,
                                                            //                 style: TextStyle(
                                                            //                     fontSize: 15,
                                                            //                     fontWeight: FontWeight.bold,
                                                            //                     color: Colors.black),
                                                            //               ),
                                                            //               const Text(
                                                            //                   ':'),
                                                            //               Text(
                                                            //                 'Rp.${CurrencyFormat.convertToDollar(data.pricePerCarat!, 0)}',
                                                            //                 textAlign:
                                                            //                     TextAlign.left,
                                                            //                 style: const TextStyle(
                                                            //                     fontSize: 15,
                                                            //                     fontWeight: FontWeight.bold,
                                                            //                     color: Colors.black),
                                                            //               ),
                                                            //             ],
                                                            //           ),
                                                            //         ),
                                                            //         Align(
                                                            //           alignment:
                                                            //               Alignment
                                                            //                   .centerLeft,
                                                            //           child:
                                                            //               Row(
                                                            //             mainAxisAlignment:
                                                            //                 MainAxisAlignment.spaceBetween,
                                                            //             children: [
                                                            //               const Text(
                                                            //                 'After Discount',
                                                            //                 textAlign:
                                                            //                     TextAlign.left,
                                                            //                 style: TextStyle(
                                                            //                     fontSize: 15,
                                                            //                     fontWeight: FontWeight.bold,
                                                            //                     color: Colors.black),
                                                            //               ),
                                                            //               const Text(
                                                            //                   ':'),
                                                            //               Text(
                                                            //                 'Rp.${CurrencyFormat.convertToDollar(data.priceAfterDiscount!, 0)}',
                                                            //                 textAlign:
                                                            //                     TextAlign.left,
                                                            //                 style: const TextStyle(
                                                            //                     fontSize: 15,
                                                            //                     fontWeight: FontWeight.bold,
                                                            //                     color: Colors.black),
                                                            //               ),
                                                            //             ],
                                                            //           ),
                                                            //         ),
                                                            //         const Divider(
                                                            //           thickness:
                                                            //               3,
                                                            //           color: Colors
                                                            //               .black,
                                                            //         ),
                                                            //         const Center(
                                                            //           child:
                                                            //               Text(
                                                            //             'History Approve',
                                                            //             style: TextStyle(
                                                            //                 fontWeight:
                                                            //                     FontWeight.bold),
                                                            //           ),
                                                            //         ),
                                                            //         Expanded(
                                                            //           child:
                                                            //               SizedBox(
                                                            //             width:
                                                            //                 MediaQuery.of(context).size.width *
                                                            //                     1,
                                                            //             child: Center(
                                                            //                 child: Container(
                                                            //                     padding: const EdgeInsets.all(0),
                                                            //                     width: 90,
                                                            //                     height: 90,
                                                            //                     child: Lottie.asset("json/loading_black.json"))),
                                                            //           ),
                                                            //         )
                                                            //       ],
                                                            //     ),
                                                            //   );
                                                            // }

                                                            // }),
                                                          )
                                                        ]),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        padding:
                                            const EdgeInsets.only(right: 2),
                                        child: Card(
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (c) =>
                                                              ItemsPhotoPricing(
                                                                model: ApprovePricingModel(
                                                                    lotNo: data
                                                                        .lotNo,
                                                                    fgImageFileName:
                                                                        data.fgImageFileName),
                                                              )));
                                                },
                                                child: Column(
                                                  children: [
                                                    Text('${data.theme!}'),
                                                    ClipRRect(
                                                      child: CachedNetworkImage(
                                                        height: 120,
                                                        width: 130,
                                                        imageUrl: ApiConstants
                                                                .baseUrlImageMdbc +
                                                            data.fgImageFileName!
                                                                .toString(),
                                                        placeholder: (context,
                                                                url) =>
                                                            Center(
                                                                child: Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            0),
                                                                    width: 90,
                                                                    height: 90,
                                                                    child: Lottie
                                                                        .asset(
                                                                            "json/loading_black.json"))),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          "images/default.jpg",
                                                        ),
                                                        fit: BoxFit.scaleDown,
                                                      ),
                                                    ),
                                                    Text(
                                                        '${data.productTypeDesc!}')
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.50,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${data.lotNo!}  (${data.salesDefinitionCode})',
                                                    ),

                                                    Text(
                                                      'Emas         : ${data.goldWeight!}',
                                                    ),
                                                    Text(
                                                      'Diamond   : ${data.diamondWeight!}',
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      child: Text(
                                                        data.detailProduct!,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              int.parse(data.finalPrice3USD!
                                                                              .round()
                                                                              .toString())
                                                                          .bitLength >
                                                                      17
                                                                  ? Text(
                                                                      CurrencyFormat
                                                                          .convertToIdr(
                                                                              data.finalPrice3USD!,
                                                                              0),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              22,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                    )
                                                                  : Text(
                                                                      '\$ ${CurrencyFormat.convertToDollar(data.finalPrice3USD!, 0)}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              22,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                            ])),

                                                    //* button approve
                                                    Container(
                                                      height: 47,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              bottom: 5),
                                                      child:
                                                          FloatingActionButton
                                                              .extended(
                                                        onPressed: () {
                                                          final _formKey =
                                                              GlobalKey<
                                                                  FormState>();
                                                          awalPrice =
                                                              double.parse(data
                                                                  .finalPrice3USD!
                                                                  .toString());

                                                          price.text = '';
                                                          notes.text = '';
                                                          valuePrice = data
                                                              .priceAfterDiscount
                                                              .round();
                                                          hpp = int.parse(data
                                                                  .grandSTDLabourPrice!
                                                                  .round()
                                                                  .toString()) +
                                                              int.parse(data
                                                                  .stdGoldPrice!
                                                                  .round()
                                                                  .toString()) +
                                                              int.parse(data
                                                                  .grandSTDDiamondPrice!
                                                                  .round()
                                                                  .toString());

                                                          showGeneralDialog(
                                                              pageBuilder: (context,
                                                                  animation1,
                                                                  animation2) {
                                                                return const Text(
                                                                    '');
                                                              },
                                                              context: context,
                                                              transitionDuration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          200),
                                                              barrierDismissible:
                                                                  true,
                                                              barrierLabel: '',
                                                              transitionBuilder:
                                                                  (context,
                                                                          a1,
                                                                          a2,
                                                                          widget) =>
                                                                      Transform
                                                                          .scale(
                                                                        scale: a1
                                                                            .value,
                                                                        child:
                                                                            Opacity(
                                                                          opacity:
                                                                              a1.value,
                                                                          child: StatefulBuilder(
                                                                              builder: (context, setState) => AlertDialog(
                                                                                      content: Stack(clipBehavior: Clip.none, children: <Widget>[
                                                                                    // Positioned(
                                                                                    //   right: -50.0,
                                                                                    //   top: -50.0,
                                                                                    //   child: InkResponse(
                                                                                    //     onTap: () {
                                                                                    //       Navigator.of(context).pop();
                                                                                    //     },
                                                                                    //     //! Cancel
                                                                                    //     child: Transform.scale(scale: 2, child: SizedBox(height: 40, child: Lottie.asset("json/icon_delete.json"))),
                                                                                    //   ),
                                                                                    // ),
                                                                                    Form(
                                                                                      key: _formKey,
                                                                                      child: SingleChildScrollView(
                                                                                        scrollDirection: Axis.vertical,
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: <Widget>[
                                                                                            Row(
                                                                                              children: [
                                                                                                //? history iket
                                                                                                Container(
                                                                                                  decoration: BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(36), bottomLeft: Radius.circular(36)), color: Colors.grey.shade900, border: Border.all(width: 0.1, color: Colors.white)),
                                                                                                  // decoration: BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(36), bottomRight: Radius.circular(36)), border: Border.all(width: 2.5, color: Colors.green)), //! warna border saja
                                                                                                  height: 125,
                                                                                                  width: 125,
                                                                                                  child: Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      const Center(
                                                                                                          child: Text(
                                                                                                        'E-Ticketing',
                                                                                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                                      )),
                                                                                                      const Divider(
                                                                                                        color: Colors.white,
                                                                                                        thickness: 1,
                                                                                                      ),
                                                                                                      Text('${data.eticketingTargetDiamond!} Crt', style: const TextStyle(color: Colors.white)),
                                                                                                      Text('${data.eticketingTargetWeight!} Gr', style: const TextStyle(color: Colors.white)),
                                                                                                      Padding(
                                                                                                        padding: const EdgeInsets.only(left: 5),
                                                                                                        child: Align(
                                                                                                          alignment: Alignment.center,
                                                                                                          child: Text(
                                                                                                            (data.salesDefinitionCode == 'METIER' || data.salesDefinitionCode == 'BELI BERLIAN') ? 'RP. ${CurrencyFormat.convertToDollar(data.eticketingApprovalPrice, 0)}' : '\$ ${CurrencyFormat.convertToDollar(data.eticketingApprovalPrice, 0)}',
                                                                                                            textAlign: TextAlign.left,
                                                                                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                                const Padding(padding: EdgeInsetsDirectional.symmetric(horizontal: 3)),
                                                                                                //? history BRJ
                                                                                                Container(
                                                                                                  decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(36), bottomRight: Radius.circular(36)), color: Colors.grey.shade300, border: Border.all(width: 0.1, color: Colors.grey.shade500)),
                                                                                                  // decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(36), bottomLeft: Radius.circular(36)), border: Border.all(width: 2.5, color: Colors.blue)), //! warna border saja
                                                                                                  height: 125,
                                                                                                  width: 125,
                                                                                                  child: Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      const Center(
                                                                                                          child: Text(
                                                                                                        'BRJ',
                                                                                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                                      )),
                                                                                                      const Divider(
                                                                                                        color: Colors.black,
                                                                                                        thickness: 1,
                                                                                                      ),
                                                                                                      Text('${data.diamondWeight!} Crt'),
                                                                                                      Text('${data.goldWeight!} Gr'),
                                                                                                      Align(
                                                                                                        alignment: Alignment.center,
                                                                                                        child: Text(
                                                                                                          data.finalPrice3USD.toString().length > 8 ? CurrencyFormat.convertToIdr(data.finalPrice3USD, 0) : '\$ ${CurrencyFormat.convertToDollar(data.finalPrice3USD, 0)}',
                                                                                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),

                                                                                            Align(
                                                                                              alignment: Alignment.centerLeft,
                                                                                              child: Text(
                                                                                                data.finalPrice3USD.toString().length > 8 ? 'Price : ${CurrencyFormat.convertToIdr(data.finalPrice3USD, 0)}' : 'Price : \$ ${CurrencyFormat.convertToDollar(data.finalPrice3USD, 0)}',
                                                                                                textAlign: TextAlign.left,
                                                                                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                              ),
                                                                                            ),

                                                                                            const Divider(
                                                                                              thickness: 1,
                                                                                              color: Colors.black,
                                                                                            ),
                                                                                            //price
                                                                                            Stack(
                                                                                              children: [
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                                                                                                  child: TextFormField(
                                                                                                    style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                                    textInputAction: TextInputAction.next,
                                                                                                    controller: price,
                                                                                                    keyboardType: TextInputType.number,
                                                                                                    inputFormatters: <TextInputFormatter>[
                                                                                                      FilteringTextInputFormatter.digitsOnly
                                                                                                    ],
                                                                                                    onChanged: (value) {
                                                                                                      if (value.isNotEmpty) {
                                                                                                        priceApi = value;
                                                                                                        final numericValue = int.parse(value);
                                                                                                        data.finalPrice3USD.toString().length > 8
                                                                                                            ? price.value = price.value.copyWith(
                                                                                                                text: _currencyFormatterRp.format(numericValue),
                                                                                                                selection: TextSelection.collapsed(offset: _currencyFormatterRp.format(numericValue).length),
                                                                                                              )
                                                                                                            : price.value = price.value.copyWith(
                                                                                                                text: _currencyFormatterDollar.format(numericValue),
                                                                                                                selection: TextSelection.collapsed(offset: _currencyFormatterDollar.format(numericValue).length),
                                                                                                              );
                                                                                                      }
                                                                                                    },
                                                                                                    decoration: InputDecoration(
                                                                                                      hintText: "Update Price (optional)",
                                                                                                      // labelText: "Price",
                                                                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Positioned(
                                                                                                    right: 10,
                                                                                                    bottom: 2,
                                                                                                    child: Text(
                                                                                                      'Margin : $margin%',
                                                                                                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                    )),
                                                                                              ],
                                                                                            ),

                                                                                            Container(
                                                                                              alignment: Alignment.bottomRight,
                                                                                              padding: const EdgeInsets.only(right: 15),
                                                                                              child: Text(
                                                                                                '(${CurrencyFormat.convertToDollar(valuePrice, 0)} - ${CurrencyFormat.convertToDollar(hpp, 0)}) / ${CurrencyFormat.convertToDollar(valuePrice, 0)}',
                                                                                                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10, fontStyle: FontStyle.italic),
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              alignment: Alignment.bottomRight,
                                                                                              padding: const EdgeInsets.only(right: 15),
                                                                                              child: const Text(
                                                                                                '(harga jual - hpp) / harga jual',
                                                                                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10, fontStyle: FontStyle.italic),
                                                                                              ),
                                                                                            ), //notes
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: TextFormField(
                                                                                                style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                                textInputAction: TextInputAction.newline,
                                                                                                controller: notes,
                                                                                                keyboardType: TextInputType.multiline,
                                                                                                maxLines: null,
                                                                                                // onChanged: (value) {
                                                                                                //   apiNotes = value;
                                                                                                // },
                                                                                                decoration: InputDecoration(
                                                                                                  labelText: "Notes",
                                                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                                                                                ),
                                                                                              ),
                                                                                            ),

                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: SizedBox(
                                                                                                width: 250,
                                                                                                child: CustomLoadingButton(
                                                                                                    controller: btnControllerApproveBRJ,
                                                                                                    child: const Text("Approve"),
                                                                                                    onPressed: () {
                                                                                                      simpanForm(data);
                                                                                                    }),
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(height: 10),
                                                                                            //! Cancel
                                                                                            InkWell(
                                                                                              onTap: () {
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              child: Transform.scale(scale: 2, child: SizedBox(height: 40, child: Lottie.asset("json/icon_delete.json"))),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ]))),
                                                                        ),
                                                                      ));
                                                        },
                                                        icon: const Icon(
                                                          Icons.done_sharp,
                                                          color: Colors.green,
                                                        ),
                                                        label: const Text(
                                                            'Approve'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                          // By default show a loading spinner.
                        },
                      ),
                    ),
                  ],
                ),
              ),
        floatingActionButton:
            sharedPreferences!.getString("name")!.toString().toLowerCase() !=
                    'fri liandy'
                ? const SizedBox()
                : SizedBox(
                    width: 50,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        showUrlDinamis();
                      },
                      icon: Transform.scale(
                        scale: 2,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      label: const Text(''),
                    ),
                  ));
  }

  postApiWeb(var data) async {
    String token = sharedPreferences!.getString("token").toString();
    price.text.isEmpty
        ? awalPrice = awalPrice
        : awalPrice = double.parse(priceApi);
    Map<String, String> body = {
      'lot': data.lotNo.toString(),
      'kode': data.marketingCode.toString(), //total item di cart
      'harga': awalPrice.toString(),
      'detail': data.detailProduct.toString(),
      'ringSize': data.ringSize.toString(),
      'diamondQuality': data.diamondQuality.toString(),
    };
    try {
      final response = await http.post(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.POSThargaApproved),
          // Uri.parse(ApiConstants.baseUrl + ApiConstants.POSThargaApproved),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
          },
          body: body);
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        Navigator.of(context).pop();
        showCustomDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error Send data',
            description: response.body,
            dismiss: false);
      }
    } catch (e) {
      showCustomDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error Send data',
          description: '$e',
          dismiss: false);
    }
  }

  simpanForm(var data) async {
    await postApiWeb(data);
    await postApi(data.lotNo!);
    btnControllerApproveBRJ.reset();

    if (statusSendOk) {
      notif.sendNotificationTo(fcmTokensandy, 'Pricing Approved',
          'Lot ${data.lotNo} has been approved\nPrice approved : ${CurrencyFormat.convertToDollar(awalPrice, 0)}\nNotes : ${notes.text}');
      context.read<PApprovalBrj>().removesItem();
      Navigator.of(context).pop();
      refresh();
      textInput.text = '';
      searchInput = '';
      showSimpleNotification(
        const Text('Approve pricing success'),
        background: Colors.green,
        duration: const Duration(seconds: 5),
      );
    }
    // setState(() {});
  }

//method approve pricing
  postApi(lot) async {
    bool? isDinamis = sharedPreferences!.getBool('isDinamis');
    baseUrlDinamis = sharedPreferences!.getString('urlDinamis');
    price.text.isEmpty
        ? awalPrice = awalPrice
        : awalPrice = double.parse(priceApi);

    Map<String, String> headersAPI = {
      'Content-Type': 'application/json',
    };
    Map bodyApi = {
      'approvedBy': sharedPreferences!.getString('name')!,
      'approvalPrice': awalPrice,
      'ApprovedNotes': notes.text
    };
    try {
      var url = isDinamis == true
          ? '$baseUrlDinamis${ApiConstants.PUTapprovelPricing}$lot'
          : '${ApiConstants.baseUrlPricing}${ApiConstants.PUTapprovelPricing}$lot';

      final response = await http.put(Uri.parse(url),
          headers: headersAPI, body: jsonEncode(bodyApi));
      if (response.statusCode == 200) {
        statusSendOk = true;
        print(response.body);
      } else {
        // Navigator.of(context).pop();
        statusSendOk = false;
        btnControllerApproveBRJ.reset();
        print(response.body);
        showCustomDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error Send data',
            description: response.body,
            dismiss: false);
      }
    } catch (e) {
      showCustomDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error Send data',
          description: '$e',
          dismiss: false);
    }
  }

  showUrlDinamis() {
    final _formKey = GlobalKey<FormState>();
    RoundedLoadingButtonController btnController =
        RoundedLoadingButtonController();
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  content: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Positioned(
                        right: -50.0,
                        top: -50.0,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          //! Cancel
                          child: Transform.scale(
                              scale: 2,
                              child: SizedBox(
                                  height: 40,
                                  child:
                                      Lottie.asset("json/icon_delete.json"))),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  textInputAction: TextInputAction.done,
                                  controller: url,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: ApiConstants.baseUrlPricing,
                                    labelText: "Url Dinamis",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                ),
                              ),
                              Text(
                                'Example :\n ${ApiConstants.baseUrlPricing}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 250,
                                      child: CustomLoadingButton(
                                          controller: btnController,
                                          child: const Text("Save Url"),
                                          onPressed: () async {
                                            Future.delayed(
                                                    const Duration(seconds: 2))
                                                .then((value) async {
                                              setState(() {
                                                sharedPreferences?.setBool(
                                                    'isDinamis', true);

                                                sharedPreferences!.setString(
                                                    'urlDinamis', url.text);
                                                baseUrlDinamis = url.text;
                                              });
                                              btnController.success();
                                              Future.delayed(const Duration(
                                                      seconds: 1))
                                                  .then((value) {
                                                btnController.reset(); //reset
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (c) =>
                                                            const MainScreenApprovePricing()));

                                                showSimpleNotification(
                                                  const Text(
                                                      'Save database berhasil'),
                                                  // subtitle: const Text('sub'),
                                                  background: Colors.green,
                                                  duration: const Duration(
                                                      seconds: 5),
                                                );
                                              });
                                            });
                                          }),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 250,
                                      child: CustomLoadingButton(
                                          controller: btnController,
                                          child: const Text("Reset Url"),
                                          onPressed: () async {
                                            Future.delayed(
                                                    const Duration(seconds: 2))
                                                .then((value) async {
                                              setState(() {
                                                sharedPreferences?.setBool(
                                                    'isDinamis', false);
                                              });
                                              btnController.success();
                                              Future.delayed(const Duration(
                                                      seconds: 1))
                                                  .then((value) {
                                                btnController.reset(); //reset
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (c) =>
                                                            const MainScreenApprovePricing()));

                                                showSimpleNotification(
                                                  const Text(
                                                      'Reset database berhasil'),
                                                  // subtitle: const Text('sub'),
                                                  background: Colors.green,
                                                  duration: const Duration(
                                                      seconds: 5),
                                                );
                                              });
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const Text('');
        });
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       final _formKey = GlobalKey<FormState>();
    //       RoundedLoadingButtonController btnController =
    //           RoundedLoadingButtonController();
    //       return
    //       AlertDialog(
    //         content: Stack(
    //           clipBehavior: Clip.none,
    //           children: <Widget>[
    //             Positioned(
    //               right: -50.0,
    //               top: -50.0,
    //               child: InkResponse(
    //                 onTap: () {
    //                   Navigator.of(context).pop();
    //                 },
    //                 child: const CircleAvatar(
    //                   backgroundColor: Colors.red,
    //                   child: Icon(Icons.close),
    //                 ),
    //               ),
    //             ),
    //             Form(
    //               key: _formKey,
    //               child: SingleChildScrollView(
    //                 scrollDirection: Axis.vertical,
    //                 child: Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: <Widget>[
    //                     Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: TextFormField(
    //                         style: const TextStyle(
    //                             fontSize: 14,
    //                             color: Colors.black,
    //                             fontWeight: FontWeight.bold),
    //                         textInputAction: TextInputAction.done,
    //                         controller: url,
    //                         keyboardType: TextInputType.text,
    //                         decoration: InputDecoration(
    //                           hintText: "http://110.5.102.154:4000/approvals",
    //                           labelText: "Url Dinamis",
    //                           border: OutlineInputBorder(
    //                               borderRadius: BorderRadius.circular(5.0)),
    //                         ),
    //                       ),
    //                     ),
    //                     const Text(
    //                       'Example :\n http://110.5.102.154:4000/approvals',
    //                       style: TextStyle(fontSize: 12),
    //                     ),
    //                     Column(
    //                       children: [
    //                         Padding(
    //                           padding: const EdgeInsets.all(8.0),
    //                           child: SizedBox(
    //                             width: 250,
    //                             child: CustomLoadingButton(
    //                                 controller: btnController,
    //                                 child: const Text("Save Url"),
    //                                 onPressed: () async {
    //                                   Future.delayed(const Duration(seconds: 2))
    //                                       .then((value) async {
    //                                     setState(() {
    //                                       sharedPreferences?.setBool(
    //                                           'isDinamis', true);

    //                                       sharedPreferences!.setString(
    //                                           'urlDinamis', url.text);
    //                                       baseUrlDinamis = url.text;
    //                                       print('tersiman ? $baseUrlDinamis');
    //                                       print(sharedPreferences!.setString(
    //                                           'urlDinamis', url.text));
    //                                     });
    //                                     btnController.success();
    //                                     Future.delayed(
    //                                             const Duration(seconds: 1))
    //                                         .then((value) {
    //                                       btnController.reset(); //reset
    //                                       Navigator.push(
    //                                           context,
    //                                           MaterialPageRoute(
    //                                               builder: (c) =>
    //                                                   const MainScreenApprovePricing()));

    //                                       showDialog<String>(
    //                                           context: context,
    //                                           builder: (BuildContext context) =>
    //                                               const AlertDialog(
    //                                                 title: Text(
    //                                                   'Save Database Berhasil',
    //                                                 ),
    //                                               ));
    //                                     });
    //                                   });
    //                                 }),
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.all(8.0),
    //                           child: SizedBox(
    //                             width: 250,
    //                             child: CustomLoadingButton(
    //                                 controller: btnController,
    //                                 child: const Text("Reset Url"),
    //                                 onPressed: () async {
    //                                   Future.delayed(const Duration(seconds: 2))
    //                                       .then((value) async {
    //                                     setState(() {
    //                                       sharedPreferences?.setBool(
    //                                           'isDinamis', false);
    //                                     });
    //                                     btnController.success();
    //                                     Future.delayed(
    //                                             const Duration(seconds: 1))
    //                                         .then((value) {
    //                                       btnController.reset(); //reset
    //                                       Navigator.push(
    //                                           context,
    //                                           MaterialPageRoute(
    //                                               builder: (c) =>
    //                                                   const MainScreenApprovePricing()));

    //                                       showDialog<String>(
    //                                           context: context,
    //                                           builder: (BuildContext context) =>
    //                                               const AlertDialog(
    //                                                 title: Text(
    //                                                   'Reset Database Berhasil',
    //                                                 ),
    //                                               ));
    //                                     });
    //                                   });
    //                                 }),
    //                           ),
    //                         ),
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     });
  }
}
