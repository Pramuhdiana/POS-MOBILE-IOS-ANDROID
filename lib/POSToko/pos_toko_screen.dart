// ignore_for_file: avoid_print, unnecessary_import

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_shop/POSToko/pos_toko_ui.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_allitems_toko.dart';
import 'package:e_shop/database/model_allitems_toko.dart';
import 'package:e_shop/models/products.dart';
import 'package:e_shop/models/user_model.dart';
import 'package:e_shop/provider/provider_cart_toko.dart';
import 'package:e_shop/widgets/appbar_cart_pos_toko.dart';
import 'package:e_shop/widgets/fake_search_toko.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../cartScreens/db_helper.dart';
import '../global/global.dart';

class PosTokoScreen extends StatefulWidget {
  const PosTokoScreen({super.key});

  @override
  State<PosTokoScreen> createState() => _PosTokoScreenState();
}

class _PosTokoScreenState extends State<PosTokoScreen> {
  DBHelper dbHelper = DBHelper();
  int idform = 0;
  int? idtoko = 0;
  int idtokoP = 0;
  int idtokoK = 0;
  String uid = '';
  String? jenisform;
  String? toko;
  List<Products> products = [];
  Timer? debouncer;
  String query = ''; //filter
  String queryBrandId = '';
  String? title = '';

  @override
  void initState() {
    super.initState();
    title = 'POS TOKO';
  }

