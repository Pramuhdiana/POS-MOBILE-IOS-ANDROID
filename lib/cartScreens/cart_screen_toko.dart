// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_allitems_toko.dart';
import 'package:e_shop/database/model_allitems_toko.dart';
import 'package:e_shop/global/currency_format.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/itemsScreens/items_photo_toko.dart';
import 'package:e_shop/posToko/pos_toko_screen.dart';
import 'package:e_shop/transaksiScreens/transaksi_screen_toko.dart';
import 'package:e_shop/widgets/alert_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../provider/provider_cart_toko.dart';

class CartScreenToko extends StatefulWidget {
  const CartScreenToko({super.key});

  @override
  State<CartScreenToko> createState() => _CartScreenTokoState();
}

class _CartScreenTokoState extends State<CartScreenToko> {
  String? title = '';
  String token = sharedPreferences!.getString("token").toString();

  @override
  void initState() {
    super.initState();
    title = "Cart Toko";
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
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (c) => PosSalesScreen()));
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Cart Toko",
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
        actions: [
          context.watch<PCartToko>().getItems.isEmpty
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
                          Map<String, String> body = {
                            'customer_id':
                                sharedPreferences!.getString('customer_id')!,
                            'jenisform_id': '2',
                          };
                          final response = await http.post(
                              Uri.parse(ApiConstants.baseUrl +
                                  ApiConstants.DELETEallkeranjangtokondpoint),
                              headers: <String, String>{
                                'Authorization': 'Bearer $token',
                              },
                              body: body);
                          print(response.body);
                          context.read<PCartToko>().clearCart();
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
      body: context.watch<PCartToko>().getItems.isNotEmpty
          ? const CartItems()
          : const EmptyCart(),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(18.0),
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
                      context.watch<PCartToko>().totalPrice, 2),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => TransaksiScreenToko()));
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
                    MaterialPageRoute(builder: (context) => PosTokoScreen()));
              },
              child: const Text(
                'back to POS TOKO',
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
    return Consumer<PCartToko>(builder: (context, cart, child) {
      return ListView.builder(
        itemCount: cart.count,
        itemBuilder: (context, index) {
          final product = cart.getItems[index];
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => ItemsPhotoToko(
                              model: ModelAllitemsToko(
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
                                  // fontWeight: FontWeight.w600,
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
                                              await DbAllitemsToko.db
                                                  .updateAllitemsTokoByname(
                                                      product.name, 1);
                                              cart.removeItem(product);
                                              await deleteAPIcart(
                                                  product.documentId);
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
            ApiConstants.baseUrl + ApiConstants.DELETEkeranjangtokoendpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
  }
}
