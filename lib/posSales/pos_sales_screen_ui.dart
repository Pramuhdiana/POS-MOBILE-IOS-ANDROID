// ignore_for_file: use_build_context_synchronously, avoid_print, invalid_use_of_protected_member, unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_allitems.dart';
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/global/currency_format.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/posSales/main_posSales_screen.dart';
import 'package:e_shop/provider/provider_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../cartScreens/db_helper.dart';
import '../itemsScreens/items_details_screen.dart';
import '../provider/provider_cart.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
// import 'package:auto_reload/auto_reload.dart';

import 'pos_sales_screen.dart';

// ignore: must_be_immutable
class SalesItemsUiDesign extends StatefulWidget {
  // Items? model;
  ModelAllitems? model;
  // final Items? items;
  BuildContext? context;

  SalesItemsUiDesign({super.key, this.model, this.context});

  @override
  State<SalesItemsUiDesign> createState() => _SalesItemsUiDesign();
  // const SalesItemsUiDesign({required this.model});
}

class _SalesItemsUiDesign extends State<SalesItemsUiDesign> {
  var isLoading = false;
  int num = 0;
  DBHelper dbHelper = DBHelper();
  // static final customCacheManager = CacheManager(Config(
  //   'customCacheKey',
  //   stalePeriod: const Duration(days: 1), //menyimpan cache gambar 1 hari
  //   maxNrOfCacheObjects: 100,
  // ));

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => ItemsDetailsScreen(
                            model: widget.model,
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Stack(children: <Widget>[
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Container(
                          width: 150,
                          constraints: const BoxConstraints(
                              minHeight: 150, maxHeight: 250),
                          // child: Image(
                          //   image: NetworkImage(
                          //     'https://parvabisnis.id/uploads/products/${widget.model!.image_name.toString()}',
                          //   ),
                          // ),
                          child: CachedNetworkImage(
                            // cacheManager: customCacheManager,
                            memCacheWidth: 85, //default 45
                            memCacheHeight: 100, //default 60
                            maxHeightDiskCache: 100, //default 60
                            maxWidthDiskCache: 85, //default 45
                            imageUrl:
                                'https://parvabisnis.id/uploads/products/${widget.model!.image_name.toString()}',
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.black,
                            ),
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      //menambahkan icon kanan atas

                      Positioned(
                        top: 1,
                        right: 1,
                        child: IconButton(
                          onPressed: () async {
                            var existingitemcart = context
                                .read<PCart>()
                                .getItems
                                .firstWhereOrNull((element) =>
                                    element.name == widget.model?.name);

                            print(existingitemcart);
                            if (existingitemcart == null) {
                              print(widget.model);
                              Fluttertoast.showToast(
                                  msg: "Barang Berhasil Di Tambahkan");
                              context.read<PCart>().addItem(
                                    widget.model!.name.toString(),
                                    int.parse(widget.model!.price.toString()),
                                    1,
                                    widget.model!.image_name.toString(),
                                    widget.model!.id.toString(),
                                    widget.model!.sales_id.toString(),
                                    widget.model!.description.toString(),
                                    widget.model!.keterangan_barang.toString(),
                                  );
                              //add to notif
                              print("Barang Berhasil Di Tambahkan");

                              setState(() {
                                postAPIcart();
                                DbAllitems.db.updateAllitemsByname(
                                    widget.model?.name, 0);
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Barang Sudah Ada Di Keranjang");
                            }
                          },
                          icon: Image.asset(
                            "assets/shopping-bag.png",
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Image.asset(
                      //     "assets/love.png",
                      //     width: 25,
                      //     height: 25,
                      //   ),
                      // )
                    ]),

                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))),
                      padding: const EdgeInsets.only(top: 11, bottom: 5),
                      width: 160,
                      child: Column(
                        children: [
                          Text(
                            widget.model!.name.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              // letterSpacing: 3,
                            ),
                          ),
                          Text(
                            widget.model!.description.toString(),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              // letterSpacing: 3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              "\$${CurrencyFormat.convertToTitik(widget.model!.price!, 2).toString()}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // IconButton(
                    //   onPressed: () async {
                    //     var existingitemcart = context
                    //         .read<PCart>()
                    //         .getItems
                    //         .firstWhereOrNull((element) =>
                    //             element.name == widget.model?.name);

                    //     print(existingitemcart);
                    //     if (existingitemcart == null) {
                    //       print(widget.model);
                    //       Fluttertoast.showToast(
                    //           msg: "Barang Berhasil Di Tambahkan");
                    //       context.read<PCart>().addItem(
                    //             widget.model!.name.toString(),
                    //             int.parse(widget.model!.price.toString()),
                    //             1,
                    //             widget.model!.image_name.toString(),
                    //             widget.model!.id.toString(),
                    //             widget.model!.sales_id.toString(),
                    //             widget.model!.description.toString(),
                    //             widget.model!.keterangan_barang.toString(),
                    //           );
                    //       //add to notif
                    //       print("Barang Berhasil Di Tambahkan");

                    //       setState(() {
                    //         postAPIcart();
                    //         DbAllitems.db
                    //             .updateAllitemsByname(widget.model?.name, 0);
                    //       });
                    //     } else {
                    //       Fluttertoast.showToast(
                    //           msg: "Barang Sudah Ada Di Keranjang");
                    //     }
                    //   },
                    //   hoverColor: Colors.green,
                    //   icon: const Icon(
                    //     Icons.shopping_cart,
                    //     color: Colors.black,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
  }

  postAPIcart() async {
    String token = sharedPreferences!.getString("token").toString();

    Map<String, String> body = {
      // 'user_id': id.toString(),
      'product_id': widget.model!.id.toString(),
      'qty': '1',
      'price': widget.model!.price.toString(),
      'jenisform_id': '3',
      'update_by': '1'
    };
    final response = await http.post(
        Uri.parse(
            ApiConstants.baseUrl + ApiConstants.POSTkeranjangsalesendpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
  }
}
