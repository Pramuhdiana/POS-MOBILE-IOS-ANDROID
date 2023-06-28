// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_allitems_toko.dart';
import 'package:e_shop/database/model_allitems_retur.dart';
import 'package:e_shop/global/currency_format.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/itemsScreens/items_photo_retur.dart';
import 'package:e_shop/posToko/pos_toko_screen.dart';
import 'package:e_shop/provider/provider_cart_retur.dart';
import 'package:e_shop/splashScreen/my_splas_screen_transaksi.dart';
import 'package:e_shop/widgets/alert_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class CartScreenRetur extends StatefulWidget {
  const CartScreenRetur({super.key});

  @override
  State<CartScreenRetur> createState() => _CartScreenReturState();
}

class _CartScreenReturState extends State<CartScreenRetur> {
  String? title = '';

  @override
  void initState() {
    super.initState();
    title = "Cart Retur";
  }

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'please wait ..', progressBgColor: Colors.red);
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
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Cart Retur",
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 3,
            ),
          ),
          centerTitle: true,
          actions: [
            context.watch<PCartRetur>().getItems.isEmpty
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
                            String token = sharedPreferences!
                                .getString("token")
                                .toString();

                            Map<String, String> body = {
                              'customer_id':
                                  sharedPreferences!.getString('customer_id')!,
                              'jenisform_id': '4',
                            };
                            final response = await http.post(
                                Uri.parse(ApiConstants.baseUrl +
                                    ApiConstants
                                        .DELETEallkeranjangreturendpoint),
                                headers: <String, String>{
                                  'Authorization': 'Bearer $token',
                                },
                                body: body);
                            print(response.body);
                            context.read<PCartRetur>().clearCart();
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
        body: context.watch<PCartRetur>().getItems.isNotEmpty
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
                        context.watch<PCartRetur>().totalPrice, 2),
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
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25)),
                child: MaterialButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 100),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Total: \$ ${CurrencyFormat.convertToDollar(context.watch<PCartRetur>().totalPrice, 2)}',
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          showProgress();
                                          await postAPIRetur();

                                          //kembali barang
                                          print("kembali barang dari Retur");
                                          context
                                              .read<PCartRetur>()
                                              .clearCart();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (c) =>
                                                      const MySplashScreenTransaksi()));
                                        },
                                        child: const Text('Save'))
                                  ],
                                ),
                              ),
                            ));
                  },
                  child: const Text('Check Out'),
                ),
              )
            ],
          ),
        ));
  }

  postAPIRetur() async {
    String cart_total = context.read<PCartRetur>().totalPrice2.toString();
    String cart_totalquantity = context.read<PCartRetur>().count.toString();
    String bayar = 0.toString();
    String customer_idAPI =
        sharedPreferences!.getString('customer_id').toString();
    String jenisform_id = 7.toString();
    String basicdiskon = 1.toString();
    String addesdiskon = '0';
    String basicrate = 1.toString();
    String nett = '0';
    String total = '0';
    String diskon_rupiah = '0';
    String addesdiskon_rupiah = '0';
    String total_potongan = '0';
    String keterangan_bayar = 'null';
    String token = sharedPreferences!.getString("token").toString();

    Map<String, String> body = {
      'cart_total': cart_total,
      'cart_totalquantity': cart_totalquantity, //total item di cart
      'bayar': bayar,
      'customer_id': customer_idAPI,
      'jenisform_id': jenisform_id,
      'diskon': basicdiskon,
      'addesdiskon': addesdiskon,
      'rate': basicrate,
      'nett': nett,
      'total': total,
      'diskon_rupiah': diskon_rupiah,
      'addesdiskon_rupiah': addesdiskon_rupiah,
      'total_potongan': total_potongan,
      'keterangan_bayar': keterangan_bayar
    };
    print(body);
    final response = await http.post(
        Uri.parse(
            ApiConstants.baseUrl + ApiConstants.POSTreturcheckoutendpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
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
    return Consumer<PCartRetur>(builder: (context, cart, child) {
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
                        builder: (c) => ItemsPhotoRetur(
                              model: ModelAllitemsRetur(
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
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://parvabisnis.id/uploads/products/${product.imageUrl}',
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
                                              cart.removeItem(product);
                                              await deleteAPIcart(
                                                  product.documentId);
                                              await DbAllitemsToko.db
                                                  .updateAllitemsTokoByname(
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
            ApiConstants.baseUrl + ApiConstants.DELETEkeranjangtokoendpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
  }

  deleteAllAPIcart(productId) async {
    String token = sharedPreferences!.getString("token").toString();

    Map<String, String> body = {
      'customer_id': sharedPreferences!.getString('customer_id')!,
      'jenisform_id': '2',
    };
    final response = await http.post(
        Uri.parse(
            ApiConstants.baseUrl + ApiConstants.DELETEallkeranjangtokondpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
  }
}
