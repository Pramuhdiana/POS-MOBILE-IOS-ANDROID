// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_allitems.dart';
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/itemsScreens/items_photo.dart';
import 'package:e_shop/posSales/pos_sales_screen.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:e_shop/widgets/alert_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../global/currency_format.dart';
import '../transaksiScreens/transaksi_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ModelAllitems? model;

  String? title = '';

  @override
  void initState() {
    super.initState();
    title = "POS Cart";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.lightBlueAccent,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              DbAllitems.db.getAllitems();
            });

            // Navigator.push(
            //     context, MaterialPageRoute(builder: (c) => PosSalesScreen()));
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Cart Sales",
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
        actions: [
          context.watch<PCart>().getItems.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    MyAlertDilaog.showMyDialog(
                        context: context,
                        title: 'Clear Cart',
                        content: 'Are you sure to clear cart ?',
                        tabNo: () {
                          Navigator.pop(context);
                        },
                        tabYes: () async {
                          String token =
                              sharedPreferences!.getString("token").toString();

                          Map<String, String> body = {
                            'jenisform_id': '3',
                          };
                          final response = await http.post(
                              Uri.parse(ApiConstants.baseUrl +
                                  ApiConstants.DELETEallkeranjangsalesendpoint),
                              headers: <String, String>{
                                'Authorization': 'Bearer $token',
                              },
                              body: body);
                          print(response.body);
                          // ignore: use_build_context_synchronously
                          context.read<PCart>().clearCart();
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        });
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                ),
        ],
      ),
      body: context.watch<PCart>().getItems.isNotEmpty
          ? const CartItems()
          : const EmptyCart(),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Total: \$',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  // context.watch<PCart>().totalPrice.toStringAsFixed(2),
                  CurrencyFormat.convertToDollar(
                      context.watch<PCart>().totalPrice, 2),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
            Container(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(25)),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const TransaksiScreen()));
                },
                child: const Text('Check Out'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Cart Is Empty !',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 50,
          ),
          Material(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.6,
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => PosSalesScreen()));
              },
              child: const Text(
                'back to POS SALES',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PCart>(builder: (context, cart, child) {
      return ListView.builder(
        itemCount: cart.count,
        itemBuilder: (context, index) {
          print(cart.count);
          final product = cart.getItems[index];
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => ItemsPhoto(
                              model: ModelAllitems(
                                  name: product.name,
                                  image_name: product.imageUrl,
                                  description: product.description,
                                  price: product.price,
                                  qty: product.qty,
                                  keterangan_barang: product.keterangan_barang),
                            )));
              },
              child: Card(
                child: SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: CachedNetworkImage(
                            memCacheWidth: 85, //default 45
                            memCacheHeight: 100, //default 60
                            maxHeightDiskCache: 100, //default 60
                            maxWidthDiskCache: 85, //default 45
                            imageUrl:
                                'https://parvabisnis.id/uploads/products/${product.imageUrl.toString()}',
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
                      ),
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.price.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(children: [
                                    product.qty == 1
                                        ? IconButton(
                                            onPressed: () async {
                                              // await FirebaseFirestore.instance
                                              //     .runTransaction(
                                              //         (transaction) async {
                                              //   DocumentReference
                                              //       documentReference =
                                              //       FirebaseFirestore.instance
                                              //           // .collection("users")
                                              //           // .doc(sharedPreferences!
                                              //           //     .getString("uid"))
                                              //           .collection("allitems")
                                              //           .doc(product.name);
                                              //   transaction.update(
                                              //       documentReference,
                                              //       {'posisi_id': 3});
                                              // });
                                              cart.removeItem(product);
                                              await deleteAPIcart(
                                                  product.documentId);
                                              await DbAllitems.db
                                                  .updateAllitemsByname(
                                                      product.name, 1);
                                            },
                                            icon: const Icon(
                                              Icons.delete_forever,
                                              size: 18,
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              cart.reduceByOne(product);
                                            },
                                            icon: const Icon(
                                              FontAwesomeIcons.minus,
                                              size: 18,
                                            )),
                                    Text(
                                      product.qty.toString(),
                                      style: product.qty == 1 //3 adalah stok
                                          ? const TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Acme',
                                              color: Colors.red,
                                            )
                                          : const TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Acme',
                                            ),
                                    ),
                                    IconButton(
                                        onPressed: product.qty == 1
                                            ? null
                                            : () {
                                                cart.increament(product);
                                              },
                                        icon: const Icon(
                                          FontAwesomeIcons.plus,
                                          size: 18,
                                        )),
                                  ]),
                                )
                              ],
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  deleteAPIcart(productId) async {
    String token = sharedPreferences!.getString("token").toString();

    Map<String, String> body = {
      'update_by': '1',
      'product_id': productId,
    };
    final response = await http.post(
        Uri.parse(
            ApiConstants.baseUrl + ApiConstants.DELETEkeranjangsalesendpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
  }
}
