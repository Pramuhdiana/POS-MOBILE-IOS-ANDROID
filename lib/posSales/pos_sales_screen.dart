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

  @override
  void initState() {
    super.initState();
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
      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
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
                      color: Colors.blue, //<-- SEE HERE
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blue, // <-- SEE HERE
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.blue, //<-- SEE HERE
                  ),
                  focusColor: Colors.white,
                  value: selectedOmzet,
                  hint: const Text(
                    'Refrence code',
                    style: TextStyle(color: Colors.blue),
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
                // DropdownSearch<KodeKeluarbarang>(
                //   asyncItems: (String? filter) => getData(filter),
                //   popupProps: PopupPropsMultiSelection.modalBottomSheet(
                //     showSelectedItems: true,
                //     itemBuilder: _lostKodebarangkeluar,
                //     showSearchBox: true,
                //   ),
                //   compareFn: (item, sItem) =>
                //       item.kode_refrensi == sItem.kode_refrensi,
                //   onChanged: (item) {
                //     setState(() {
                //       kodeRefrensi = item.toString();
                //       // sharedPreferences!
                //       //     .setString('customer_id', idtoko.toString());
                //       // loadCartFromApiPOSTOKO();
                //       DbAllitems.db.getAllitemsBykode(kodeRefrensi);
                //     });
                //   },
                //   dropdownDecoratorProps: DropDownDecoratorProps(
                //     dropdownSearchDecoration: InputDecoration(
                //       labelText: 'Kode Keluar Barang',
                //       filled: true,
                //       fillColor:
                //           // Colors.white,
                //           Theme.of(context).inputDecorationTheme.fillColor,
                //     ),
                //   ),
                // ),
                SizedBox(
                  child: Text(
                    '${sharedPreferences!.getString("total_product_sales")} product ',
                    style: const TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                ),
                Expanded(
                  // child: CustomScrollView(
                  // slivers: [
                  // StreamBuilder<QuerySnapshot<Object?>>(
                  //   stream: FirebaseFirestore.instance
                  //       .collection('allitems')
                  //       .where('sales_id', isEqualTo: int.parse(id!))
                  //       .where('posisi_id', isEqualTo: 3)
                  //       .snapshots(),
                  // isEqualTo: sharedPreferences!.getString("uid")!)
                  child: FutureBuilder(
                    future: kodeRefrensi == 'null'
                        ? DbAllitems.db.getAllitems()
                        : DbAllitems.db.getAllitemsBykode(kodeRefrensi),
                    builder:
                        (BuildContext context, AsyncSnapshot dataSnapshot) {
                      // dataSnapshot.data.length;

                      if (dataSnapshot.hasData) //if brands exists
                      {
                        // return ListView.separated(
                        // return SliverStaggeredGrid.countBuilder(
                        // crossAxisCount: 2,
                        // staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                        // itemBuilder: ((context, index) {
                        //   var item = (dataSnapshot.data as List<Items>)[index];
                        //   return
                        //       // Column(
                        //       //   children: [
                        //       SalesItemsUiDesign(
                        //     items: Items(
                        //         id: item.id,
                        //         name: item.name,
                        //         slug: item.slug,
                        //         image_name: item.image_name,
                        //         description: item.description,
                        //         price: item.price,
                        //         category_id: item.category_id,
                        //         posisi_id: item.posisi_id,
                        //         customer_id: item.customer_id,
                        //         kode_refrensi: item.kode_refrensi,
                        //         sales_id: item.sales_id,
                        //         brand_id: item.brand_id,
                        //         qty: item.qty,
                        //         status_titipan: item.status_titipan,
                        //         keterangan_barang: item.keterangan_barang,
                        //         created_at: item.created_at,
                        //         updated_at: item.updated_at),
                        //     // ),
                        //     // SizedBox(height: 5)
                        //     // ],
                        //   );
                        // }),
                        // separatorBuilder: (context, index) {
                        //   return const Divider();
                        // },
                        // itemCount: (dataSnapshot.data as List<Items>).length);
                        // return Text('oke');
                        //display brands
                        sharedPreferences!.setString('total_product_sales',
                            dataSnapshot.data.length.toString());
                        return GridView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          // separatorBuilder: (context, index) => const Divider(
                          //   color: Colors.black12,
                          // ),
                          // return SliverStaggeredGrid.countBuilder(
                          // crossAxisCount: 2,
                          // staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                          itemBuilder: (BuildContext context, int index) {
                            // ModelAllitems itemsModel = ModelAllitems.fromJson(
                            // Items itemsModel = Items.fromJson(
                            // dataSnapshot.data.docs[index].data()
                            // as Map<String, dynamic>,
                            // );
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

                              // model: itemsModel,
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
        backgroundColor: Colors.blue,
        splashColor: Colors.white,
        child: const Icon(Icons.add_a_photo_outlined),
      ),
      // bottomNavigationBar: const MainScreen()
      //  BottomAppBar(
      //     child: ElevatedButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      //   },
      //   child: const Icon(
      //     Icons.home,
      //     color: Colors.white,
      //     size: 50,
      //   ),
      // )),
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
