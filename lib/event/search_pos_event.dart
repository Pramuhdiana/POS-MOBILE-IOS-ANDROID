// ignore_for_file: use_build_context_synchronously, avoid_print, invalid_use_of_protected_member, unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_allitems.dart';
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/event/transaksi_event_screen.dart';
import 'package:e_shop/global/currency_format.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/provider/provider_cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../cartScreens/db_helper.dart';
import '../itemsScreens/items_details_screen.dart';
import '../provider/provider_cart.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SearchPosEvent extends StatefulWidget {
  // Items? model;
  ModelAllitems? model;
  // final Items? items;
  BuildContext? context;

  SearchPosEvent({super.key, this.model, this.context});

  @override
  State<SearchPosEvent> createState() => _SearchPosEvent();
  // const SearchPosEvent({required this.model});
}

class _SearchPosEvent extends State<SearchPosEvent> {
  var isLoading = false;
  int num = 0;
  DBHelper dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Container(
                padding: const EdgeInsets.all(0),
                width: 90,
                height: 90,
                child: Lottie.asset("json/loading_black.json")))
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  height: 100,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        Card(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://parvabisnis.id/uploads/products/${widget.model!.image_name.toString()}',
                                placeholder: (context, url) => Center(
                                    child: Container(
                                        padding: const EdgeInsets.all(0),
                                        width: 90,
                                        height: 90,
                                        child: Lottie.asset(
                                            "json/loading_black.json"))),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "images/noimage.png",
                                ),
                                height: 124,
                                fit: BoxFit.cover,
                              ),
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
                                    widget.model!.name.toString(),
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
                                    sharedPreferences!.getString(
                                                'role_sales_brand') ==
                                            '3'
                                        ? "Rp.${CurrencyFormat.convertToTitik(widget.model!.price!, 0).toString()}"
                                        : widget.model!.name![0].toString() ==
                                                '4'
                                            ? "Rp.${CurrencyFormat.convertToTitik(widget.model!.price!, 0).toString()}"
                                            : "\$${CurrencyFormat.convertToTitik(widget.model!.price!, 0).toString()}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
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
                                .read<PCartEvent>()
                                .getItems
                                .firstWhereOrNull((element) =>
                                    element.name == widget.model?.name);

                            print(existingitemcart);
                            if (existingitemcart == null) {
                              Fluttertoast.showToast(
                                  msg: "Barang Berhasil Di Tambahkan");
                              context.read<PCartEvent>().addItem(
                                    widget.model!.name.toString(),
                                    int.parse(widget.model!.price.toString()),
                                    1,
                                    widget.model!.image_name.toString(),
                                    widget.model!.id.toString(),
                                    widget.model!.sales_id.toString(),
                                    widget.model!.description.toString(),
                                    widget.model!.keterangan_barang.toString(),
                                  );
                              setState(() {
                                sharedPreferences!.setString(
                                    'idBarang', widget.model!.name![0]);
                                postAPIcart();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            const TransaksiScreenEvent()));
                              });
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
                )));
  }

  postAPIcart() async {
    String token = sharedPreferences!.getString("token").toString();

    // 'user_id': id.toString(),
    Map<String, String> body = {
      // 'user_id': id.toString(),
      'product_id': widget.model!.id.toString(),
      'qty': '1',
      'price': widget.model!.price.toString(),
      'customer_id': '440',
      'jenisform_id': '2',
      'update_by': '1'
    };
    final response = await http.post(
        Uri.parse(
            ApiConstants.baseUrl + ApiConstants.POSTkeranjangtokoendpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
  }
}
  // Card(
                  //   color: Colors.white,
                  //   elevation: 10,
                  //   shadowColor: const Color.fromARGB(255, 170, 201, 226),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(4),
                  //     child: SizedBox(
                  //       height: 200,
                  //       width: MediaQuery.of(context).size.width,
                  //       child: Column(
                  //         children: [
                  //           Text(
                  //             widget.model!.name.toString(),
                  //             // widget.model!.name.toString(),
                  //             style: const TextStyle(
                  //               color: Color.fromARGB(255, 2, 8, 193),
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 12,
                  //               letterSpacing: 3,
                  //             ),
                  //           ),
                  //           ClipRRect(
                  //             borderRadius: BorderRadius.circular(40),
                  //             child: CachedNetworkImage(
                  //               // cacheManager: customCacheManager,
                  //               memCacheWidth: 85, //default 45
                  //               memCacheHeight: 100, //default 60
                  //               maxHeightDiskCache: 100, //default 60
                  //               maxWidthDiskCache: 85, //default 45
                  //               imageUrl:
                  //                   'https://parvabisnis.id/uploads/products/${widget.model!.image_name.toString()}',
                  //               placeholder: (context, url) =>
                  //                   const CircularProgressIndicator(),
                  //               errorWidget: (context, url, error) => const Icon(
                  //                 Icons.error,
                  //                 color: Colors.red,
                  //               ),
                  //               height: 100,
                  //               fit: BoxFit.cover,
                  //             ),
                  //             // child: Image.network(
                  //             //   'https://parvabisnis.id/uploads/products/${widget.model!.image_name.toString()}',
                  //             // ),
                  //           ),
                  //           Text(
                  //             "\$${widget.model!.price.toString()}",
                  //             style: const TextStyle(
                  //               color: Color.fromARGB(255, 2, 8, 193),
                  //               fontSize: 12,
                  //             ),
                  //           ),
                  //           IconButton(
                  //             onPressed: () async {
                  //               var existingitemcart = context
                  //                   .read<PCartEvent>()
                  //                   .getItems
                  //                   .firstWhereOrNull((element) =>
                  //                       element.name == widget.model?.name);

                  //               print(existingitemcart);
                  //               if (existingitemcart == null) {
                  //                 Fluttertoast.showToast(
                  //                     msg: "Barang Berhasil Di Tambahkan");
                  //                 context.read<PCartEvent>().addItem(
                  //                       widget.model!.name.toString(),
                  //                       int.parse(widget.model!.price.toString()),
                  //                       1,
                  //                       widget.model!.image_name.toString(),
                  //                       widget.model!.id.toString(),
                  //                       widget.model!.sales_id.toString(),
                  //                       widget.model!.description.toString(),
                  //                       widget.model!.keterangan_barang.toString(),
                  //                     );
                  //                 setState(() {
                  //                   postAPIcart();
                  //                   DbAllitems.db
                  //                       .updateAllitemsByname(widget.model?.name, 0);
                  //                 });
                  //               } else {
                  //                 Fluttertoast.showToast(
                  //                     msg: "Barang Sudah Ada Di Keranjang");
                  //               }
                  //             },
                  //             hoverColor: Colors.green,
                  //             icon: const Icon(
                  //               Icons.shopping_cart,
                  //               color: Colors.blue,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),