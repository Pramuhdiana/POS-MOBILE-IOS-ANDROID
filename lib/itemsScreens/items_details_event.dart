// ignore_for_file: unnecessary_import, must_be_immutable, prefer_const_constructors, deprecated_member_use, unused_local_variable, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/event/appbar_cart_event.dart';
import 'package:e_shop/event/transaksi_event_screen.dart';
import 'package:e_shop/itemsScreens/items_photo.dart';
import 'package:e_shop/provider/provider_cart_event.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../global/global.dart';

class ItemsDetailsEventScreen extends StatefulWidget {
  ModelAllitems? model;

  ItemsDetailsEventScreen({
    super.key,
    this.model,
  });

  @override
  State<ItemsDetailsEventScreen> createState() =>
      _ItemsDetailsEventScreenState();
}

class _ItemsDetailsEventScreenState extends State<ItemsDetailsEventScreen> {
  void showSnackBar() {
    _scaffoldKey.currentState!.showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
      content: Text(
        'Barang sudah ditambahkan',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    ));
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  int counterLimit = 1;
  int stok = 1;
  late PhotoViewController controller;
  double? scaleCopy;
  @override
  void initState() {
    super.initState();
    controller = PhotoViewController()..outputStateStream.listen(listener);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void listener(PhotoViewControllerValue value) {
    setState(() {
      scaleCopy = value.scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBarWithCartBadgeEvent(
            title: widget.model!.name.toString(),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              var existingitemcart = context
                  .read<PCartEvent>()
                  .getItems
                  .firstWhereOrNull(
                      (element) => element.name == widget.model?.name);
              //jika item sudah ada di cart
              if (existingitemcart == null) {
                Fluttertoast.showToast(msg: "Barang Berhasil Di Tambahkan");
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
                  sharedPreferences!
                      .setString('idBarang', widget.model!.name![0]);
                  postAPIcart();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const TransaksiScreenEvent()));
                });
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
                            builder: (c) => ItemsPhoto(
                                  model: widget.model,
                                )));
                  },
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://parvabisnis.id/uploads/products/${widget.model!.image_name}',
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Theme(
                      data: ThemeData(
                          hintColor: Colors.blue,
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
                    "\$ ${widget.model!.price}",
                    textAlign: TextAlign.justify,
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

  postAPIcart() async {
    String token = sharedPreferences!.getString("token").toString();

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
