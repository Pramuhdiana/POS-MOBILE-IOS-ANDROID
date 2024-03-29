// ignore_for_file: must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/cartScreens/db_helper.dart';
import 'package:e_shop/database/db_allitems_toko.dart';
import 'package:e_shop/database/model_allitems_toko.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/itemsScreens/items_details_screen_toko.dart';
import 'package:e_shop/provider/provider_cart_toko.dart';
import 'package:http/http.dart' as http;

// import 'package:e_shop/testing/APITOSQLITE/src/models/model_allitems_toko.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../global/currency_format.dart';

class PosTokoUi extends StatefulWidget {
  ModelAllitemsToko? model;
  // Items? model;
  int? idtoko = 1; //awalnya 0
  BuildContext? context;

  PosTokoUi({super.key, this.model, this.idtoko, this.context});
  @override
  State<PosTokoUi> createState() => _PosTokoUi();
}

class _PosTokoUi extends State<PosTokoUi> {
  var isLoading = false;

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
                      builder: (c) => ItemsDetailsScreenToko(
                            model: widget.model,
                          )));
            },
            child: Stack(children: [
              Card(
                shadowColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    // height: 170,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          // child: Image.network(
                          //   '${baseImageUrl}${widget.model!.image_name.toString()}',
                          //   // height: 100,
                          //   fit: BoxFit.fill,
                          //   //cache
                          //   // cacheHeight: 150,
                          //   // cacheWidth: 200,
                          //   //error builder
                          //   errorBuilder: (BuildContext context,
                          //       Object exception, StackTrace? stackTrace) {
                          //     return const Icon(
                          //       Icons.error,
                          //       color: Colors.black,
                          //       // size: 100,
                          //     );
                          //   },
                          //   //loading builder
                          //   loadingBuilder: (BuildContext context, Widget child,
                          //       ImageChunkEvent? loadingProgress) {
                          //     if (loadingProgress == null) return child;
                          //     return Center(
                          //       child: CircularProgressIndicator(
                          //         value: loadingProgress.expectedTotalBytes !=
                          //                 null
                          //             ? loadingProgress.cumulativeBytesLoaded /
                          //                 loadingProgress.expectedTotalBytes!
                          //             : null,
                          //       ),
                          //     );
                          //   },
                          // ),
                          child: CachedNetworkImage(
                            // cacheManager: customCacheManager,
                            memCacheWidth: 105, //default 45
                            memCacheHeight: 120, //default 60
                            maxHeightDiskCache: 120, //default 60
                            maxWidthDiskCache: 105, //default 45
                            imageUrl:
                                '${ApiConstants.baseImageUrl}${widget.model!.image_name.toString()}',
                            placeholder: (context, url) => Center(
                                child: Container(
                                    padding: const EdgeInsets.all(0),
                                    width: 120,
                                    height: 120,
                                    child: Lottie.asset(
                                        "json/loading_black.json"))),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.black,
                              size: 100,
                            ),
                            // height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          widget.model!.name.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            // letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Text(
                        //   widget.model!.description.toString(),
                        //   textAlign: TextAlign.justify,
                        //   style: TextStyle(
                        //     color: Colors.grey.shade500,
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 10,
                        //     // letterSpacing: 3,
                        //   ),
                        // ),
                        Text(
                          sharedPreferences!.getString('role_sales_brand') ==
                                      '3' ||
                                  sharedPreferences!.getString('customer_id') ==
                                      '19'
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
                  ),
                ),
              ),
              Positioned(
                top: 1,
                right: 1,
                child: IconButton(
                  onPressed: () async {
                    var existingitemcart = context
                        .read<PCartToko>()
                        .getItems
                        .firstWhereOrNull(
                            (element) => element.name == widget.model?.name);

                    print(existingitemcart);
                    // existingitemcart == null
                    if (existingitemcart == null) {
                      Fluttertoast.showToast(
                          msg: "Barang Berhasil Di Tambahkan");
                      context.read<PCartToko>().addItem(
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
                        postAPIcart();

                        DbAllitemsToko.db
                            .updateAllitemsTokoByname(widget.model?.name, 0);
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
            ]),
          );
  }

  postAPIcart() async {
    String token = sharedPreferences!.getString("token").toString();

    Map<String, String> body = {
      // 'user_id': id.toString(),
      'product_id': widget.model!.id.toString(),
      'price': widget.model!.price.toString(),
      'jenisform_id': '2',
      'qty': '1',
      'customer_id': sharedPreferences!.getString('customer_id').toString(),
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
