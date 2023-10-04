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
import 'package:lottie/lottie.dart';
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
                          //   'https://parvabisnis.id/uploads/products/${widget.model!.image_name.toString()}',
                          //   // height: 100,
                          //   fit: BoxFit.fill,
                          //   //cache
                          //   cacheHeight: 150,
                          //   cacheWidth: 200,
                          //   //error builder
                          //   errorBuilder: (BuildContext context,
                          //       Object exception, StackTrace? stackTrace) {
                          //     return const Icon(
                          //       Icons.error,
                          //       color: Colors.black,
                          //       size: 100,
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
                            memCacheWidth: 105, //default 45
                            memCacheHeight: 120, //default 60
                            maxHeightDiskCache: 120, //default 60
                            maxWidthDiskCache: 105, //default 45
                            imageUrl:
                                'https://parvabisnis.id/uploads/products/${widget.model!.image_name.toString()}',
                            placeholder: (context, url) => Center(
                                child: Container(
                                    padding: const EdgeInsets.all(0),
                                    width: 90,
                                    height: 90,
                                    child: Lottie.asset(
                                        "json/loading_black.json"))),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.black,
                              size: 50,
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
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          sharedPreferences!.getString('role_sales_brand') ==
                                  '3'
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
                        .read<PCart>()
                        .getItems
                        .firstWhereOrNull(
                            (element) => element.name == widget.model?.name);

                    print(existingitemcart);
                    // existingitemcart == null
                    if (existingitemcart == null) {
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
                      setState(() {
                        postAPIcart();
                        DbAllitems.db
                            .updateAllitemsByname(widget.model?.name, 0);
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
