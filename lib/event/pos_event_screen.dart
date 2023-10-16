// ignore_for_file: prefer_final_fields, unused_field, duplicate_ignore, unused_element, avoid_print

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/event/appbar_cart_event.dart';
import 'package:e_shop/event/pos_event_screen_ui.dart';
import 'package:http/http.dart' as http;
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/event/event_search.dart';
import 'package:e_shop/mainScreens/profile_screen.dart';
import 'package:e_shop/mainScreens/notification_screen.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../cartScreens/db_helper.dart';
import '../global/global.dart';
import '../mainScreens/home_screen.dart';
import '../models/sales.dart';
import '../qr/qr_scanner.dart';

// ignore: must_be_immutable
class PosEventScreen extends StatefulWidget {
  Sales? model;

  PosEventScreen({
    super.key,
    this.model,
  });

  @override
  State<PosEventScreen> createState() => _PosEventScreenState();
}

class _PosEventScreenState extends State<PosEventScreen> {
  List<DropdownMenuItem<String>>? list;
  //function bottom
  // ignore: unused_field
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const HomeScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  String token = sharedPreferences!.getString("token").toString();

  DBHelper dbHelper = DBHelper();
  String? title = '';
  String query = '';
  String? selectedOmzet;
  String kodeRefrensi = 'null';
  bool isLoading = false;
  int? qtyProduct = 0;
  int page = 0;
  int limit = 10;
  ScrollController scrollController = ScrollController();
  String newOpen = sharedPreferences!.getString("newOpenPosSales").toString();

  @override
  void initState() {
    super.initState();
    futureData = _getAllData(page, limit);
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (page != qtyProduct) {
          print('getNewData');
          limit += 5;
          futureData = _getAllData(page, limit);
        }
      }
    });
  }

  Future<List<ModelAllitems>> _getAllData(page, limit) async {
    String? tokens = sharedPreferences!.getString('token');
    final response = await http.get(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.GETposSalesendpoint),
        headers: {"Authorization": "Bearer $tokens"});
    print('status : ${response.statusCode}');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var qtyData =
          jsonResponse.map((data) => ModelAllitems.fromJson(data)).toList();

      var allData =
          jsonResponse.map((data) => ModelAllitems.fromJson(data)).toList();
      var getLimit = allData.getRange(page, limit);
      allData = getLimit.toList();
      setState(() {
        qtyProduct = qtyData.length;
        isLoading = false;
      });
      return allData;
    } else {
      throw Fluttertoast.showToast(msg: "Database Off");
    }
  }

  late Future<List<ModelAllitems>> futureData;

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

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2)).then((value) {
      //! lalu eksekusi fungsi ini
      setState(() {
        page = 0;
        limit = 10;
        futureData = _getAllData(page, limit);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWithCartBadgeEvent(
        title: '$qtyProduct product ',
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: 50,
            padding: const EdgeInsets.only(),
            child: const EventSearch(),
          ),
          Expanded(
              child: isLoading == true
                  ? Center(
                      child: Container(
                          padding: const EdgeInsets.all(0),
                          width: 90,
                          height: 90,
                          child: Lottie.asset("json/loading_black.json")))
                  : RefreshIndicator(
                      onRefresh: refresh,
                      child: FutureBuilder<List<ModelAllitems>>(
                        // future:  DbAllitems.db.getAllitemsBtPage(page, limit),
                        future: futureData,
                        builder:
                            (BuildContext context, AsyncSnapshot dataSnapshot) {
                          if (dataSnapshot.hasData) //if brands exists
                          {
                            return SingleChildScrollView(
                              controller: scrollController,
                              child: StaggeredGridView.countBuilder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: dataSnapshot.data.length,
                                crossAxisCount: 2,
                                staggeredTileBuilder: (context) =>
                                    const StaggeredTile.fit(1),
                                itemBuilder: (BuildContext context, int index) {
                                  sharedPreferences!.setString(
                                      'total_product_sales',
                                      dataSnapshot.data.length.toString());
                                  var item = (dataSnapshot.data[index]);
                                  return EventItemsUiDesign(
                                    model: ModelAllitems(
                                        id: item.id,
                                        name: item.name,
                                        slug: item.slug,
                                        image_name: item.image_name,
                                        description: item.description,
                                        price: item.price,
                                        category_id: item.category_id,
                                        posisi_id: item.posisi_id,
                                        customer_id: item.customer_id,
                                        kode_refrensi: item.kode_refrensi,
                                        sales_id: item.sales_id,
                                        brand_id: item.brand_id,
                                        qty: item.qty,
                                        status_titipan: item.status_titipan,
                                        keterangan_barang:
                                            item.keterangan_barang),
                                  );
                                },
                              ),
                            );
                          } else if (dataSnapshot.hasError) {
                            return Center(
                                child: Container(
                                    padding: const EdgeInsets.all(0),
                                    width: 90,
                                    height: 90,
                                    child: Lottie.asset(
                                        "json/loading_black.json")));
                          } //if data NOT exists
                          return Center(
                              child: Container(
                                  padding: const EdgeInsets.all(0),
                                  width: 90,
                                  height: 90,
                                  child:
                                      Lottie.asset("json/loading_black.json")));
                        },
                      ),
                    ))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const QrScanner()));
        },
        backgroundColor: Colors.black,
        splashColor: Colors.black,
        child: const Icon(
          Icons.add_a_photo_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}

// var items_number = 10 ;

//     return NotificationListener<ScrollNotification>(
//          onNotification: (scrollNotification){
//               if(scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent){
//                  setState(() {
//                     items_number += 10 ;
//                  });    
//               }
//          },
//          child: GridView.builder(