// ignore_for_file: avoid_print, unnecessary_import

import 'dart:async';

import 'package:collection/collection.dart';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_allitems_retur.dart';
import 'package:e_shop/database/model_allitems_retur.dart';
import 'package:e_shop/models/products.dart';
import 'package:e_shop/models/user_model.dart';
import 'package:e_shop/posRetur/pos_retur_screen_ui.dart';
import 'package:e_shop/provider/provider_cart_retur.dart';
import 'package:e_shop/widgets/appbar_cart_pos_retur.dart';
// import 'package:e_shop/widgets/fake_search_retur.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../api/api_services.dart';
import '../cartScreens/db_helper.dart';
import '../global/global.dart';

class PosReturScreen extends StatefulWidget {
  const PosReturScreen({super.key});

  @override
  State<PosReturScreen> createState() => _PosReturScreenState();
}

class _PosReturScreenState extends State<PosReturScreen> {
  DBHelper dbHelper = DBHelper();
  int idform = 0;
  int? idtoko = 99999;
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
  bool isLoading = false;
  ScrollController scrollController = ScrollController();
  String newOpen = sharedPreferences!.getString("newOpenPosRetur").toString();

  @override
  void initState() {
    super.initState();
    if (newOpen == 'true') {
      print('harus 1x');
      _loadFromApi();
      setState(() {
        sharedPreferences!.setString('newOpenPosRetur', 'false');
      });
    }
    title = 'POS RETUR';
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (page != qtyProduct) {
          // on bottom scroll API Call until last page
          limit += 5;
          DbAllitemsRetur.db.getAllitemsReturByPage(idtoko, page, limit);
        }
      }
    });
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });
    var apiProvider = ApiServices();
    await DbAllitemsRetur.db.deleteAllitemsRetur();
    try {
      await apiProvider.getAllItemsRetur();
    } catch (c) {
      Fluttertoast.showToast(msg: "Failed To Load Data all items retur");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    await DbAllitemsRetur.db.getAllitemsRetur(idtoko);
    setState(() {
      limit = 10;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarCartRetur(
        title: '$qtyProduct product ',
      ),
      body: Column(
        children: <Widget>[
          // if (sharedPreferences!.getString('customer_id').toString() !=
          //     0.toString())
          //   const Padding(
          //     padding: EdgeInsets.all(8),
          //     child: FakeSearchRetur(),
          //   ),
          Row(
            children: [
              const Padding(padding: EdgeInsets.all(4)),
              Expanded(
                child: DropdownSearch<UserModel>(
                  asyncItems: (String? filter) => getData(filter),
                  popupProps: PopupPropsMultiSelection.modalBottomSheet(
                    searchFieldProps: const TextFieldProps(
                        decoration: InputDecoration(
                      labelText: "Search..",
                      prefixIcon: Icon(Icons.search),
                    )),
                    showSelectedItems: true,
                    itemBuilder: _customPopupItemBuilderExample2,
                    showSearchBox: true,
                  ),
                  compareFn: (item, sItem) => item.id == sItem.id,
                  onChanged: (item) {
                    setState(() {
                      context.read<PCartRetur>().clearCart();
                      print('toko : ${item?.name}');
                      print('id  : ${item?.id}');
                      print('diskonnya  : ${item?.diskon_customer}');
                      idtoko = item?.id; // menyimpan id toko
                      toko = item?.name; // menyimpan nama toko
                      sharedPreferences!
                          .setString('customer_name_retur', toko.toString());
                      sharedPreferences!
                          .setString('customer_id_retur', idtoko.toString());
                      // sharedPreferences!
                      //     .setString('customer_id', idtoko.toString());
                      loadCartFromApiPOSRetur(idtoko);
                      DbAllitemsRetur.db.getAllitemsRetur(idtoko);
                    });
                  },
                  dropdownDecoratorProps: const DropDownDecoratorProps(
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
                      future: DbAllitemsRetur.db
                          .getAllitemsReturByPage(idtoko, page, limit),
                      builder: (context, AsyncSnapshot dataSnapshot) {
                        if (dataSnapshot.hasData) //if brands exists
                        {
                          DbAllitemsRetur.db
                              .getAllitemsRetur(idtoko)
                              .then((value) {
                            setState(() {
                              qtyProduct = value.length;
                            });
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
                                var itemsModel = (dataSnapshot.data[index]);

                                return PosReturUi(
                                  model: ModelAllitemsRetur(
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
          )
        ],
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

  loadCartFromApiPOSRetur(idtoko) async {
    String token = sharedPreferences!.getString("token").toString();

    var url = ApiConstants.baseUrl +
        ApiConstants.GETkeranjangreturendpoint +
        idtoko.toString();
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return (response.data as List).map((cart) {
      var existingitemcart = context
          .read<PCartRetur>()
          .getItems
          .firstWhereOrNull((element) => element.name == cart['lot']);

      print(existingitemcart);
      if (existingitemcart == null) {
        print('Inserting Cart Retur berhasil');
        context.read<PCartRetur>().addItem(
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
