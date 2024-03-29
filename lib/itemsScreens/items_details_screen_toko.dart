// ignore_for_file: unnecessary_import, must_be_immutable, deprecated_member_use, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/model_allitems_toko.dart';
import 'package:e_shop/global/currency_format.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/itemsScreens/items_photo_toko.dart';
import 'package:e_shop/provider/provider_cart_toko.dart';
import 'package:e_shop/widgets/appbar_cart_pos_toko.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ItemsDetailsScreenToko extends StatefulWidget {
  ModelAllitemsToko? model;

  ItemsDetailsScreenToko({
    super.key,
    this.model,
  });

  @override
  State<ItemsDetailsScreenToko> createState() => _ItemsDetailsScreenTokoState();
}

class _ItemsDetailsScreenTokoState extends State<ItemsDetailsScreenToko> {
  void showSnackBar() {
    _scaffoldKey.currentState!.showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text(
        'Barang sudah ditambahkan',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    ));
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  int counterLimit = 1;
  int stok = 1;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppbarCartToko(title: widget.model!.name.toString()),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              var existingitemcart = context
                  .read<PCartToko>()
                  .getItems
                  .firstWhereOrNull(
                      (element) => element.name == widget.model?.name);
              //jika item sudah ada di cart
              if (existingitemcart == null) {
                Fluttertoast.showToast(msg: "Barang Berhasil Di Tambahkan");
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
              } else {
                showSnackBar();
              }
            },
            label: const Text(
              "Add to Cart",
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(
              Icons.add_shopping_cart_rounded,
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => ItemsPhotoToko(
                                  model: widget.model,
                                )));
                  },
                  child: CachedNetworkImage(
                    imageUrl:
                        '${ApiConstants.baseImageUrl}${widget.model!.image_name.toString()}',
                    placeholder: (context, url) => Center(
                        child: Container(
                            padding: const EdgeInsets.all(0),
                            child: Lottie.asset("json/loading_black.json"))),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.black,
                      size: 100,
                    ),
                    // height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Theme(
                      data: ThemeData(
                          hintColor: Colors.black,
                          primarySwatch: Colors.blue,
                          colorScheme:
                              ColorScheme.light(primary: Colors.black)),
                      child: CartStepperInt(
                        count: counterLimit,
                        size: 30,
                        didChangeCount: (value) {
                          //argument jika total cart kurang dari 1
                          if (value < 1) {
                            Fluttertoast.showToast(
                                msg: "Quantiy tidak bisa kurang dari 1");
                            return;
                          } else if (value >= stok) {
                            Fluttertoast.showToast(
                                msg: "Quantiy tidak bisa melebihi stok");
                            return;
                          }
                          setState(() {
                            counterLimit = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Text(
                    widget.model!.name.toString(),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
                  child: Text(
                    widget.model!.keterangan_barang.toString(),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    sharedPreferences!.getString('role_sales_brand') == '3' ||
                            widget.model!.price!.bitLength > 17
                        ? "Rp.${CurrencyFormat.convertToTitik(widget.model!.price!, 0).toString()}"
                        : widget.model!.name![0].toString() == '4'
                            ? "Rp.${CurrencyFormat.convertToTitik(widget.model!.price!, 0).toString()}"
                            : "\$${CurrencyFormat.convertToTitik(widget.model!.price!, 0).toString()}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Divider(
                    height: 1,
                    thickness: 2,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ));
  }
}
