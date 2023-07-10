// ignore_for_file: prefer_final_fields, unused_field, duplicate_ignore, unused_element, avoid_print

import 'package:dio/dio.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_allitems.dart';
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/mainScreens/help_screen.dart';
import 'package:e_shop/mainScreens/notification_screen.dart';
import 'package:e_shop/models/kode_keluarbarang.dart';
import 'package:e_shop/posSales/pos_sales_screen_ui.dart';
import 'package:flutter/material.dart';

import '../cartScreens/db_helper.dart';
import '../global/global.dart';
import '../mainScreens/home_screen.dart';
import '../models/products.dart';
import '../models/sales.dart';
import '../qr/qr_scanner.dart';
import '../widgets/appbar_cart_pos_sales.dart';
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
    const HelpScreen(),
  ];

  String token = sharedPreferences!.getString("token").toString();

  DBHelper dbHelper = DBHelper();
  String? title = '';
  String query = '';
  String? selectedOmzet;
  String kodeRefrensi = 'null';
  List<Products> products = [];
  var isLoading = false;
  int? qtyProduct = 0;

  @override
  void initState() {
    super.initState();
    DbAllitems.db.getAllitems().then((value) {
      setState(() {
        qtyProduct = value.length;
      });
    });
    title = 'POS ${sharedPreferences!.getString("name")!}';
    list = [];
    DbAllKodekeluarbarang.db.getAllkeluarbarang().then((listMap) {
      listMap.map((map) {
        print(map.toString());
        return getDropDownWidget(map);
      }).forEach((dropDownItem) {
        list?.add(dropDownItem);
      });
      setState(() {});
    });
  }

  Future refresh() async {
    setState(() {
      DbAllitems.db.getAllitems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWithCartBadgeSales(
        title: title,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: refresh,
              child: Column(children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FakeSearch(),
                ),
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
                    print(value);
                    setState(() {
                      selectedOmzet = value;
                      kodeRefrensi = value!;
                    });
                  },
                  items: list,
                ),
                SizedBox(
                  child: Text(
                    '$qtyProduct product ',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: kodeRefrensi == 'null'
                        ? DbAllitems.db.getAllitems()
                        : DbAllitems.db.getAllitemsBykode(kodeRefrensi),
                    builder:
                        (BuildContext context, AsyncSnapshot dataSnapshot) {
                      if (dataSnapshot.hasData) //if brands exists
                      {
                        kodeRefrensi == 'null'
                            ? DbAllitems.db
                                .getAllitems()
                                .then((value) => {qtyProduct = value.length})
                            : DbAllitems.db
                                .getAllitemsBykode(kodeRefrensi)
                                .then((value) => {
                                      setState(
                                        () {
                                          qtyProduct = value.length;
                                        },
                                      )
                                    });
                        return GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            sharedPreferences!.setString('total_product_sales',
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
                                  keterangan_barang: item.keterangan_barang),
                            );
                          },
                          itemCount: dataSnapshot.data.length,
                        );
                      } else if (dataSnapshot.hasError) {
                        return const CircularProgressIndicator();
                      } //if data NOT exists
                      return const CircularProgressIndicator();
                    },
                  ),
                  // ],
                  // ),
                )
              ]),
            ),
      // ),
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
        title: Text(item?.kode_refrensi.toString() ?? ''), // menampilkan nama
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
