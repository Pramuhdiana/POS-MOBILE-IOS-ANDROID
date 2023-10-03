// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/model_allitems_retur.dart';
import 'package:e_shop/global/currency_format.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/itemsScreens/items_photo_retur.dart';
import 'package:e_shop/provider/provider_cart_retur.dart';
import 'package:e_shop/splashScreen/my_splas_screen_transaksi.dart';
import 'package:e_shop/widgets/alert_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
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
        title: Text(
          "Cart Retur ${sharedPreferences!.getString('customer_name_retur')!}",
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
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
                          String token =
                              sharedPreferences!.getString("token").toString();

                          Map<String, String> body = {
                            'customer_id':
                                sharedPreferences!.getString('customer_id')!,
                            'jenisform_id': '4',
                          };
                          final response = await http.post(
                              Uri.parse(ApiConstants.baseUrl +
                                  ApiConstants.DELETEallkeranjangreturendpoint),
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
      bottomNavigationBar: Container(
        height: 150,
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          children: [
            context.watch<PCartRetur>().getItems.isEmpty
                ? const SizedBox()
                : SizedBox(
                    height: 42,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total (${context.watch<PCartRetur>().getItems.length} item)',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        Text(
                          '\$ ${CurrencyFormat.convertToDollar(context.watch<PCartRetur>().totalPrice, 0)}',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
            context.watch<PCartRetur>().getItems.isEmpty
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
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Procced to Checkout',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            IconButton(
                              onPressed: () async {
                                showProgress();
                                await postAPIRetur();

                                //kembali barang
                                print("kembali barang dari Retur");
                                context.read<PCartRetur>().clearCart();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            const MySplashScreenTransaksi()));
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

  postAPIRetur() async {
    String cart_total = context.read<PCartRetur>().totalPrice2.toString();
    String cart_totalquantity = context.read<PCartRetur>().count.toString();
    String bayar = 0.toString();
    String customer_idAPI =
        sharedPreferences!.getString('customer_id_retur').toString();
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
            color: Colors.black,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.6,
              onPressed: () {
                Navigator.pop(context);

                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => PosTokoScreen()));
              },
              child: const Text(
                'back to POS RETUR',
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
      child: Consumer<PCartRetur>(builder: (context, cart, child) {
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
                        }),
                        children: [
                          SlidableAction(
                              backgroundColor: Colors.black,
                              icon: Iconsax.trash4,
                              onPressed: (context) async {
                                cart.removeItem(product);
                                await deleteAPIcart(product.documentId);
                                // _onDismissed();
                              })
                        ]),
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.grey.shade100,
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
                                  placeholder: (context, url) => Center(
                                      child: Container(
                                          padding: const EdgeInsets.all(0),
                                          width: 90,
                                          height: 90,
                                          child: Lottie.asset(
                                              "json/loading_black.json"))),
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
                                          '\$ ${CurrencyFormat.convertToTitik(product.price, 0)}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
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
