// ignore_for_file: use_key_in_widget_constructors, avoid_print, use_build_context_synchronously, sized_box_for_whitespace

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../global/currency_format.dart';
import '../provider/provider_cart.dart';
import 'package:http/http.dart' as http;

import '../provider/provider_waiting_eticketing.dart';
import '../widgets/custom_loading.dart';
import 'approval_pricing_model_eticketing.dart';
import 'item_photo_pricing_eticketing.dart';

class DummyApprovalPricingEticketingScreen extends StatefulWidget {
  @override
  State<DummyApprovalPricingEticketingScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState extends State<DummyApprovalPricingEticketingScreen> {
  String searchInput = '';
  bool isLoading = false;
  FocusNode numberFocusNode = FocusNode();
  TextEditingController price = TextEditingController();
  TextEditingController notes = TextEditingController();
  final TextEditingController notes1 = TextEditingController();
  final TextEditingController notes2 = TextEditingController();
  final TextEditingController notes3 = TextEditingController();
  int hargaBaru = 0;
  int approveHargaBaru = 0;
  int hargaRevisi1 = 0;
  int approveHargaRevisi1 = 0;
  bool updatePrice = false;
  int awalPrice = 0;
  int apiPrice = 0;
  String apiNotes = '';
  @override
  void initState() {
    super.initState();
    _getData();
    context.read<PApprovalEticketing>().clearNotif(); //clear cart
    loadListEticketing(); //ambil data cart
  }

  // void listenToNotificationStream() =>
  //     notificationService.behaviorSubject.listen((payload) {});

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrlsandy}${ApiConstants.GETapprovelPricingEticketing}?status_approval=1'));
      // if response successful
      print(response.statusCode);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        var g = jsonResponse
            .map((data) => PricingEticketingModel.fromJson(data))
            .toList();
        return g;
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (c) {
      return throw Exception(c);
    }
  }

  Future _getDataByPengajuan(idGet, jenis) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrlsandy}${ApiConstants.GETPricingEticketing}'));
      // if response successful
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        var g = jsonResponse
            .map((data) => PricingEticketingModel.fromJson(data))
            .toList();

        var filterByDiambilId = g.where((element) =>
            element.diambilId.toString().toLowerCase() ==
            idGet.toString().toLowerCase());
        var filterByJenisPengajuan = filterByDiambilId.where((element) =>
            element.jenisPengajuan.toString().toLowerCase() ==
            jenis.toString().toLowerCase());
        // print(filterByJenisPengajuan);
        g = filterByJenisPengajuan.toList();

        isLoading = false;

        return g;
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (c) {
      return throw Exception(c);
    }
  }

  Future _getDataSearch(nama) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrlsandy}${ApiConstants.GETapprovelPricingEticketingBySearch}?status_approval=1&nama_sales=$nama'));
      // if response successful
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        var g = jsonResponse
            .map((data) => PricingEticketingModel.fromJson(data))
            .toList();
        return g;
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
    context.read<PApprovalEticketing>().clearNotif(); //clear cart
    await loadListEticketing(); //ambil data cart
    setState(() {
      isLoading = false;
    });
  }

  loadListEticketing() async {
    var url =
        '${ApiConstants.baseUrlsandy}${ApiConstants.GETapprovelPricingEticketing}?status_approval=1';
    Response response = await Dio().get(
      url,
    );
    print('bawah');
    print(response.statusCode);
    return (response.data as List).map((cart) {
      context.read<PApprovalEticketing>().addItem(
            1,
          );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,

          // leading: IconButton(
          //   icon: Image.asset(
          //     "assets/arrow.png",
          //     width: 35,
          //     height: 35,
          //   ),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: CupertinoSearchTextField(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            itemColor: Colors.black,
            // autofocus: false,
            backgroundColor: Colors.black12,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              setState(() {
                searchInput = value;
              });
            },
          ),
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
                        'Waiting for approval E-Ticketing',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: searchInput.isEmpty
                            ? _getData()
                            : _getDataSearch(searchInput),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Column(
                              children: [
                                const SizedBox(height: 250),
                                Lottie.asset("json/loadingdata.json"),
                                const Text(
                                  'Database OFF',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 26,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Acne',
                                      letterSpacing: 1.5),
                                )
                              ],
                            ));
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
                                'You Have Not \n\n Waiting List Pricing E-Ticketing',
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
                          // if (snapshot.connectionState ==
                          //     ConnectionState.waiting) {
                          //   return const Center(
                          //     child: CircularProgressIndicator(),
                          //   );
                          // }
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = snapshot.data![index];
                                  int hpp = int.parse(data.labour!) +
                                      int.parse(data.emas!) +
                                      int.parse(data.diamond!);
                                  return Column(
                                    children: [
                                      Stack(clipBehavior: Clip.none, children: [
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
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
                                                            child:
                                                                const CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              child: Icon(
                                                                  Icons.close),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <Widget>[
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
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      Text(
                                                                        'Rp.${CurrencyFormat.convertToDollar(data.pricePerCarat!, 0)}',
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
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
                                                                        'After Diskon',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      Text(
                                                                        'Rp.${CurrencyFormat.convertToDollar(data.priceAfterDiskon!, 0)}',
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                  thickness: 3,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                //? batu1
                                                                // for (var i = 0;
                                                                //     i < 30;
                                                                //     i++)
                                                                data.qtyBatu1 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu1}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu1} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu1} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu1) * data.qtyBatu1).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu1 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu2
                                                                data.qtyBatu2 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu2}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu2} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu2} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu2) * data.qtyBatu2).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu2 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu3
                                                                data.qtyBatu3 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu3}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu3} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu3} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu3) * data.qtyBatu3).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu3 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu4
                                                                data.qtyBatu4 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu4}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu4} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu4} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu4) * data.qtyBatu4).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu4 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu5
                                                                data.qtyBatu5 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu5}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu5} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu5} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu5) * data.qtyBatu5).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu5 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu6
                                                                data.qtyBatu6 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu6}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu6} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu6} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu6) * data.qtyBatu6).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu6 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu7
                                                                data.qtyBatu7 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu7}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu7} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu7} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu7) * data.qtyBatu7).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu7 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu8
                                                                data.qtyBatu8 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu8}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu8} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu8} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu8) * data.qtyBatu8).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu8 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu9
                                                                data.qtyBatu9 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu9}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu9} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu9} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu9) * data.qtyBatu9).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu9 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu10
                                                                data.qtyBatu10 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu10}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu10} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu10} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu10) * data.qtyBatu10).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu10 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu11
                                                                data.qtyBatu11 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu11}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu11} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu11} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu11) * data.qtyBatu11).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu11 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu12
                                                                data.qtyBatu12 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu12}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu12} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu12} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu12) * data.qtyBatu12).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu12 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu13

                                                                data.qtyBatu13 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu13}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu13} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu13} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu13) * data.qtyBatu13).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu13 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu14
                                                                data.qtyBatu14 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu14}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu14} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu14} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu14) * data.qtyBatu14).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu14 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu15
                                                                data.qtyBatu15 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu15}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu15} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu15} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu15) * data.qtyBatu15).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu15 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu16
                                                                data.qtyBatu16 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu16}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu16} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu16} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu16) * data.qtyBatu16).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu16 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu17
                                                                data.qtyBatu17 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu17}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu17} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu17} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu17) * data.qtyBatu17).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu17 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu18
                                                                data.qtyBatu18 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu18}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu18} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu18} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu18) * data.qtyBatu18).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu18 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu19
                                                                data.qtyBatu19 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu19}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu19} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu19} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu19) * data.qtyBatu19).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu19 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu20
                                                                data.qtyBatu20 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu20}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu20} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu20} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu20) * data.qtyBatu20).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu20 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu21
                                                                data.qtyBatu21 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu21}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu21} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu21} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu21) * data.qtyBatu21).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu21 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu22
                                                                data.qtyBatu22 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu22}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu22} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu22} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu22) * data.qtyBatu22).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu22 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu23
                                                                data.qtyBatu23 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu23}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu23} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu23} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu23) * data.qtyBatu23).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu23 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu24
                                                                data.qtyBatu24 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu24}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu24} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu24} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu24) * data.qtyBatu24).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu24 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu25
                                                                data.qtyBatu25 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu25}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu25} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu25} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu25) * data.qtyBatu25).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu25 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu26
                                                                data.qtyBatu26 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu26}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu26} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu26} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu26) * data.qtyBatu26).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu26 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu27
                                                                data.qtyBatu27 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu27}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu27} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu27} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu27) * data.qtyBatu27).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu27 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu28
                                                                data.qtyBatu28 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu28}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu28} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu28} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu28) * data.qtyBatu28).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu28 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu29
                                                                data.qtyBatu29 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu29}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu29} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu29} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu29) * data.qtyBatu29).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu29 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),

                                                                //? batu30
                                                                data.qtyBatu30 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu30}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu30} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu30} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu30) * data.qtyBatu30).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu30 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu31
                                                                data.qtyBatu31 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu31}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu31} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu31} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu31) * data.qtyBatu31).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu31 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu32
                                                                data.qtyBatu32 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu32}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu32} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu32} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu32) * data.qtyBatu32).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu32 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu33
                                                                data.qtyBatu33 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu33}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu33} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu33} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu33) * data.qtyBatu33).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu33 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu34
                                                                data.qtyBatu34 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu34}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu34} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu34} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu34) * data.qtyBatu34).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu34 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                //? batu35
                                                                data.qtyBatu35 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '${data.batu35}',
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${data.qtyBatu35} Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                '${data.caratPcsBatu35} Crt/Pcs',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                              Text(
                                                                                '${(double.parse(data.caratPcsBatu35) * data.qtyBatu35).toStringAsFixed(3)} Crt',
                                                                                textAlign: TextAlign.right,
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                data.qtyBatu35 <=
                                                                        0
                                                                    ? const SizedBox()
                                                                    : const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
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
                                                                          .only(
                                                                          top:
                                                                              10,
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              3),
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
                                                                            'Rp.${CurrencyFormat.convertToDollar(int.parse(data.labour!), 0)}',
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
                                                                            'Rp.${CurrencyFormat.convertToDollar(int.parse(data.emas!), 0)}',
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
                                                                            'Rp.${CurrencyFormat.convertToDollar(int.parse(data.diamond!), 0)}',
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
                                                                data.keterangan ==
                                                                        ''
                                                                    ? const SizedBox()
                                                                    : Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          'Note \n${data.keterangan}',
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              fontStyle: FontStyle.italic,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.yellow.shade800),
                                                                        ),
                                                                      ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Container(
                                            color: Colors.grey.shade200,
                                            height: 180,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.95,
                                            child: Row(
                                              children: [
                                                const SizedBox(
                                                  width: 150,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Emas         : ${data.beratEmas!}'),
                                                    SizedBox(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Diamond   : ${data.beratDiamond!}'),
                                                          // data.noGIA
                                                          //         .toString()
                                                          //         .isEmpty
                                                          //     ? const SizedBox()
                                                          //     :
                                                          GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Stack(
                                                                          clipBehavior:
                                                                              Clip.none,
                                                                          children: <Widget>[
                                                                            Positioned(
                                                                              right: -50.0,
                                                                              top: -50.0,
                                                                              child: InkResponse(
                                                                                onTap: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: const CircleAvatar(
                                                                                  backgroundColor: Colors.red,
                                                                                  child: Icon(Icons.close),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SingleChildScrollView(
                                                                              scrollDirection: Axis.vertical,
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: <Widget>[
                                                                                  Center(
                                                                                    child: Text(
                                                                                      '${data.noGIA!}',
                                                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  Center(
                                                                                    child: Text(
                                                                                      'Jenis ${data.jenisGIA!}',
                                                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  Align(
                                                                                    alignment: Alignment.center,
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        const Text('Diamond '),
                                                                                        Text(
                                                                                          data.caratPcsGIA!,
                                                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Align(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        const Text('Price'),
                                                                                        Text(
                                                                                          '\$ ${CurrencyFormat.convertToDollar(int.parse(data.hargaGIA!), 0)}',
                                                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 20),
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        data.keterangan!,
                                                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                        maxLines: 5,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                              child: const Text(
                                                                ' (GIA)',
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                    Text(data.namaSales!),
                                                    Container(
                                                      width: 200,
                                                      child: Text(
                                                        data.namaCustomer!,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 150,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              '${data.jenisPengajuan!}'),
                                                          // data.jenisPengajuan
                                                          //             .toString()
                                                          //             .toLowerCase() ==
                                                          //         "baru"
                                                          //     ? const SizedBox()
                                                          //     :
                                                          GestureDetector(
                                                              onTap: () {
                                                                showDialog<
                                                                        String>(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        AlertDialog(
                                                                          title:
                                                                              Center(child: Container(padding: const EdgeInsets.all(0), width: 90, height: 90, child: Lottie.asset("json/loading_black.json"))),
                                                                        ));
                                                                _getDataByPengajuan(
                                                                        data.diambilId,
                                                                        "baru")
                                                                    .then(
                                                                  (value) {
                                                                    hargaBaru =
                                                                        value[0]
                                                                            .estimasiHarga;
                                                                    approveHargaBaru =
                                                                        value[0]
                                                                            .approvalHarga;
                                                                  },
                                                                );
                                                                _getDataByPengajuan(
                                                                        data.diambilId,
                                                                        "revisi 1")
                                                                    .then(
                                                                  (value) {
                                                                    hargaRevisi1 =
                                                                        value[0]
                                                                            .estimasiHarga;
                                                                    approveHargaRevisi1 =
                                                                        value[0]
                                                                            .approvalHarga;
                                                                  },
                                                                );
                                                                Future.delayed(const Duration(
                                                                        seconds:
                                                                            1))
                                                                    .then(
                                                                        (value) {
                                                                  Navigator.pop(
                                                                    context,
                                                                  );

                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          content:
                                                                              Stack(
                                                                            clipBehavior:
                                                                                Clip.none,
                                                                            children: <Widget>[
                                                                              Positioned(
                                                                                right: -50.0,
                                                                                top: -50.0,
                                                                                child: InkResponse(
                                                                                  onTap: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: const CircleAvatar(
                                                                                    backgroundColor: Colors.red,
                                                                                    child: Icon(Icons.close),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SingleChildScrollView(
                                                                                scrollDirection: Axis.vertical,
                                                                                child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                                                                  Container(
                                                                                    alignment: Alignment.bottomLeft,
                                                                                    padding: const EdgeInsets.only(top: 10),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        const Text(
                                                                                          'Budget Customer',
                                                                                          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                        ),
                                                                                        data.budgetCustomer == ''
                                                                                            ? const Text(
                                                                                                '${0}',
                                                                                                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                              )
                                                                                            : Text(
                                                                                                '${data.budgetCustomer}',
                                                                                                style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                              ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  const Divider(
                                                                                    thickness: 1,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  Center(
                                                                                    child: Text(
                                                                                      'ID ${data.diambilId}',
                                                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  const Center(
                                                                                    child: Text(
                                                                                      'History Approve',
                                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  // hargaBaru == 0
                                                                                  //     ? const SizedBox()
                                                                                  //     :

                                                                                  Container(
                                                                                    alignment: Alignment.topLeft,
                                                                                    margin: const EdgeInsets.all(5.0),
                                                                                    padding: const EdgeInsets.all(3.0),
                                                                                    decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Approval price 1 : ${CurrencyFormat.convertToDollar(hargaBaru, 0)}',
                                                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                        Text(
                                                                                          'Approved price 1 : ${CurrencyFormat.convertToDollar(approveHargaBaru, 0)}',
                                                                                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  //harga revisi 2
                                                                                  approveHargaRevisi1 == 0
                                                                                      ? const SizedBox()
                                                                                      : Container(
                                                                                          alignment: Alignment.topLeft,
                                                                                          margin: const EdgeInsets.all(5.0),
                                                                                          padding: const EdgeInsets.all(3.0),
                                                                                          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                'Approval price 2 : ${CurrencyFormat.convertToDollar(hargaRevisi1, 0)}',
                                                                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                              Text(
                                                                                                'Approved price 2 : ${CurrencyFormat.convertToDollar(approveHargaRevisi1, 0)}',
                                                                                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                ]),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      });
                                                                });
                                                              },
                                                              child: const Text(
                                                                'History Price',
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 200,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          data.brand == "PARVA"
                                                              ? Expanded(
                                                                  child: Text(
                                                                    '\$ ${CurrencyFormat.convertToDollar(data.estimasiHarga, 0)}',
                                                                    maxLines: 2,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            22,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                )
                                                              : data.brand ==
                                                                      "FINE"
                                                                  ? Expanded(
                                                                      child:
                                                                          Text(
                                                                        '\$ ${CurrencyFormat.convertToDollar(data.estimasiHarga, 0)}',
                                                                        maxLines:
                                                                            2,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                22,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    )
                                                                  : Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Rp. ${CurrencyFormat.convertToDollar(data.estimasiHarga, 0)}.000',
                                                                        maxLines:
                                                                            2,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                22,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //? tombol approve melayang

                                        Positioned(
                                          right: 2,
                                          bottom: 0,
                                          child: Container(
                                            height: 47,
                                            width: 150,
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child:
                                                FloatingActionButton.extended(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      // ignore: no_leading_underscores_for_local_identifiers
                                                      final _formKey =
                                                          GlobalKey<
                                                              FormState>();
                                                      awalPrice = int.parse(data
                                                          .estimasiHarga!
                                                          .toString());

                                                      price.text = '';
                                                      notes.text = '';
                                                      notes1.text =
                                                          data.notesCustomer;
                                                      notes2.text =
                                                          data.notesCustomer2;
                                                      notes3.text =
                                                          data.notesCustomer3;

                                                      RoundedLoadingButtonController
                                                          btnController =
                                                          RoundedLoadingButtonController();
                                                      return AlertDialog(
                                                        content: Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: <Widget>[
                                                            Positioned(
                                                              right: -50.0,
                                                              top: -50.0,
                                                              child:
                                                                  InkResponse(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  child: Icon(
                                                                      Icons
                                                                          .close),
                                                                ),
                                                              ),
                                                            ),
                                                            SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              child: Form(
                                                                key: _formKey,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <Widget>[
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          data.notesCustomer.isEmpty
                                                                              ? const SizedBox()
                                                                              : SizedBox(
                                                                                  height: 230,
                                                                                  child: SingleChildScrollView(
                                                                                    scrollDirection: Axis.vertical,
                                                                                    child: Expanded(
                                                                                      child: Padding(
                                                                                          padding: const EdgeInsets.all(0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              BubbleSpecialThree(
                                                                                                text: '${data.notesCustomer}',
                                                                                                color: const Color.fromARGB(255, 7, 19, 27),
                                                                                                tail: true,
                                                                                                isSender: false, //true kanan
                                                                                                seen: true,
                                                                                                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                                                                                              ),
                                                                                              // Text(data.tanggal_aktivitas.toString()),
                                                                                            ],
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                          data.notesCustomer2.isEmpty
                                                                              ? const SizedBox()
                                                                              : SizedBox(
                                                                                  height: 230,
                                                                                  child: SingleChildScrollView(
                                                                                    scrollDirection: Axis.vertical,
                                                                                    child: Expanded(
                                                                                      child: Padding(
                                                                                          padding: const EdgeInsets.all(0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              BubbleSpecialThree(
                                                                                                text: '${data.notesCustomer2}',
                                                                                                color: const Color.fromARGB(255, 7, 19, 27),
                                                                                                tail: true,
                                                                                                isSender: false, //true kanan
                                                                                                seen: true,
                                                                                                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                                                                                              ),
                                                                                              // Text(data.tanggal_aktivitas.toString()),
                                                                                            ],
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                          data.notesCustomer3.isEmpty
                                                                              ? const SizedBox()
                                                                              : SizedBox(
                                                                                  height: 230,
                                                                                  child: SingleChildScrollView(
                                                                                    scrollDirection: Axis.vertical,
                                                                                    child: Expanded(
                                                                                      child: Padding(
                                                                                          padding: const EdgeInsets.all(0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              BubbleSpecialThree(
                                                                                                text: '${data.notesCustomer3}',
                                                                                                color: const Color.fromARGB(255, 7, 19, 27),
                                                                                                tail: true,
                                                                                                isSender: false, //true kanan
                                                                                                seen: true,
                                                                                                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                                                                                              ),
                                                                                              // Text(data.tanggal_aktivitas.toString()),
                                                                                            ],
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                        ],
                                                                      ),
                                                                    ),

                                                                    Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child: data.brand ==
                                                                                "PARVA"
                                                                            ? Text(
                                                                                'Price : \$ ${CurrencyFormat.convertToDollar(data.estimasiHarga, 0)}',
                                                                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              )
                                                                            : data.brand == "FINE"
                                                                                ? Text(
                                                                                    'Price : \$ ${CurrencyFormat.convertToDollar(data.estimasiHarga, 0)}',
                                                                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                  )
                                                                                : Text(
                                                                                    'Price : Rp. ${CurrencyFormat.convertToDollar(data.estimasiHarga, 0)}',
                                                                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                  )),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              10),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            'Budget Customer',
                                                                            style: TextStyle(
                                                                                fontStyle: FontStyle.italic,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          data.budgetCustomer == ''
                                                                              ? const Text(
                                                                                  '${0}',
                                                                                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                )
                                                                              : Text(
                                                                                  '${data.budgetCustomer}',
                                                                                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    //price
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          TextFormField(
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold),
                                                                        textInputAction:
                                                                            TextInputAction.next,
                                                                        controller:
                                                                            price,
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        focusNode:
                                                                            numberFocusNode,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly
                                                                        ],
                                                                        // onChanged: (value) {
                                                                        //   apiPrice = int.parse(value);
                                                                        // },
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              "Update Price (optional)",
                                                                          // labelText: "Price",
                                                                          border:
                                                                              OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    //notes
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          TextFormField(
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold),
                                                                        textInputAction:
                                                                            TextInputAction.newline,
                                                                        controller:
                                                                            notes,
                                                                        keyboardType:
                                                                            TextInputType.multiline,
                                                                        maxLines:
                                                                            null,
                                                                        // onChanged: (value) {
                                                                        //   apiNotes = value;
                                                                        // },
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              "Notes",
                                                                          border:
                                                                              OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            250,
                                                                        child: CustomLoadingButton(
                                                                            controller: btnController,
                                                                            child: const Text("Approve"),
                                                                            onPressed: () async {
                                                                              Future.delayed(const Duration(seconds: 2)).then((value) async {
                                                                                try {
                                                                                  FirebaseFirestore.instance.collection("UserTokens").doc(data.namaSales!).snapshots().listen((event) {
                                                                                    setState(() {
                                                                                      fcmTokenSales = event.get("token");
                                                                                    });
                                                                                  });
                                                                                } catch (c) {
                                                                                  print(c);
                                                                                }
                                                                                setState(() {
                                                                                  try {
                                                                                    postApi(data.id!, awalPrice);
                                                                                  } catch (c) {
                                                                                    Fluttertoast.showToast(msg: "Failed to send database,Database off");
                                                                                  }
                                                                                  try {
                                                                                    postApiWeb(data.jenisPengajuan!, data.diambilId!, data.statusApproval!, data.statusGet!);
                                                                                  } catch (c) {
                                                                                    Fluttertoast.showToast(msg: "Failed to send database web,Database off");
                                                                                  }
                                                                                  notif.sendNotificationTo(fcmTokensandy, 'Pricing Approved', 'Id ${data.diambilId} and Customer ${data.namaCustomer} has been approved\nPrice approved : ${CurrencyFormat.convertToDollar(awalPrice, 0)}\nNotes : ${notes.text}');
                                                                                  notif.sendNotificationTo(fcmTokenSales, 'Pricing Approved', 'Id ${data.diambilId} and Customer ${data.namaCustomer} has been approved\nPrice approved : ${CurrencyFormat.convertToDollar(awalPrice, 0)}\nNotes : ${notes.text}');
                                                                                  _getData();
                                                                                  context.read<PApprovalEticketing>().removesItem();
                                                                                });
                                                                                btnController.success();
                                                                                Future.delayed(const Duration(seconds: 1)).then((value) {
                                                                                  btnController.reset(); //reset
                                                                                  Navigator.of(context).pop();
                                                                                  setState(() {});
                                                                                  showDialog<String>(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) => const AlertDialog(
                                                                                            title: Text(
                                                                                              'Approve pricing success',
                                                                                            ),
                                                                                          ));
                                                                                });
                                                                              });
                                                                            }),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              },
                                              icon: const Icon(
                                                Icons.done_sharp,
                                                color: Colors.green,
                                              ),
                                              label: const Text('Approve'),
                                            ),
                                          ),
                                        ),

                                        //? gambar melayang
                                        Positioned(
                                          top: -15.0,
                                          left: 15,
                                          child: InkResponse(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: SizedBox(
                                              height: 150,
                                              width: 130,
                                              child: ListView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (c) =>
                                                                      ItemsPhotoPricingEticketing(
                                                                        imgUrl:
                                                                            data.imageDesign1,
                                                                        model: PricingEticketingModel(
                                                                            id: data
                                                                                .id,
                                                                            namaCustomer:
                                                                                data.namaCustomer),
                                                                      )));
                                                        },
                                                        child: ClipRRect(
                                                          child:
                                                              CachedNetworkImage(
                                                            width: 130,
                                                            imageUrl: data
                                                                .imageDesign1!,
                                                            placeholder: (context, url) => Center(
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
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                              "images/default.jpg",
                                                            ),
                                                            //     const Icon(
                                                            //   Icons.error,
                                                            //   color: Colors
                                                            //       .black,
                                                            //   size: 50,
                                                            // ),
                                                            fit: BoxFit
                                                                .scaleDown,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (c) =>
                                                                      ItemsPhotoPricingEticketing(
                                                                        imgUrl:
                                                                            data.imageSales1!,
                                                                        model: PricingEticketingModel(
                                                                            id: data
                                                                                .id,
                                                                            namaCustomer:
                                                                                data.namaCustomer),
                                                                      )));
                                                        },
                                                        child: ClipRRect(
                                                          child:
                                                              CachedNetworkImage(
                                                            width: 130,
                                                            imageUrl: data
                                                                .imageSales1!,
                                                            placeholder: (context, url) => Center(
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
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                              "images/default.jpg",
                                                            ),
                                                            //     const Icon(
                                                            //   Icons.error,
                                                            //   color: Colors
                                                            //       .black,
                                                            //   size: 50,
                                                            // ),
                                                            fit: BoxFit
                                                                .scaleDown,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      //? space dari card to card
                                      const SizedBox(
                                        height: 25,
                                      )
                                    ],
                                  );
                                });
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          // By default show a loading spinner.
                          return Center(
                              child: Center(
                                  child: Container(
                                      padding: const EdgeInsets.all(0),
                                      width: 90,
                                      height: 90,
                                      child: Lottie.asset(
                                          "json/loading_black.json"))));
                        },
                      ),
                    ),
                  ],
                ),
              ));
  }

//method approve pricing
  postApi(lot, fixPrice) async {
    price.text.isEmpty
        ? awalPrice = awalPrice
        : awalPrice = int.parse(price.text);

    print(awalPrice);
    print(notes.text);
    Map<String, String> body = {
      'id': lot.toString(),
      'approval_harga': awalPrice.toString(),
      'note_approve': notes.text,
    };
    final response = await http.post(
        Uri.parse(
            '${ApiConstants.baseUrlsandy}${ApiConstants.UPDATEapprovalPricingEticketing}'),
        body: body);
    print(response.body);
  }

  //method approve pricing
  postApiWeb(jenisPengajuan, diambilId, statusApproval, statusGet) async {
    price.text.isEmpty
        ? awalPrice = awalPrice
        : awalPrice = int.parse(price.text);
    print(awalPrice);
    print(notes.text);

    Map<String, String> body = {
      'diambil_id': diambilId.toString(),
      'status_approval': statusApproval.toString(),
      'status_get': statusGet.toString(),
      'approval_harga': awalPrice.toString(),
      'note_approve': notes.text.toString(),
    };
    if (jenisPengajuan.toString().toLowerCase() == 'baru') {
      var url = '${ApiConstants.baseUrlPricingWeb}/updatepricing';
      print(url);
      final response = await http.post(Uri.parse(url), body: body);
      print(response.body);
    } else if (jenisPengajuan.toString().toLowerCase() == 'revisi 1') {
      var url = '${ApiConstants.baseUrlPricingWeb}/updatepricingrevisisatu';
      print(url);
      final response = await http.post(Uri.parse(url), body: body);
      print(response.body);
    } else {
      var url = '${ApiConstants.baseUrlPricingWeb}/updatepricingrevisidua';
      print(url);
      final response = await http.post(Uri.parse(url), body: body);
      print(response.body);
    }
  }
}

class SearchModel extends StatelessWidget {
  final dynamic e;
  const SearchModel({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          height: 100,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CachedNetworkImage(
                      imageUrl:
                          '${ApiConstants.baseImageUrl}${e['image_name'].toString()}',
                      placeholder: (context, url) => Center(
                          child: Container(
                              padding: const EdgeInsets.all(0),
                              width: 90,
                              height: 90,
                              child: Lottie.asset("json/loading_black.json"))),
                      errorWidget: (context, url, error) => Image.asset(
                        "images/noimage.png",
                      ),
                      height: 124,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(
                            e['name'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '\$ ${e['price']}',
                            overflow: TextOverflow.ellipsis,
                            // maxLines: 2,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    var existingitemcart = context
                        .read<PCart>()
                        .getItems
                        .firstWhereOrNull(
                            (element) => element.name == e['name'].toString());
                    //cart API
                    print(existingitemcart);
                    // existingitemcart == null
                    if (existingitemcart == null) {
                      String token =
                          sharedPreferences!.getString("token").toString();

                      //add cart API
                      Map<String, String> body = {
                        // 'user_id': id.toString(),
                        'product_id': e['id'].toString(),
                        'qty': '1',
                        'price': e['price'].toString(),
                        'jenisform_id': '3',
                        'update_by': '1'
                      };
                      final response = await http.post(
                          Uri.parse(ApiConstants.baseUrl +
                              ApiConstants.POSTkeranjangsalesendpoint),
                          headers: <String, String>{
                            'Authorization': 'Bearer $token',
                          },
                          body: body);
                      print(response.statusCode);

                      Fluttertoast.showToast(
                          msg: "Barang Berhasil Di Tambahkan");
                      context.read<PCart>().addItem(
                            e['name'].toString(),
                            int.parse(e['price'].toString()),
                            1,
                            e['image_name'].toString(),
                            e['id'].toString(),
                            e['sales_id'].toString(),
                            e['description'].toString(),
                            e['keterangan_barang'].toString(),
                          );
                    } else {
                      Fluttertoast.showToast(
                          msg: "Barang Sudah Ada Di Keranjang");
                    }
                  },
                  hoverColor: Colors.green,
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
