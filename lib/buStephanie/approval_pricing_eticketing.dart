// ignore_for_file: use_key_in_widget_constructors, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
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

class ApprovalPricingEticketingScreen extends StatefulWidget {
  @override
  State<ApprovalPricingEticketingScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<ApprovalPricingEticketingScreen> {
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
            ? const Center(child: CircularProgressIndicator())
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
                    Expanded(
                      child: FutureBuilder(
                        future: searchInput.isEmpty
                            ? _getData()
                            : _getDataSearch(searchInput),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Lottie.asset("json/loadingdata.json"));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          print(snapshot.connectionState ==
                              ConnectionState.waiting);
                          if (snapshot.data.isEmpty) {
                            return const Center(
                              child: Text(
                                'You Have not \n\n Waiting List Pricing E-Ticketing',
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
                                  awalPrice = data.estimasiHarga!;
                                  return Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: <Widget>[
                                                    Positioned(
                                                      right: -40.0,
                                                      top: -40.0,
                                                      child: InkResponse(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const CircleAvatar(
                                                          backgroundColor:
                                                              Colors.red,
                                                          child:
                                                              Icon(Icons.close),
                                                        ),
                                                      ),
                                                    ),
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                    'Per Carat'),
                                                                Text(
                                                                  'Rp.${CurrencyFormat.convertToDollar(data.pricePerCarat!, 0)}',
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                    'After Diskon'),
                                                                Text(
                                                                  'Rp.${CurrencyFormat.convertToDollar(data.priceAfterDiskon!, 0)}',
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Divider(
                                                            thickness: 3,
                                                            color: Colors.black,
                                                          ),
                                                          //? batu1
                                                          data.qtyBatu1 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu1}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu1}',
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
                                                          data.qtyBatu1 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu2
                                                          data.qtyBatu2 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu2}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu2}',
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
                                                          data.qtyBatu2 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu3
                                                          data.qtyBatu3 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        '${data.batu3}',
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu3}',
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
                                                          data.qtyBatu3 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu4
                                                          data.qtyBatu4 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu4}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu4}',
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

                                                          data.qtyBatu4 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu5
                                                          data.qtyBatu5 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu5}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu5}',
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
                                                          data.qtyBatu5 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu6
                                                          data.qtyBatu6 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu6}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu6}',
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
                                                          data.qtyBatu6 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu7
                                                          data.qtyBatu7 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu7}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu7}',
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
                                                          data.qtyBatu7 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu8
                                                          data.qtyBatu8 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu8}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu8}',
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
                                                          data.qtyBatu8 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu9
                                                          data.qtyBatu9 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu9}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu9}',
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
                                                          data.qtyBatu9 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu10
                                                          data.qtyBatu10 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu10}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu10}',
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
                                                          data.qtyBatu10 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu11
                                                          data.qtyBatu11 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu11}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu11}',
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
                                                          data.qtyBatu11 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu12
                                                          data.qtyBatu12 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu12}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu12}',
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
                                                          data.qtyBatu12 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu13

                                                          data.qtyBatu13 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        '${data.batu13}',
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu13}',
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
                                                          data.qtyBatu13 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu14
                                                          data.qtyBatu14 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu14}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu14}',
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

                                                          data.qtyBatu14 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu15
                                                          data.qtyBatu15 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu15}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu15}',
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
                                                          data.qtyBatu15 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu16
                                                          data.qtyBatu16 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu16}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu16}',
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
                                                          data.qtyBatu16 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu17
                                                          data.qtyBatu17 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu17}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu17}',
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
                                                          data.qtyBatu17 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu18
                                                          data.qtyBatu18 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu18}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu18}',
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
                                                          data.qtyBatu18 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu19
                                                          data.qtyBatu19 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu19}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu19}',
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
                                                          data.qtyBatu19 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu20
                                                          data.qtyBatu20 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu20}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu20}',
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
                                                          data.qtyBatu20 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu21
                                                          data.qtyBatu21 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu21}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu21}',
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
                                                          data.qtyBatu21 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu22
                                                          data.qtyBatu22 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu22}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu22}',
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
                                                          data.qtyBatu22 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu23
                                                          data.qtyBatu23 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        '${data.batu23}',
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu23}',
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
                                                          data.qtyBatu23 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu24
                                                          data.qtyBatu24 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu24}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu24}',
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

                                                          data.qtyBatu24 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu25
                                                          data.qtyBatu25 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu25}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu25}',
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
                                                          data.qtyBatu25 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu26
                                                          data.qtyBatu26 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu26}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu26}',
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
                                                          data.qtyBatu26 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu27
                                                          data.qtyBatu27 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu27}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu27}',
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
                                                          data.qtyBatu27 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu28
                                                          data.qtyBatu28 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu28}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu28}',
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
                                                          data.qtyBatu28 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu29
                                                          data.qtyBatu29 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu29}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu29}',
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
                                                          data.qtyBatu29 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),

                                                          //? batu30
                                                          data.qtyBatu30 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu30}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu30}',
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
                                                          data.qtyBatu30 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu31
                                                          data.qtyBatu31 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu31}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu31}',
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
                                                          data.qtyBatu31 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu32
                                                          data.qtyBatu32 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu32}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu32}',
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
                                                          data.qtyBatu32 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu33
                                                          data.qtyBatu33 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu33}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu33}',
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
                                                          data.qtyBatu33 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu34
                                                          data.qtyBatu34 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu34}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu34}',
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
                                                          data.qtyBatu34 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          //? batu35
                                                          data.qtyBatu35 <= 0
                                                              ? const SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          '${data.batu35}',
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${data.qtyBatu35}',
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
                                                          data.qtyBatu35 <= 0
                                                              ? const SizedBox()
                                                              : const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          data.keterangan == ''
                                                              ? const SizedBox()
                                                              : Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              10),
                                                                  child: Text(
                                                                    'Note \n${data.keterangan}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: TextStyle(
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .italic,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .yellow
                                                                            .shade800),
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
                                      child: Container(
                                        height: 180,
                                        padding:
                                            const EdgeInsets.only(right: 2),
                                        child: Card(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 130,
                                                width: 130,
                                                child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 10),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (c) =>
                                                                        ItemsPhotoPricingEticketing(
                                                                          imgUrl:
                                                                              data.imageDesign1!,
                                                                          model: PricingEticketingModel(
                                                                              id: data.id,
                                                                              namaCustomer: data.namaCustomer),
                                                                        )));
                                                          },
                                                          child: ClipRRect(
                                                            child:
                                                                CachedNetworkImage(
                                                              width: 130,
                                                              imageUrl: data
                                                                  .imageDesign1!,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const CircularProgressIndicator(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.asset(
                                                                "images/default.jpg",
                                                              ),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
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
                                                                              id: data.id,
                                                                              namaCustomer: data.namaCustomer),
                                                                        )));
                                                          },
                                                          child: ClipRRect(
                                                            child:
                                                                CachedNetworkImage(
                                                              width: 130,
                                                              imageUrl: data
                                                                  .imageSales1!,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const CircularProgressIndicator(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.asset(
                                                                "images/default.jpg",
                                                              ),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Text(
                                                    //   'id :${data.diambilId!}',
                                                    // ),
                                                    Text(
                                                        'Emas         : ${data.beratEmas!}'),

                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Diamond   : ${data.beratDiamond!}'),
                                                          data.noGIA
                                                                  .toString()
                                                                  .isEmpty
                                                              ? const SizedBox()
                                                              : GestureDetector(
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
                                                                              clipBehavior: Clip.none,
                                                                              children: <Widget>[
                                                                                Positioned(
                                                                                  right: -40.0,
                                                                                  top: -40.0,
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
                                                                  child:
                                                                      const Text(
                                                                    'GIA',
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue),
                                                                  ))
                                                        ],
                                                      ),
                                                    ),

                                                    Text(data.namaSales!),
                                                    Text(data.namaCustomer!),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              '${data.jenisPengajuan!}'),
                                                          data.jenisPengajuan
                                                                      .toString()
                                                                      .toLowerCase() ==
                                                                  "baru"
                                                              ? const SizedBox()
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    showDialog<
                                                                            String>(
                                                                        context:
                                                                            context,
                                                                        builder: (BuildContext
                                                                                context) =>
                                                                            const AlertDialog(
                                                                              title: Center(child: CircularProgressIndicator()),
                                                                            ));
                                                                    _getDataByPengajuan(
                                                                            data.diambilId,
                                                                            "baru")
                                                                        .then(
                                                                      (value) {
                                                                        hargaBaru =
                                                                            value[0].estimasiHarga;
                                                                        approveHargaBaru =
                                                                            value[0].approvalHarga;
                                                                      },
                                                                    );
                                                                    _getDataByPengajuan(
                                                                            data.diambilId,
                                                                            "revisi 1")
                                                                        .then(
                                                                      (value) {
                                                                        hargaRevisi1 =
                                                                            value[0].estimasiHarga;
                                                                        approveHargaRevisi1 =
                                                                            value[0].approvalHarga;
                                                                      },
                                                                    );
                                                                    Future.delayed(const Duration(
                                                                            seconds:
                                                                                1))
                                                                        .then(
                                                                            (value) {
                                                                      Navigator
                                                                          .pop(
                                                                        context,
                                                                      );

                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              content: Stack(
                                                                                clipBehavior: Clip.none,
                                                                                children: <Widget>[
                                                                                  Positioned(
                                                                                    right: -40.0,
                                                                                    top: -40.0,
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
                                                                                            Text(
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
                                                                  child:
                                                                      const Text(
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          data.brand == "PARVA"
                                                              ? Text(
                                                                  '\$ ${CurrencyFormat.convertToDollar(awalPrice, 0)}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          22,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                )
                                                              : data.brand ==
                                                                      "FINE"
                                                                  ? Text(
                                                                      '\$ ${CurrencyFormat.convertToDollar(awalPrice, 0)}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              22,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                    )
                                                                  : Text(
                                                                      'Rp. ${CurrencyFormat.convertToDollar(awalPrice, 0)}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              22,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                    )

                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            height: 40,
                                                            child:
                                                                FloatingActionButton
                                                                    .extended(
                                                              onPressed: () {
                                                                notes1.text = data
                                                                    .notesCustomer;
                                                                notes2.text = data
                                                                    .notesCustomer2;
                                                                notes3.text = data
                                                                    .notesCustomer3;

                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      // ignore: no_leading_underscores_for_local_identifiers
                                                                      final _formKey =
                                                                          GlobalKey<
                                                                              FormState>();

                                                                      RoundedLoadingButtonController
                                                                          btnController =
                                                                          RoundedLoadingButtonController();
                                                                      return AlertDialog(
                                                                        content:
                                                                            Stack(
                                                                          clipBehavior:
                                                                              Clip.none,
                                                                          children: <Widget>[
                                                                            Positioned(
                                                                              right: -40.0,
                                                                              top: -40.0,
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
                                                                              child: Form(
                                                                                key: _formKey,
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: <Widget>[
                                                                                    Align(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        child: data.brand == "PARVA"
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
                                                                                      alignment: Alignment.bottomLeft,
                                                                                      padding: const EdgeInsets.only(top: 10),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          const Text(
                                                                                            'Budget Customer',
                                                                                            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                          ),
                                                                                          Text(
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
                                                                                    data.notesCustomer == ''
                                                                                        ? const SizedBox()
                                                                                        : Card(
                                                                                            color: Colors.white,
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(0),
                                                                                              child: TextField(
                                                                                                readOnly: true,
                                                                                                keyboardType: TextInputType.multiline,
                                                                                                focusNode: numberFocusNode,
                                                                                                maxLines: 2, //or null
                                                                                                decoration: InputDecoration(
                                                                                                  border: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                                  ),
                                                                                                  labelText: 'Note Customer',
                                                                                                  labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                                controller: notes1,
                                                                                              ),
                                                                                            )),
                                                                                    //! notes 2
                                                                                    data.notesCustomer2 == ''
                                                                                        ? const SizedBox()
                                                                                        : Card(
                                                                                            color: Colors.white,
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(top: 5),
                                                                                              child: TextField(
                                                                                                readOnly: true,
                                                                                                keyboardType: TextInputType.multiline,
                                                                                                focusNode: numberFocusNode,
                                                                                                maxLines: 2, //or null
                                                                                                decoration: InputDecoration(
                                                                                                  border: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                                  ),
                                                                                                  labelText: 'Note Customer revisi 1',
                                                                                                  labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                                controller: notes2,
                                                                                              ),
                                                                                            )),
                                                                                    //! notes 3
                                                                                    data.notesCustomer3 == ''
                                                                                        ? const SizedBox()
                                                                                        : Card(
                                                                                            color: Colors.white,
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(top: 5),
                                                                                              child: TextField(
                                                                                                readOnly: true,
                                                                                                keyboardType: TextInputType.multiline,
                                                                                                focusNode: numberFocusNode,
                                                                                                maxLines: 2, //or null
                                                                                                decoration: InputDecoration(
                                                                                                  border: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                                  ),
                                                                                                  labelText: 'Note Customer revisi 2',
                                                                                                  labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                                controller: notes3,
                                                                                              ),
                                                                                            )),

                                                                                    //notes approve
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: TextFormField(
                                                                                        autofocus: true,
                                                                                        style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                        textInputAction: TextInputAction.next,
                                                                                        keyboardType: TextInputType.text,
                                                                                        onChanged: (value) {
                                                                                          notes.text = value;
                                                                                        },
                                                                                        decoration: InputDecoration(
                                                                                          labelText: "Notes",
                                                                                          labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    //button approve
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: SizedBox(
                                                                                        width: 250,
                                                                                        child: CustomLoadingButton(
                                                                                            controller: btnController,
                                                                                            child: const Text("Approve"),
                                                                                            onPressed: () async {
                                                                                              if (_formKey.currentState!.validate()) {
                                                                                                _formKey.currentState!.save();
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
                                                                                                    awalPrice = data.estimasiHarga!;
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
                                                                                                    showDialog<String>(
                                                                                                        context: context,
                                                                                                        builder: (BuildContext context) => const AlertDialog(
                                                                                                              title: Text(
                                                                                                                'Approve pricing success',
                                                                                                              ),
                                                                                                            ));
                                                                                                  });
                                                                                                });
                                                                                              } else {
                                                                                                btnController.error();
                                                                                                Future.delayed(const Duration(seconds: 1)).then((value) {
                                                                                                  btnController.reset(); //reset
                                                                                                });
                                                                                              }
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
                                                                Icons
                                                                    .done_sharp,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              label: const Text(
                                                                  'Approve'),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              notes1.text = data
                                                                  .notesCustomer;
                                                              notes2.text = data
                                                                  .notesCustomer2;
                                                              notes3.text = data
                                                                  .notesCustomer3;
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    // ignore: no_leading_underscores_for_local_identifiers
                                                                    final _formKey =
                                                                        GlobalKey<
                                                                            FormState>();

                                                                    RoundedLoadingButtonController
                                                                        btnController =
                                                                        RoundedLoadingButtonController();
                                                                    return AlertDialog(
                                                                      content:
                                                                          Stack(
                                                                        clipBehavior:
                                                                            Clip.none,
                                                                        children: <Widget>[
                                                                          Positioned(
                                                                            right:
                                                                                -40.0,
                                                                            top:
                                                                                -40.0,
                                                                            child:
                                                                                InkResponse(
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
                                                                            scrollDirection:
                                                                                Axis.vertical,
                                                                            child:
                                                                                Form(
                                                                              key: _formKey,
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: <Widget>[
                                                                                  Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: data.brand == "PARVA"
                                                                                          ? Text(
                                                                                              'Before : \$ ${CurrencyFormat.convertToDollar(data.estimasiHarga, 0)}',
                                                                                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                            )
                                                                                          : data.brand == "FINE"
                                                                                              ? Text(
                                                                                                  'Before : \$ ${CurrencyFormat.convertToDollar(data.estimasiHarga, 0)}',
                                                                                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                                )
                                                                                              : Text(
                                                                                                  'Before : Rp. ${CurrencyFormat.convertToDollar(data.estimasiHarga, 0)}',
                                                                                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                                )),
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
                                                                                  data.notesCustomer == ''
                                                                                      ? const SizedBox()
                                                                                      : Card(
                                                                                          color: Colors.white,
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.all(0),
                                                                                            child: TextField(
                                                                                              readOnly: true,
                                                                                              keyboardType: TextInputType.multiline,
                                                                                              focusNode: numberFocusNode,
                                                                                              maxLines: 2, //or null
                                                                                              decoration: InputDecoration(
                                                                                                border: OutlineInputBorder(
                                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                                ),
                                                                                                labelText: 'Note Customer',
                                                                                                labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                              controller: notes1,
                                                                                            ),
                                                                                          )),
                                                                                  //! notes 2
                                                                                  data.notesCustomer2 == ''
                                                                                      ? const SizedBox()
                                                                                      : Card(
                                                                                          color: Colors.white,
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(top: 5),
                                                                                            child: TextField(
                                                                                              readOnly: true,
                                                                                              keyboardType: TextInputType.multiline,
                                                                                              focusNode: numberFocusNode,
                                                                                              maxLines: 2, //or null
                                                                                              decoration: InputDecoration(
                                                                                                border: OutlineInputBorder(
                                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                                ),
                                                                                                labelText: 'Note Customer revisi 1',
                                                                                                labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                              controller: notes2,
                                                                                            ),
                                                                                          )),
                                                                                  //! notes 3
                                                                                  data.notesCustomer3 == ''
                                                                                      ? const SizedBox()
                                                                                      : Card(
                                                                                          color: Colors.white,
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(top: 5),
                                                                                            child: TextField(
                                                                                              readOnly: true,
                                                                                              keyboardType: TextInputType.multiline,
                                                                                              focusNode: numberFocusNode,
                                                                                              maxLines: 2, //or null
                                                                                              decoration: InputDecoration(
                                                                                                border: OutlineInputBorder(
                                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                                ),
                                                                                                labelText: 'Note Customer revisi 2',
                                                                                                labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                              controller: notes3,
                                                                                            ),
                                                                                          )),

                                                                                  //price
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: TextFormField(
                                                                                      autofocus: true,
                                                                                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                      textInputAction: TextInputAction.next,
                                                                                      // controller:
                                                                                      //     price,
                                                                                      keyboardType: TextInputType.number,
                                                                                      focusNode: numberFocusNode,
                                                                                      inputFormatters: [
                                                                                        FilteringTextInputFormatter.digitsOnly
                                                                                      ],
                                                                                      onChanged: (value) {
                                                                                        price.text = value;
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        // hintText: "example: Cahaya Sanivokasi",
                                                                                        labelText: "Price",
                                                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                                                                      ),
                                                                                      validator: (value) {
                                                                                        if (value!.isEmpty) {
                                                                                          return 'Wajib diisi *';
                                                                                        }
                                                                                        return null;
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  //notes
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: TextFormField(
                                                                                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                      textInputAction: TextInputAction.next,
                                                                                      // controller:
                                                                                      //     price,
                                                                                      keyboardType: TextInputType.text,
                                                                                      onChanged: (value) {
                                                                                        notes.text = value;
                                                                                      },
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
                                                                                          child: const Text("Update"),
                                                                                          onPressed: () async {
                                                                                            if (_formKey.currentState!.validate()) {
                                                                                              _formKey.currentState!.save();
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
                                                                                                  awalPrice = int.parse(price.text);
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
                                                                                                  showDialog<String>(
                                                                                                      context: context,
                                                                                                      builder: (BuildContext context) => const AlertDialog(
                                                                                                            title: Text(
                                                                                                              'Update pricing success',
                                                                                                            ),
                                                                                                          ));
                                                                                                });
                                                                                              });
                                                                                            } else {
                                                                                              btnController.error();
                                                                                              Future.delayed(const Duration(seconds: 1)).then((value) {
                                                                                                btnController.reset(); //reset
                                                                                              });
                                                                                            }
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
                                                              Icons.edit,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                          // TextButton(
                                                          //   onPressed: () {},
                                                          //   child: Text('GIA'),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          //     child: ListTile(
                                          //   title: Text(data.entryNo!.toString(),
                                          //       style: const TextStyle(fontSize: 30)),
                                          //   subtitle: Text(
                                          //     data.marketingCode!.toString(),
                                          //   ),
                                          //   leading: ClipRRect(
                                          //     child: CachedNetworkImage(
                                          //       // memCacheWidth: 85, //default 45
                                          //       // memCacheHeight: 100, //default 60
                                          //       // maxHeightDiskCache: 100, //default 60
                                          //       // maxWidthDiskCache: 85, //default 45
                                          //       // imageUrl:
                                          //       //     'https://110.5.102.154:50001/Files/Images/Product/${data.fgImageFileName!.toString()}',
                                          //       imageUrl:
                                          //           'https://110.5.102.154:50001/Files/Images/Product/20100294-03.jpeg',

                                          //       placeholder: (context, url) =>
                                          //           const CircularProgressIndicator(),
                                          //       errorWidget: (context, url, error) => const Icon(
                                          //         Icons.error,
                                          //         color: Colors.black,
                                          //       ),
                                          //       fit: BoxFit.cover,
                                          //     ),
                                          //   ),
                                          // )
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          // By default show a loading spinner.
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
              ));
  }

//method approve pricing
  postApi(lot, fixPrice) async {
    Map<String, String> body = {
      'id': lot.toString(),
      'approval_harga': fixPrice.toString(),
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
    var url1 = '${ApiConstants.baseUrlPricingWeb}updatepricing';
    var url2 = '${ApiConstants.baseUrlPricingWeb}updatepricingrevisisatu';
    var url3 = '${ApiConstants.baseUrlPricingWeb}updatepricingrevisidua';
    print(url1);
    print(url2);
    print(url3);
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
      // onTap: () {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ProductDetailsScreen(proList: e)));
      // Fluttertoast.showToast(msg: "Not Available");
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (c) => ItemsDetailsScreen(
      //               model: e.model,
      //             )));
      // },
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
                          'https://parvabisnis.id/uploads/products/${e['image_name'].toString()}',
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.asset(
                        "images/noimage.png",
                      ),
                      height: 124,
                      fit: BoxFit.cover,
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
