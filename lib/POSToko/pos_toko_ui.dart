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
import 'package:provider/provider.dart';

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
  DBHelper dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemsDetailsScreenToko(
                      model: widget.model,
                    )));
      },
      child: Card(
        color: Colors.white,
        elevation: 10,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text(
                  widget.model!.name.toString(),
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 3,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
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
                      color: Colors.red,
                    ),
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  "\$${widget.model!.price.toString()}",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 2, 8, 193),
                    fontSize: 12,
                  ),
                ),
                IconButton(
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
                  hoverColor: Colors.green,
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  postAPIcart() async {
    String token = sharedPreferences!.getString("token").toString();

    Map<String, String> body = {
      // 'user_id': id.toString(),
      'product_id': widget.model!.id.toString(), //70507
      'price': widget.model!.price.toString(), //5000
      'jenisform_id': '2', //2
      'qty': '1', //1
      'customer_id':
          sharedPreferences!.getString('customer_id').toString(), //764
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
