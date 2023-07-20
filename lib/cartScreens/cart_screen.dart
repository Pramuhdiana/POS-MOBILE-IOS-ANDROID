// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_allitems.dart';
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/itemsScreens/items_photo.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:e_shop/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            "assets/arrow.png",
            width: 35,
            height: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "My Cart",
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
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
                          context.read<PCart>().clearCart();
                          Navigator.pop(context);
                        });
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.black,
                  ),
                ),
        ],
      ),
      body: context.watch<PCart>().getItems.isNotEmpty
          ? const CartItems()
          : const EmptyCart(),
      bottomNavigationBar: Container(
        height: 150,
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          children: [
            context.watch<PCart>().getItems.isEmpty
                ? const SizedBox()
                : SizedBox(
                    height: 42,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total (${context.watch<PCart>().getItems.length} item)',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        Text(
                          '\$ ${CurrencyFormat.convertToDollar(context.watch<PCart>().totalPrice, 2)}',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
            context.watch<PCart>().getItems.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 17),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const TransaksiScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Procced to Checkout',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            const TransaksiScreen()));
                              },
                              icon: Image.asset(
                                "assets/arrow (1).png",
                                width: 35,
                                height: 35,
                              ),
                            )
                          ],
                        ),
                      ),
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
            color: Colors.black,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.6,
              onPressed: () {
                Navigator.pop(context);

                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => PosSalesScreen()));
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
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Consumer<PCart>(builder: (context, cart, child) {
        return ListView.builder(
          itemCount: cart.count,
          itemBuilder: (context, index) {
            final product = cart.getItems[index];
            return Padding(
                padding: const EdgeInsets.only(bottom: 15),
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
                                      keterangan_barang:
                                          product.keterangan_barang),
                                )));
                  },
                  child: Slidable(
                    key: UniqueKey(),
                    endActionPane: ActionPane(
                        extentRatio: 0.3,
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () async {
                          cart.removeItem(product);
                          await deleteAPIcart(product.documentId);
                          await DbAllitems.db
                              .updateAllitemsByname(product.name, 1);
                        }),
                        children: [
                          SlidableAction(
                              backgroundColor: Colors.black,
                              icon: Iconsax.trash4,
                              onPressed: (context) async {
                                cart.removeItem(product);
                                await deleteAPIcart(product.documentId);
                                await DbAllitems.db
                                    .updateAllitemsByname(product.name, 1);
                                // _onDismissed();
                              })
                        ]),
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.white,
                      height: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.white,
                              height: 80,
                              width: 80,
                              child: ClipRRect(
                                child: CachedNetworkImage(
                                  // memCacheWidth: 85, //default 45
                                  // memCacheHeight: 100, //default 60
                                  // maxHeightDiskCache: 100, //default 60
                                  // maxWidthDiskCache: 85, //default 45
                                  imageUrl:
                                      'https://parvabisnis.id/uploads/products/${product.imageUrl.toString()}',
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Flexible(
                                child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      product.description,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade500),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '\$ ${CurrencyFormat.convertToTitik(product.price, 2)}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   height: 35,
                                      //   decoration: BoxDecoration(
                                      //       color: Colors.grey.shade200,
                                      //       borderRadius:
                                      //           BorderRadius.circular(15)),
                                      //   child: Row(children: [
                                      //     IconButton(
                                      //         onPressed: product.qty == 1
                                      //             ? null
                                      //             : () {
                                      //                 cart.reduceByOne(product);
                                      //               },
                                      //         icon: const Icon(
                                      //           FontAwesomeIcons.minus,
                                      //           size: 18,
                                      //         )),
                                      //     Text(
                                      //       product.qty.toString(),
                                      //       style:
                                      //           product.qty == 1 //3 adalah stok
                                      //               ? const TextStyle(
                                      //                   fontSize: 20,
                                      //                   fontFamily: 'Acme',
                                      //                   color: Colors.red,
                                      //                 )
                                      //               : const TextStyle(
                                      //                   fontSize: 20,
                                      //                   fontFamily: 'Acme',
                                      //                 ),
                                      //     ),
                                      //     IconButton(
                                      //         onPressed: product.qty == 1
                                      //             ? null
                                      //             : () {
                                      //                 cart.increament(product);
                                      //               },
                                      //         icon: const Icon(
                                      //           FontAwesomeIcons.plus,
                                      //           size: 18,
                                      //         )),
                                      //   ]),
                                      // )
                                    ],
                                  )
                                ],
                              ),
                            ))
                          ]),
                    ),
                  ),
                ));
          },
        );
      }),
    );
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
