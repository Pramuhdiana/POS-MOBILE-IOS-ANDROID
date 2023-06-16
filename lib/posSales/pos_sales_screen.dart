// ignore_for_file: prefer_final_fields, unused_field, duplicate_ignore

import 'package:e_shop/database/db_allitems.dart';
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/mainScreens/help_screen.dart';
import 'package:e_shop/mainScreens/notification_screen.dart';
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
  //function bottom
  // ignore: unused_field
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const HomeScreen(),
    const NotificationScreen(),
    const HelpScreen(),
  ];

  String token = sharedPreferences!.getString("token").toString();

  // Future<List<Items>> _fecthDataItems() async {
  //   final response = await http.get(
  //       Uri.parse(ApiConstants.baseUrl + ApiConstants.posSalesendpoint),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       });
  //   print(response.statusCode);
  //   print(response.body);

  //   final response2 = await http.post(
  //       Uri.parse(ApiConstants.baseUrl + ApiConstants.posSalesendpoint),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       });
  //   // print(response.statusCode);

  //   if (response.statusCode == 200) {
  //     var getItemsData = json.decode(response.body) as List;
  //     var listItems = getItemsData.map((i) => Items.fromJson(i)).toList();
  //     return listItems;
  //   } else {
  //     throw Exception('Failed to load Items');
  //   }
  // }

  // late Future<List<Items>> futureItems;

  DBHelper dbHelper = DBHelper();
  String? title = '';
  String query = '';
  List<Products> products = [];
  // List<ModelAllitems> allitems = <ModelAllitems>[];
  // List<ModelAllitems> filteredAllitems = <ModelAllitems>[];
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    // futureItems = _fecthDataItems();
    title = 'POS ${sharedPreferences!.getString("name")!}';
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
                    future: DbAllitems.db.getAllitems(),
                    builder:
                        (BuildContext context, AsyncSnapshot dataSnapshot) {
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
                          // itemCount: (dataSnapshot.data as List<Items>).length,
                          itemCount: dataSnapshot.data.length,
                          // itemCount: dataSnapshot.data.docs.length,
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
}
