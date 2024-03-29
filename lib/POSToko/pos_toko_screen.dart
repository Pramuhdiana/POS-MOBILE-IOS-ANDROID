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
import 'package:e_shop/qr/qr_scanner_toko.dart';
import 'package:e_shop/widgets/appbar_cart_pos_toko.dart';
import 'package:e_shop/widgets/fake_global_search_toko.dart';
import 'package:e_shop/widgets/fake_search_toko.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../api/api_services.dart';
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
  int qtyProduct = 0;
  int page = 0;
  int limit = 10;
  int statusForm = 0;
  bool isLoading = false;
  ScrollController scrollController = ScrollController();
  String newOpen = sharedPreferences!.getString("newOpenPosToko").toString();
  @override
  void initState() {
    super.initState();
    if (newOpen == 'true') {
      print('harus 1x');
      _loadFromApi();
      setState(() {
        sharedPreferences!.setString('newOpenPosToko', 'false');
      });
    }
    sharedPreferences!.setString('total_product_toko', '0');
    title = 'POS TOKO';
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (page != qtyProduct) {
          // on bottom scroll API Call until last page
          setState(() {
            limit += 5;
            DbAllitemsToko.db
                .getAllitemsTokoByForm(idtoko, page, limit, statusForm);
            print('masuk');
          });
        }
      }
    });
  }

  loadData(idToko, page, limit, statusForm) async {
    setState(() {
      isLoading = true;
    });
    await DbAllitemsToko.db
        .getAllitemsTokoByForm(idtoko, page, limit, statusForm);
    setState(() {
      isLoading = false;
    });
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });
    var apiProvider = ApiServices();
    await DbAllitemsToko.db.deleteAllitemsToko();
    try {
      await apiProvider.getAllItemsToko();
    } catch (c) {
      Fluttertoast.showToast(msg: "Failed To Load Data all items toko");
    }
    setState(() {
      isLoading = false;
    });
  }

  tokoMetier() {
    setState(() {
      isLoading = true;
    });
    print('toko : METIER');
    print('id  : 19');
    idtoko = 19; // menyimpan id toko
    toko = 'METIER'; // menyimpan nama toko
    sharedPreferences!.setString('customer_name', 'METIER');
    sharedPreferences!.setString('customer_id', '19');
    loadCartFromApiPOSTOKO();
    DbAllitemsToko.db.getAllitemsToko(idtoko);
    setState(() {
      isLoading = false;
    });
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
      qtyProduct = 0;
    });
    // await DbAllitemsToko.db.getAllitemsToko(idtoko);
    var apiProvider = ApiServices();
    await DbAllitemsToko.db.deleteAllitemsToko();
    try {
      await apiProvider.getAllItemsToko();
    } catch (c) {
      Fluttertoast.showToast(msg: "Failed To Load Data all items toko");
    }
    setState(() {
      limit = 10;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarCartToko(
        title: '$qtyProduct product ',
      ),
      body: isLoading == true
          ? Center(
              child: Container(
                  padding: const EdgeInsets.all(0),
                  width: 90,
                  height: 90,
                  child: Lottie.asset("json/loading_black.json")))
          : Column(
              children: <Widget>[
                if (sharedPreferences!.getString('customer_id').toString() !=
                    0.toString())
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: FakeSearchToko(),
                  ),
                if (sharedPreferences!.getString('customer_id').toString() ==
                    0.toString())
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: FakeGlobalSearchToko(),
                  ),
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.all(4)),
                    Expanded(
                      child: sharedPreferences!
                                  .getString('role_sales_brand')! ==
                              '3'
                          ? const SizedBox()
                          : DropdownSearch<UserModel>(
                              asyncItems: (String? filter) => getData(filter),
                              popupProps:
                                  PopupPropsMultiSelection.modalBottomSheet(
                                searchFieldProps: const TextFieldProps(
                                    decoration: InputDecoration(
                                  labelText: "Search..",
                                  prefixIcon: Icon(Icons.search),
                                  // //* fungsi add customer
                                  // suffixIcon: InkWell(
                                  //     onTap: () {
                                  //       Navigator.pop(context);
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (c) =>
                                  //                   AddCustomerEventScreen()));
                                  //     },
                                  //     child: const Icon(
                                  //       Icons.add,
                                  //       color: Colors.black,
                                  //     )),
                                  // //! end fungsi
                                )),
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
                                  print(
                                      'diskonnya  : ${item?.diskon_customer}');
                                  idtoko = item?.id; // menyimpan id toko
                                  toko = item?.name; // menyimpan nama toko
                                  sharedPreferences!.setString(
                                      'customer_name', toko.toString());
                                  sharedPreferences!.setString(
                                      'customer_id', idtoko.toString());
                                  loadCartFromApiPOSTOKO();
                                  // DbAllitemsToko.db.getAllitemsToko(idtoko);
                                  // DbAllitemsToko.db
                                  //     .getAllitemsToko(idtoko)
                                  //     .then(
                                  //   (value) {
                                  //     setState(() {
                                  //       qtyProduct = value.length;
                                  //       print(qtyProduct);
                                  //     });
                                  //   },
                                  // );
                                });
                              },
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: 'Choose customer',
                                  filled: true,
                                  fillColor: Colors.white,
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
                        items: const [
                          "PAMERAN",
                          "TITIPAN",
                          "TITIPAN SEMENTARA"
                        ],
                        onChanged: (jenisform) {
                          setState(() {
                            if (sharedPreferences!
                                    .getString('role_sales_brand') ==
                                '3') {
                              context.read<PCartToko>().clearCart();
                              print('toko : METIER');
                              print('id  : 19');
                              idtoko = 19; // menyimpan id toko
                              toko = 'METIER'; // menyimpan nama toko
                              sharedPreferences!
                                  .setString('customer_name', 'METIER');
                              sharedPreferences!.setString('customer_id', '19');
                              loadCartFromApiPOSTOKO();

                              DbAllitemsToko.db.getAllitemsTokoMetier(idtoko);
                            }

                            jenisform = jenisform;
                            if (jenisform == "TITIPAN SEMENTARA") {
                              idform = 3;
                              jenisform = "null";
                              // loadData(idtoko, page, limit, 2);
                              statusForm = 2;
                            } else if (jenisform == "PAMERAN") {
                              idform = 2;
                              jenisform = "pameran";
                              // loadData(idtoko, page, limit, 1);
                              statusForm = 1;
                            } else {
                              idform = 3;
                              jenisform = "null";
                              // loadData(idtoko, page, limit, 3);
                              statusForm = 3;
                            }
                          });
                        },
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Select type of form',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child: FutureBuilder(
                      future: DbAllitemsToko.db.getAllitemsTokoByForm(
                          idtoko, page, limit, statusForm),
                      builder: (context, AsyncSnapshot dataSnapshot) {
                        if (dataSnapshot.hasData) //if brands exists
                        {
                          if (sharedPreferences!
                                  .getString('role_sales_brand') ==
                              '3') {
                            DbAllitemsToko.db
                                .getAllitemsTokoMetier(idtoko)
                                .then((value) {
                              qtyProduct = value.length;
                            });
                          } else {
                            DbAllitemsToko.db
                                .getAllitemsTokoByForm(
                                    idtoko, page, limit, statusForm)
                                .then((value) {
                              setState(() {
                                qtyProduct = value.length;
                              });
                            });
                            // DbAllitemsToko.db
                            //     .getAllitemsToko(idtoko)
                            //     .then((value) {
                            //   qtyProduct = value.length;
                            // });
                          }

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
                                      keterangan_barang:
                                          itemsModel.keterangan_barang),
                                  idtoko: idtoko,
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
                                  child:
                                      Lottie.asset("json/loading_black.json")));
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
                  ),
                ),
              ],
            ),
      floatingActionButton: sharedPreferences!
                  .getString('customer_id')
                  .toString() ==
              0.toString()
          ? const Icon(
              Icons.disabled_by_default_outlined,
              color: Color.fromARGB(255, 243, 237, 237),
            )
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const QrScannerToko()));
              },
              backgroundColor: Colors.black,
              splashColor: Colors.white,
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: Colors.white,
              ),
            ),
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
              border: Border.all(color: Colors.black, width: 5),
              borderRadius: BorderRadius.circular(50),
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.name ?? ''),
        subtitle: Text(item?.alamat?.toString() ?? ''),
      ),
    );
  }

  loadCartFromApiPOSTOKO() async {
    String token = sharedPreferences!.getString("token").toString();

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
    }).toList();
  }
}

//  //// ADDING THE SCROLL LISTINER
//   scrollController() {
//     if (scrollController.offset >=
//             scrollController.position.maxScrollExtent &&
//         !_scrollController.position.outOfRange) {
//       setState(() {
//         print("comes to bottom $isLoading");
//         isLoading = true;

//         if (isLoading) {
//           print("RUNNING LOAD MORE");

//           pageCount = pageCount + 1;

//           addItemIntoLisT(pageCount);
//         }
//       });
//     }
//   }

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