  Future refresh() async {
    setState(() {
      DbAllitemsToko.db.getAllitemsToko(idtoko);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 237, 237),
      appBar: AppbarCartToko(
        title: title,
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Column(
          children: <Widget>[
            if (sharedPreferences!.getString('customer_id').toString() !=
                0.toString())
              const Padding(
                padding: EdgeInsets.all(8),
                child: FakeSearchToko(),
              ),
            Row(
              children: [
                const Padding(padding: EdgeInsets.all(4)),
                Expanded(
                  child: DropdownSearch<UserModel>(
                    asyncItems: (String? filter) => getData(filter),
                    popupProps: PopupPropsMultiSelection.modalBottomSheet(
                      showSelectedItems: true,
                      itemBuilder: _customPopupItemBuilderExample2,
                      showSearchBox: true,
                    ),
                    compareFn: (item, sItem) => item.id == sItem.id,
                    onChanged: (item) {
                      setState(() {
                        context.read<PCartToko>().clearCart();
                        print('toko : ${item?.name}');
                        print('id  : ${item?.id}');
                        print('diskonnya  : ${item?.diskon_customer}');
                        idtoko = item?.id; // menyimpan id toko
                        toko = item?.name; // menyimpan nama toko

                        sharedPreferences!
                            .setString('customer_id', idtoko.toString());
                        loadCartFromApiPOSTOKO();
                        DbAllitemsToko.db.getAllitemsToko(idtoko);
                      });
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Pilih Toko',
                        filled: true,
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(padding: EdgeInsets.all(4)),
                Expanded(
                  child: DropdownSearch<String>(
                    items: const ["PAMERAN", "TITIPAN"],
                    onChanged: (text) {
                      setState(() {
                        jenisform = text;
                        if (jenisform == "TITIPAN") {
                          idform = 3;
                          jenisform = "null";
                        } else if (jenisform == "PAMERAN") {
                          idform = 2;
                          jenisform = "pameran";
                        }
                      });
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Jenis Form',
                        filled: true,
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: DbAllitemsToko.db.getAllitemsToko(idtoko),
                builder: (context, AsyncSnapshot dataSnapshot) {
                  if (dataSnapshot.hasData) //if brands exists
                  {
                    print(idtoko);
                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        var itemsModel = (dataSnapshot.data[index]);

                        return PosTokoUi(
                          model: ModelAllitemsToko(
                              id: itemsModel.id,
                              name: itemsModel.name,
                              slug: itemsModel.slug,
                              image_name: itemsModel.image_name,
                              description: itemsModel.description,
                              price: itemsModel.price,
                              category_id: itemsModel.category_id,
                              posisi_id: itemsModel.posisi_id,
                              customer_id: itemsModel.customer_id,
                              kode_refrensi: itemsModel.kode_refrensi,
                              sales_id: itemsModel.sales_id,
                              brand_id: itemsModel.brand_id,
                              qty: itemsModel.qty,
                              status_titipan: itemsModel.status_titipan,
                              keterangan_barang: itemsModel.keterangan_barang),
                          idtoko: idtoko,
                        );
                      },
                      itemCount: dataSnapshot.data.length,
                    );
                  } else if (dataSnapshot.hasError) {
                    return const CircularProgressIndicator();
                  } //if data NOT exists
                  return const CircularProgressIndicator();
                  //   }, else //if data NOT exists
                  // {
                  //   return const SliverToBoxAdapter(
                  //     child: Center(
                  //       child: Text(
                  //         "No items exists",
                  //       ),
                  //     ),
                  //   );
                  // }
                },
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (c) => const QrScanner()));
      //   },
      //   backgroundColor: Colors.blue,
      //   splashColor: Colors.white,
      //   child: const Icon(Icons.add_a_photo_outlined),
      // ),
    );
  }

  Future<List<UserModel>> getData(filter) async {
    String token = sharedPreferences!.getString("token").toString();
    var response = await Dio().get(
      ApiConstants.baseUrl + ApiConstants.GETcustomerendpoint,
      options: Options(headers: {"Authorization": 'Bearer $token'}),
      queryParameters: {"filter": filter},
    );

    final data = response.data;
    if (data != null) {
      return UserModel.fromJsonList(data);
    }

    return [];
  }

  Widget _customPopupItemBuilderExample2(
    BuildContext context,
    UserModel? item,
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
        title: Text(item?.name ?? ''), // menampilkan nama
        subtitle: Text(item?.alamat?.toString() ?? ''), // menampilkan alamat

        // leading: CircleAvatar(
        //     // this does not work - throws 404 error
        //     // backgroundImage: NetworkImage(item.avatar ?? ''),
        //     ),
      ),
    );
  }

  loadCartFromApiPOSTOKO() async {
    // setState(() {
    //   isLoading = true;
    // });

    // var apiProvider = ApiServices();
    // await apiProvider.getAllCart();

    // // wait for 2 seconds to simulate loading of data
    // await Future.delayed(const Duration(seconds: 2));

    // setState(() {
    //   isLoading = false;
    // });
    var url = ApiConstants.baseUrl +
        ApiConstants.GETkeranjangtokoendpoint +
        idtoko.toString();
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return (response.data as List).map((cart) {
      var existingitemcart = context
          .read<PCartToko>()
          .getItems
          .firstWhereOrNull((element) => element.name == cart['lot']);

      print(existingitemcart);
      if (existingitemcart == null) {
        print('Inserting Cart Toko berhasil');
        context.read<PCartToko>().addItem(
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
}


//FUNGSI KE FIRESTORE
// Expanded(
//             child: CustomScrollView(
//               slivers: [
//                 StreamBuilder(
//                   stream: FirebaseFirestore.instance
//                       .collection("allitemstoko")
//                       .where('sales_id',
//                           isEqualTo: int.parse(
//                               sharedPreferences!.getString("id")!)) //id sales
//                       .where('posisi_id', isEqualTo: 2) // posisi id
//                       .where('customer_id',
//                           isEqualTo: idtoko.toString()) //id toko
//                       .where('status_titipan',
//                           isEqualTo: jenisform) //pameran atau titipan

//                       // .where('customer_id', isEqualTo: idtoko) //int
//                       .snapshots(),
//                   builder: (context, AsyncSnapshot dataSnapshot) {
//                     if (dataSnapshot.hasData) //if brands exists
//                     {
//                       print(idform);
//                       return SliverStaggeredGrid.countBuilder(
//                         crossAxisCount: 2,
//                         staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
//                         itemBuilder: (context, index) {
//                           Items itemsModel = Items.fromJson(
//                             dataSnapshot.data.docs[index].data()
//                                 as Map<String, dynamic>,
//                           );
//                           return PosTokoUi(
//                             model: itemsModel,
//                             idtoko: idtoko,
//                           );
//                         },
//                         itemCount: dataSnapshot.data.docs.length,
//                       );
//                     } else //if data NOT exists
//                     {
//                       return const SliverToBoxAdapter(
//                         child: Center(
//                           child: Text(
//                             "No items exists",
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),