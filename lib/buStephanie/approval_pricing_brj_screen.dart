// ignore_for_file: use_key_in_widget_constructors, avoid_print, use_build_context_synchronously, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/buStephanie/approve_pricing_model.dart';
import 'package:e_shop/buStephanie/main_screen_approve_pricing.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/provider/provider_waiting_brj.dart';
import 'package:e_shop/provider/provider_waiting_eticketing.dart';
import 'package:e_shop/widgets/keyboard_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    bool? isDinamis = sharedPreferences!.getBool('isDinamis');
    baseUrlDinamis = sharedPreferences!.getString('urlDinamis');
    print('is Dinamis =  $isDinamis');
    print('is base url =  $baseUrlDinamis');
    numberFocusNode.addListener(() {
      bool hasFocus = numberFocusNode.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    _getData();
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
    // print('margin price : $valuePrice');
    // print('margin hpp : $hpp');
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

        return g;
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (c) {
      return throw Exception(c);
    }
  }

  Future _getDataByModel(model) async {
    String fixModel = model.toString().substring(
        0, 9); //mengambil data hanya 9 character get data hanya 9 charackter
    print(fixModel);
    bool? isDinamis = sharedPreferences!.getBool('isDinamis');
    baseUrlDinamis = sharedPreferences!.getString('urlDinamis');
    try {
      final response = isDinamis == true
          ? await http.get(Uri.parse(
              baseUrlDinamis! + ApiConstants.GETapprovelPricingApproved))
          : await http.get(Uri.parse(ApiConstants.baseUrlPricing +
              ApiConstants.GETapprovelPricingApproved));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        var g = jsonResponse
            .map((data) => ApprovePricingModel.fromJson(data))
            .toList();
        var filterByModel = g.where((element) => element.modelItem
            .toString()
            .toLowerCase()
            .contains(fixModel.toString().toLowerCase()));

        g = filterByModel.toList();
        totalHistori = g.length;
        totalHistori <= 10 ? limitHistori = totalHistori : limitHistori = 10;
        return g;
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (c) {
      return throw Exception(c);
    }
  }

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
        print(modifiedUserData.toList());
        return modifiedUserData.toList();
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (c) {
      return throw Exception(c);
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
    print('bawah');
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
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Container(
                                    padding: const EdgeInsets.all(0),
                                    width: 90,
                                    height: 90,
                                    child: Lottie.asset(
                                        "json/loading_black.json")));
                          }
                          print(snapshot.connectionState ==
                              ConnectionState.waiting);
                          if (snapshot.data.isEmpty) {
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
                          }
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = snapshot.data![index];

                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                      onTap: () {
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
                                                                    height: 40,
                                                                    child: Lottie
                                                                        .asset(
                                                                            "json/icon_delete.json"))),
                                                          ),
                                                        ),
                                                        FutureBuilder(
                                                          future: _getDataByModel(
                                                              data.modelItem),
                                                          builder: (context,
                                                              snapshot2) {
                                                            if (snapshot2
                                                                .hasError) {
                                                              return Center(
                                                                  child: Column(
                                                                children: [
                                                                  const SizedBox(
                                                                      height:
                                                                          250),
                                                                  Lottie.asset(
                                                                      "json/loadingdata.json"),
                                                                  const Text(
                                                                    'Database OFF',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            26,
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            'Acne',
                                                                        letterSpacing:
                                                                            1.5),
                                                                  )
                                                                ],
                                                              ));
                                                            }
                                                            if (snapshot2
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return SizedBox(
                                                                height: 350,
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
                                                                      child:
                                                                          Text(
                                                                        '${data.lotNo} / ${data.marketingCode}',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'Price Per Carat',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          const Text(
                                                                              ':'),
                                                                          Text(
                                                                            'Rp.${CurrencyFormat.convertToDollar(data.pricePerCarat!, 0)}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'After Discount',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          const Text(
                                                                              ':'),
                                                                          Text(
                                                                            'Rp.${CurrencyFormat.convertToDollar(data.priceAfterDiscount!, 0)}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      thickness:
                                                                          3,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    const Center(
                                                                      child:
                                                                          Text(
                                                                        'History Approve',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            MediaQuery.of(context).size.width *
                                                                                1,
                                                                        child: Center(
                                                                            child: Container(
                                                                                padding: const EdgeInsets.all(0),
                                                                                width: 90,
                                                                                height: 90,
                                                                                child: Lottie.asset("json/loading_black.json"))),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                            if (snapshot2
                                                                .data.isEmpty) {
                                                              return SizedBox(
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
                                                                      child:
                                                                          Text(
                                                                        '${data.lotNo} / ${data.marketingCode}',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'Price Per Carat',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          const Text(
                                                                              ':'),
                                                                          Text(
                                                                            'Rp.${CurrencyFormat.convertToDollar(data.pricePerCarat!, 0)}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'After Discount',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          const Text(
                                                                              ':'),
                                                                          Text(
                                                                            'Rp.${CurrencyFormat.convertToDollar(data.priceAfterDiscount!, 0)}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      thickness:
                                                                          3,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    const Center(
                                                                      child:
                                                                          Text(
                                                                        'History Approve',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            MediaQuery.of(context).size.width *
                                                                                1,
                                                                        child: const Center(
                                                                            child:
                                                                                Text('No Data')),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              width: 2.5,
                                                                              color: Colors.black)),
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              const Text(
                                                                                'Labour',
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                              Text(
                                                                                'Rp.${CurrencyFormat.convertToDollar(int.parse(data.grandSTDLabourPrice!.round().toString()), 0)}',
                                                                                textAlign: TextAlign.left,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              const Text(
                                                                                'Emas',
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                              Text(
                                                                                'Rp.${CurrencyFormat.convertToDollar(int.parse(data.stdGoldPrice!.round().toString()), 0)}',
                                                                                textAlign: TextAlign.left,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              const Text(
                                                                                'Diamond',
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                              Text(
                                                                                'Rp.${CurrencyFormat.convertToDollar(int.parse(data.grandSTDDiamondPrice!.round().toString()), 0)}',
                                                                                textAlign: TextAlign.left,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          const Divider(
                                                                            thickness:
                                                                                3,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              const Text(
                                                                                'HPP',
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                'Rp.${CurrencyFormat.convertToDollar(hpp, 0)}',
                                                                                textAlign: TextAlign.left,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                            if (snapshot
                                                                .hasData) {
                                                              return SizedBox(
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
                                                                      child:
                                                                          Text(
                                                                        '${data.lotNo} / ${data.marketingCode}',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'Price Per Carat',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          const Text(
                                                                              ':'),
                                                                          Text(
                                                                            'Rp.${CurrencyFormat.convertToDollar(data.pricePerCarat!, 0)}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'After Discount',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          const Text(
                                                                              ':'),
                                                                          Text(
                                                                            'Rp.${CurrencyFormat.convertToDollar(data.priceAfterDiscount!, 0)}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      thickness:
                                                                          3,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    const Center(
                                                                      child:
                                                                          Text(
                                                                        'History Approve',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            MediaQuery.of(context).size.width *
                                                                                1,
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
                                                                                          snapshot2.data[i].salesDefinitionCode.toString().toLowerCase() == "parva"
                                                                                              ? Text(
                                                                                                  '\$ ${CurrencyFormat.convertToDollar(snapshot2.data[i].approvalPrice!, 0)}',
                                                                                                  style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                                )
                                                                                              : snapshot2.data[i].salesDefinitionCode.toString().toLowerCase() == "fine"
                                                                                                  ? Text(
                                                                                                      '\$ ${CurrencyFormat.convertToDollar(snapshot2.data[i].approvalPrice!, 0)}',
                                                                                                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                                    )
                                                                                                  : Text(
                                                                                                      'Rp. ${CurrencyFormat.convertToDollar(snapshot2.data[i].approvalPrice!, 0)}',
                                                                                                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                                    ),
                                                                                          Text(
                                                                                            // DateFormat('dd-MM-yyyy | HH:mm').format(DateTime.now()),
                                                                                            DateFormat('dd-MM-yyyy').format(DateTime.parse(snapshot2.data[i].approvedDate)),
                                                                                            // snapshot2.data[i].approvedDate,
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
                                                                      child:
                                                                          Text(
                                                                        'Total Repeat :' +
                                                                            totalHistori.toString(),
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              width: 2.5,
                                                                              color: Colors.black)),
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              const Text(
                                                                                'Labour',
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                              Text(
                                                                                'Rp.${CurrencyFormat.convertToDollar(int.parse(data.grandSTDLabourPrice!.round().toString()), 0)}',
                                                                                textAlign: TextAlign.left,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              const Text(
                                                                                'Emas',
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                              Text(
                                                                                'Rp.${CurrencyFormat.convertToDollar(int.parse(data.stdGoldPrice!.round().toString()), 0)}',
                                                                                textAlign: TextAlign.left,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              const Text(
                                                                                'Diamond',
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                              Text(
                                                                                'Rp.${CurrencyFormat.convertToDollar(int.parse(data.grandSTDDiamondPrice!.round().toString()), 0)}',
                                                                                textAlign: TextAlign.left,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          const Divider(
                                                                            thickness:
                                                                                3,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              const Text(
                                                                                'HPP',
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                'Rp.${CurrencyFormat.convertToDollar(hpp, 0)}',
                                                                                textAlign: TextAlign.left,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            } else if (snapshot2
                                                                .hasError) {
                                                              return SizedBox(
                                                                height: 350,
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
                                                                      child:
                                                                          Text(
                                                                        '${data.lotNo} / ${data.marketingCode}',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'Price Per Carat',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          const Text(
                                                                              ':'),
                                                                          Text(
                                                                            'Rp.${CurrencyFormat.convertToDollar(data.pricePerCarat!, 0)}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'After Discount',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          const Text(
                                                                              ':'),
                                                                          Text(
                                                                            'Rp.${CurrencyFormat.convertToDollar(data.priceAfterDiscount!, 0)}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      thickness:
                                                                          3,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    const Center(
                                                                      child:
                                                                          Text(
                                                                        'History Approve',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            MediaQuery.of(context).size.width *
                                                                                1,
                                                                        child: Center(
                                                                            child: Container(
                                                                                padding: const EdgeInsets.all(0),
                                                                                width: 90,
                                                                                height: 90,
                                                                                child: Lottie.asset("json/loading_black.json"))),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            }

                                                            return SizedBox(
                                                              height: 350,
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
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                        const Text(
                                                                            ':'),
                                                                        Text(
                                                                          'Rp.${CurrencyFormat.convertToDollar(data.pricePerCarat!, 0)}',
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
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
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                        const Text(
                                                                            ':'),
                                                                        Text(
                                                                          'Rp.${CurrencyFormat.convertToDollar(data.priceAfterDiscount!, 0)}',
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const Divider(
                                                                    thickness:
                                                                        3,
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
                                                                  Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          1,
                                                                      child: Center(
                                                                          child: Container(
                                                                              padding: const EdgeInsets.all(0),
                                                                              width: 90,
                                                                              height: 90,
                                                                              child: Lottie.asset("json/loading_black.json"))),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
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
                                                              Text(
                                                                '\$ ${CurrencyFormat.convertToDollar(data.finalPrice3USD!, 0)}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
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
                                                          RoundedLoadingButtonController
                                                              btnController =
                                                              RoundedLoadingButtonController();
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
                                                                                                          '\$ ${CurrencyFormat.convertToDollar(data.finalPrice3USD, 0)}',
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
                                                                                                'Price : \$ ${CurrencyFormat.convertToDollar(data.finalPrice3USD, 0)}',
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
                                                                                                    // focusNode: numberFocusNode,
                                                                                                    // inputFormatters: [
                                                                                                    //   FilteringTextInputFormatter.digitsOnly
                                                                                                    // ],
                                                                                                    // onChanged: (value) {
                                                                                                    //   try {
                                                                                                    //     valuePrice = int.parse(value);
                                                                                                    //   } catch (c) {
                                                                                                    //     valuePrice = data.finalPrice3USD.round();
                                                                                                    //   }

                                                                                                    //   setState(() => valuePrice);
                                                                                                    // },
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
                                                                                                    controller: btnController,
                                                                                                    child: const Text("Approve"),
                                                                                                    onPressed: () async {
                                                                                                      Future.delayed(const Duration(seconds: 2)).then((value) async {
                                                                                                        setState(() {
                                                                                                          try {
                                                                                                            postApiWeb(data);
                                                                                                          } catch (c) {
                                                                                                            showSimpleNotification(
                                                                                                              Text('Msg Err POST WEB : $c'),
                                                                                                              // subtitle: const Text('sub'),
                                                                                                              background: Colors.red,
                                                                                                              duration: const Duration(seconds: 10),
                                                                                                            );
                                                                                                          }
                                                                                                          try {
                                                                                                            postApi(data.lotNo!);
                                                                                                          } catch (c) {
                                                                                                            showSimpleNotification(
                                                                                                              Text('Msg Err Dekstop: $c'),
                                                                                                              // subtitle: const Text('sub'),
                                                                                                              background: Colors.red,
                                                                                                              duration: const Duration(seconds: 10),
                                                                                                            );
                                                                                                          }

                                                                                                          notif.sendNotificationTo(fcmTokensandy, 'Pricing Approved', 'Lot ${data.lotNo} has been approved\nPrice approved : ${CurrencyFormat.convertToDollar(awalPrice, 0)}\nNotes : ${notes.text}');
                                                                                                          context.read<PApprovalBrj>().removesItem();
                                                                                                        });
                                                                                                        btnController.success();
                                                                                                        Future.delayed(const Duration(seconds: 1)).then((value) {
                                                                                                          btnController.reset(); //reset
                                                                                                          Navigator.of(context).pop();
                                                                                                          setState(() {
                                                                                                            refresh();
                                                                                                            textInput.text = '';
                                                                                                            searchInput = '';
                                                                                                          });
                                                                                                          showSimpleNotification(
                                                                                                            const Text('Approve pricing success'),
                                                                                                            background: Colors.green,
                                                                                                            duration: const Duration(seconds: 5),
                                                                                                          );
                                                                                                        });
                                                                                                      });
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
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          // By default show a loading spinner.
                          return Center(
                              child: Container(
                                  padding: const EdgeInsets.all(0),
                                  width: 90,
                                  height: 90,
                                  child:
                                      Lottie.asset("json/loading_black.json")));
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
    print('entryNo : ${data.entryNo}');
    print('jobOrder : ${data.jobOrder}');
    print('marketingCode : ${data.marketingCode}');
    print('lotNo : ${data.lotNo}');
    print('modelItem : ${data.modelItem}');
    print('productTypeCode : ${data.productTypeCode}');
    print('productTypeDesc : ${data.productTypeDesc}');
    print('ringSize : ${data.ringSize}');
    print('detailProduct : ${data.detailProduct}');
    print('designLabourCode : ${data.designLabourCode}');
    print('salesDefinitionCode : ${data.salesDefinitionCode}');
    print('salesDefinitionNo : ${data.salesDefinitionNo}');
    print('sumAddition : ${data.sumAddition}');
    print('diamondWeight : ${data.diamondWeight}');
    print('goldContent : ${data.goldContent}');
    print('metalCode : ${data.metalCode}');
    print('fgWeight : ${data.fgWeight}');
    print('goldWeight : ${data.goldWeight}');
    print('goldUnitCost : ${data.goldUnitCost}');
    print('goldMF : ${data.goldMF}');
    print('stdGoldPrice : ${data.stdGoldPrice}');
    print('mfGoldPrice : ${data.mfGoldPrice}');
    print('mfDiamondPrice : ${data.mfDiamondPrice}');
    print('mfLabourPrice : ${data.mfLabourPrice}');
    print('finalMF : ${data.finalMF}');
    print('otherPrice : ${data.otherPrice}');
    print('finalPrice3USD : ${data.finalPrice3USD}');
    print('rateUSD : ${data.rateUSD}');
    print('discountPercentage : ${data.discountPercentage}');
    print('goldAveragePrice : ${data.goldAveragePrice}');
    print('priceAfterDiscount : ${data.priceAfterDiscount}');
    print('pricePerCarat : ${data.pricePerCarat}');
    print('cadImageFileName : ${data.cadImageFileName}');
    print('fgImageFileName : ${data.fgImageFileName}');
    print('fgImageUrlPath : ${data.fgImageUrlPath}');
    print('imagePath : ${data.imagePath}');
    print('imageBaseUrl : ${data.imageBaseUrl}');
    print('approvalStatus : ${data.approvalStatus}');
    print('approvalPrice : ${data.approvalPrice}');
    print('approvedNotes : ${data.approvedNotes}');
    print('diamondQuality : ${data.diamondQuality}');
    print('productDescription : ${data.productDescription}');
    print('repeatBRJ : ${data.repeatBRJ}');
    print('diamondPcs : ${data.diamondPcs}');
    print('grandSTDDiamondPrice : ${data.grandSTDDiamondPrice}');
    print('grandSTDLabourPrice : ${data.grandSTDLabourPrice}');
    print('createdBy : ${data.createdBy}');
    print('createdDate : ${data.createdDate}');
    print('editedDate : ${data.editedDate}');
    print('approvedBy : ${data.approvedBy}');
    print('approvedDate : ${data.approvedDate}');
  }

//method approve pricing
  postApi(lot) async {
    bool? isDinamis = sharedPreferences!.getBool('isDinamis');
    baseUrlDinamis = sharedPreferences!.getString('urlDinamis');
    price.text.isEmpty
        ? awalPrice = awalPrice
        : awalPrice = double.parse(price.text);

    print(awalPrice);
    print(notes.text);
    Map<String, String> headersAPI = {
      'Content-Type': 'application/json',
    };
    Map bodyApi = {
      'approvedBy': sharedPreferences!.getString('name')!,
      'approvalPrice': awalPrice,
      'ApprovedNotes': notes.text
    };
    var url = isDinamis == true
        ? '$baseUrlDinamis${ApiConstants.PUTapprovelPricing}$lot'
        : '${ApiConstants.baseUrlPricing}${ApiConstants.PUTapprovelPricing}$lot';
    final response = await http.put(Uri.parse(url),
        headers: headersAPI, body: jsonEncode(bodyApi));

    print(response.statusCode);
    print(response.body);
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
                                    hintText:
                                        "http://110.5.102.154:4000/approvals",
                                    labelText: "Url Dinamis",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                ),
                              ),
                              const Text(
                                'Example :\n http://110.5.102.154:4000/approvals',
                                style: TextStyle(fontSize: 12),
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
                                                print(
                                                    'tersiman ? $baseUrlDinamis');
                                                print(sharedPreferences!
                                                    .setString('urlDinamis',
                                                        url.text));
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
