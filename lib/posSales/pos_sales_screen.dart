// ignore_for_file: prefer_final_fields, unused_field, duplicate_ignore, unused_element, avoid_print

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_allitems.dart';
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/mainScreens/profile_screen.dart';
import 'package:e_shop/mainScreens/notification_screen.dart';
import 'package:e_shop/models/kode_keluarbarang.dart';
import 'package:e_shop/posSales/pos_sales_screen_ui.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:e_shop/widgets/appbar_cart_pos_sales.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../api/api_services.dart';
import '../cartScreens/db_helper.dart';
import '../global/global.dart';
import '../mainScreens/home_screen.dart';
import '../models/sales.dart';
import '../qr/qr_scanner.dart';
import '../widgets/fake_search.dart';

// ignore: must_be_immutable
class PosSalesScreen extends StatefulWidget {
  Sales? model;

  PosSalesScreen({
    super.key,
    this.model,
  });

  @override
  State<PosSalesScreen> createState() => _PosSalesScreenState();
}

class _PosSalesScreenState extends State<PosSalesScreen> {
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

    if (newOpen == 'true') {
      print('harus 1x');
      _loadFromApi();

      setState(() {
        sharedPreferences!.setString('newOpenPosSales', 'false');
      });
      // context.read<PCart>().clearCart(); //clear cart
      // loadCartFromApiPOSSALES(); //ambil data cart
    }
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (page != qtyProduct) {
          // on bottom scroll API Call until last page
          setState(() {
            limit += 5;
            DbAllitems.db.getAllitemsBtPage(page, limit);
            print('masuk');
          });
        }
      }
    });

    DbAllitems.db.getAllitems().then((value) {
      qtyProduct = value.length;
    });
    list = [];
    DbAllKodekeluarbarang.db.getAllkeluarbarang().then((listMap) {
      listMap.map((map) {
        return getDropDownWidget(map);
      }).forEach((dropDownItem) {
        list?.add(dropDownItem);
      });
      setState(() {
        print('cek');
      });
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

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });
    var apiProvider = ApiServices();
    await DbAllitems.db.deleteAllitems();
    try {
      await apiProvider.getAllItems();
    } catch (c) {
      Fluttertoast.showToast(msg: "Failed To Load Data all items");
    }
    String token = sharedPreferences!.getString("token").toString();
    _getDataSales(token);
    setState(() {
      isLoading = false;
    });
  }

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
          qtyProduct = g.length;
          print(qtyProduct);
        });
        return g;
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (c) {
      throw Exception('Unexpected error occured!');
    }
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    // await DbAllitems.db.getAllitems();
    var apiProvider = ApiServices();
    await DbAllitems.db.deleteAllitems();
    try {
      apiProvider.getAllItems();
    } catch (c) {
      Fluttertoast.showToast(msg: "Failed To Load Data all items");
    }
    setState(() {
      page = 0;
      limit = 10;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWithCartBadgeSales(
        title: '$qtyProduct product ',
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton(
                style: const TextStyle(
                    color: Colors.black, //<-- SEE HERE
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black, // <-- SEE HERE
                ),
                underline: Container(
                  height: 2,
                  color: Colors.black, //<-- SEE HERE
                ),
                focusColor: Colors.white,
                value: selectedOmzet,
                hint: const Text(
                  'Refrence code',
                  style: TextStyle(color: Colors.black),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedOmzet = value;
                    kodeRefrensi = value!;
                  });
                },
                items: list,
              ),
              ElevatedButton(onPressed: (() {
                 showSimpleNotification(
        const Text('Almost Done..'),
        // subtitle: const Text('sub'),
        background: Colors.green,
        duration: const Duration(seconds: 5),
      );
              }), child: const Text('Send all to ...')),
              Container(
                height: 50,
                padding: const EdgeInsets.only(),
                child: const FakeSearch(),
              ),
            ],
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
                      child: FutureBuilder(
                        future: kodeRefrensi == 'null'
                            ? DbAllitems.db.getAllitemsBtPage(page, limit)
                            : DbAllitems.db
                                .getAllitemsBykode(kodeRefrensi, page, limit),
                        builder:
                            (BuildContext context, AsyncSnapshot dataSnapshot) {
                          if (dataSnapshot.hasData) //if brands exists
                          {
                            kodeRefrensi == 'null'
                                ? DbAllitems.db.getAllitems().then((value) => {
                                      qtyProduct = value.length,
                                    })
                                : DbAllitems.db
                                    .getAllitemsBykode(kodeRefrensi, 0, 9999)
                                    .then((value) => {
                                          qtyProduct = value.length,
                                        });
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
                                  return SalesItemsUiDesign(
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

  Future<List<KodeKeluarbarang>> getData(filter) async {
    String token = sharedPreferences!.getString("token").toString();
    var response = await Dio().get(
      ApiConstants.baseUrl + ApiConstants.GETposSalesendpoint,
      options: Options(headers: {"Authorization": 'Bearer $token'}),
      queryParameters: {"filter": filter},
    );

    final data = response.data;
    if (data != null) {
      return KodeKeluarbarang.fromJsonList(data);
    }

    return [];
  }

  Widget _lostKodebarangkeluar(
    BuildContext context,
    KodeKeluarbarang? item,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.kode_refrensi.toString() ?? ''),
      ),
    );
  }

  //dropdwon
  DropdownMenuItem<String> getDropDownWidget(Map<String, dynamic> map) {
    return DropdownMenuItem<String>(
      value: map['kode_refrensi'],
      child: Text(map['kode_refrensi']),
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