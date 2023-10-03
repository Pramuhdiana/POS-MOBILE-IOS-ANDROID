// ignore_for_file: use_build_context_synchronously, avoid_print, invalid_use_of_protected_member, unused_import

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_allitems_toko.dart';
import 'package:e_shop/database/model_allitems_toko.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/itemsScreens/items_details_screen_toko.dart';
import 'package:e_shop/provider/provider_cart_toko.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../cartScreens/db_helper.dart';
import '../database/db_allcustomer.dart';
import '../itemsScreens/items_details_screen.dart';
import '../provider/provider_cart.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SearchPosGlobalToko extends StatefulWidget {
  // Items? model;
  ModelAllitemsToko? model;
  // final Items? items;
  BuildContext? context;

  SearchPosGlobalToko({super.key, this.model, this.context});

  @override
  State<SearchPosGlobalToko> createState() => _SearchPosGlobalToko();
  // const SearchPosGlobalToko({required this.model});
}

class _SearchPosGlobalToko extends State<SearchPosGlobalToko> {
  var isLoading = false;
  bool isPrivacy = false;
  int num = 0;
  String? namaToko = '';
  DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    DbAllCustomer.db.getNameCustomer(widget.model!.customer_id).then((value) {
      setState(() {
        namaToko = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Container(
                padding: const EdgeInsets.all(0),
                width: 90,
                height: 90,
                child: Lottie.asset("json/loading_black.json")))
        :
        // GestureDetector(
        //     onTap: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (c) => ItemsDetailsScreenToko(
        //                     model: widget.model,
        //                   )));
        //     },
        //     child:

        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
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
                            errorWidget: (context, url, error) => Image.asset(
                              "images/noimage.png",
                            ),
                            fit: BoxFit.cover,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$ ${widget.model!.price}',
                                  overflow: TextOverflow.ellipsis,
                                  // maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: isPrivacy == false
                                  ? null
                                  : Text(
                                      '$namaToko',
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      isPrivacy == false
                          ? IconButton(
                              onPressed: () async {
                                setState(() {
                                  isPrivacy = true;
                                });
                              },
                              icon: const Icon(
                                Icons.remove_red_eye,
                                color: Colors.black,
                              ),
                            )
                          : IconButton(
                              onPressed: () async {
                                setState(() {
                                  isPrivacy = false;
                                });
                              },
                              icon: const Icon(
                                Icons.no_encryption_gmailerrorred_outlined,
                                color: Colors.black,
                              ),
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                    // ),
                  ),
                )));
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
