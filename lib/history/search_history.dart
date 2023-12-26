// ignore_for_file: use_build_context_synchronously, avoid_print, invalid_use_of_protected_member, unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/model_alldetailtransaksi.dart';
import 'package:e_shop/global/global.dart';
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
class SearchHistory extends StatefulWidget {
  // Items? model;
  ModelAlldetailtransaksi? model;
  // final Items? items;
  BuildContext? context;

  SearchHistory({super.key, this.model, this.context});

  @override
  State<SearchHistory> createState() => _SearchHistory();
  // const SearchHistory({required this.model});
}

class _SearchHistory extends State<SearchHistory> {
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
        // : GestureDetector(
        //     onTap: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (c) => ItemsDetailsScreenToko(
        //                     model: widget.model,
        //                   )));
        //     },
        //     child:
        : Padding(
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
                          height: 100,
                          width: 100,
                          child: CachedNetworkImage(
                            imageUrl:
                                '${ApiConstants.baseImageUrl}${widget.model!.image_name.toString()}',
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
                            height: 124,
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
                              children: [
                                Text(
                                  widget.model!.invoices_number.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                )));
  }
}
