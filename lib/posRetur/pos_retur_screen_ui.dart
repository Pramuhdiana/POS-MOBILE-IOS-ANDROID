// ignore_for_file: must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/cartScreens/db_helper.dart';
import 'package:e_shop/database/model_allitems_retur.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/itemsScreens/items_details_screen_retur.dart';
import 'package:e_shop/provider/provider_cart_retur.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../global/currency_format.dart';

class PosReturUi extends StatefulWidget {
  ModelAllitemsRetur? model;
  // Items? model;
  int? idtoko = 1; //awalnya 0
  BuildContext? context;

  PosReturUi({super.key, this.model, this.idtoko, this.context});
  @override
  State<PosReturUi> createState() => _PosReturUi();
}

class _PosReturUi extends State<PosReturUi> {
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
                      builder: (c) => ItemsDetailsScreenRetur(
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
//  setState(() async {
//                                   http.Response r = await http.head(Uri.parse(
//                                       '${baseImageUrl}${dataSnapshot.data[index].image_name.toString()}'));
//                                   print(r.headers[
//                                       "content-length"]); //545621 means 546 KB
//                                 });
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
                        Text(
                          "\$${CurrencyFormat.convertToTitik(widget.model!.price!, 0).toString()}",
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
                        .read<PCartRetur>()
                        .getItems
                        .firstWhereOrNull(
                            (element) => element.name == widget.model?.name);

                    print(existingitemcart);
                    // existingitemcart == null
                    if (existingitemcart == null) {
                      Fluttertoast.showToast(
                          msg: "Barang Berhasil Di Tambahkan");
                      context.read<PCartRetur>().addItem(
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
                        // DbAllitemsRetur.db
                        //     .updateAllitemsReturByname(widget.model?.name, 0);
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
      'product_id': widget.model!.id.toString(), //70507
      'price': widget.model!.price.toString(), //5000
      'jenisform_id': '7', //2
      'qty': '1', //1
      'customer_id':
          sharedPreferences!.getString('customer_id_retur').toString(), //764
      'update_by': '1'
    };
    final response = await http.post(
        Uri.parse(
            ApiConstants.baseUrl + ApiConstants.POSTkeranjangreturendpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
  }
}
