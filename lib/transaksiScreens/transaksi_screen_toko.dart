// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, use_build_context_synchronously, non_constant_identifier_names

import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/global/currency_format.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/splashScreen/my_splas_screen_transaksi.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../provider/provider_cart_toko.dart';
import 'package:http/http.dart' as http;

class TransaksiScreenToko extends StatefulWidget {
  const TransaksiScreenToko({super.key});

  @override
  _TransaksiScreenTokoState createState() => _TransaksiScreenTokoState();
}

class _TransaksiScreenTokoState extends State<TransaksiScreenToko> {
  String qty = '';
  String orderId = DateTime.now().second.toString();
  String? form;
  String? toko;
  int idform = 0;
  int idformAPI = 0;
  int idtoko = 0;
  int rate = 1;
  int result = 0;
  int diskon = 100;
  int dpp = 0;
  int addesdiskon = 0;
  TextEditingController dp = TextEditingController();
  TextEditingController addDiskon = TextEditingController();
  // int DPP = int.parse(dp);

  final _formKey = GlobalKey<FormState>();

  double get totalPrice {
    // var dpin = int.parse(dp);
    var total =
        ((context.read<PCartToko>().totalPrice2) * rate) * (diskon / 100) - dpp;
    return total;
  }

  String get totalPrice3 {
    // var dpin = int.parse(dp);
    var total =
        ((context.read<PCartToko>().totalPrice2) * rate) * (diskon / 100) - dpp;
    if (rate <= 2) {
      return '\$ ${CurrencyFormat.convertToDollar(total, 2)}';
    } else {
      return CurrencyFormat.convertToIdr(total, 2);
    }
  }

  String get totalPriceAPI {
    // var dpin = int.parse(dp);
    var total =
        ((context.read<PCartToko>().totalPrice2) * rate) * (diskon / 100) -
            dpp -
            addesdiskon;
    return total.toString();
  }

  String get totalDiskonRp {
    // var dpin = int.parse(dp);
    var total1 =
        ((context.read<PCartToko>().totalPrice2) * rate) * (diskon / 100) -
            dpp -
            addesdiskon;
    var total = ((context.read<PCartToko>().totalPrice2) * rate);
    var result = total - total1;

    return result.toString();
  }

  String get totalRp {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartToko>().totalPrice2) * rate);
    return total.toString();
  }

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'please wait ..', progressBgColor: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Billing Information Toko"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(4),
            children: <Widget>[
              //jenis form
              const SizedBox(
                height: 10,
              ),
              const Text("Jenis Form"),
              const Divider(),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<String>(
                      items: const ["INVOICE", "KEMBALI BARANG"],
                      onChanged: (text) {
                        setState(() {
                          form = text;
                          if (form == "INVOICE") {
                            idform = 1;
                            idformAPI = 1;
                            print(idform);
                          } else if (form == "KEMBALI BARANG") {
                            idform = 4;
                            idformAPI = 4;
                            print(idform);
                          } else {
                            idform = 0;
                            print(idform);
                          }
                          qty = context
                              .read<PCartToko>()
                              .getItems
                              .length
                              .toString();
                          print(sharedPreferences!.getString("toko"));
                        });
                      },
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Jenis Form',
                          filled: true,
                          fillColor:
                              Theme.of(context).inputDecorationTheme.fillColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //Rate
              if (idform != 4)
                const SizedBox(
                  height: 10,
                ),
              if (idform != 4) const Text("Rate"),
              if (idform != 4) const Divider(),
              if (idform != 4)
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.all(4)),
                    Expanded(
                      child: DropdownSearch<int>(
                        items: const [11500, 11900, 13000],
                        onChanged: (value) {
                          setState(() {
                            rate = value!;
                          });
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Rate',
                            filled: true,
                            fillColor: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              //Basic Diskon
              if (idform != 4)
                const SizedBox(
                  height: 10,
                ),
              if (idform != 4) const Text("Basic Diskon"),
              if (idform != 4) const Divider(),
              if (idform != 4)
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.all(4)),
                    Expanded(
                      child: DropdownSearch<int>(
                        items: const [60, 63],
                        onChanged: (value) {
                          setState(() {
                            diskon = value!;
                          });
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Basic Diskon',
                            filled: true,
                            fillColor: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
//addesdiskon
              if (idform != 4)
                const SizedBox(
                  height: 10,
                ),
              if (idform != 4) const Text("ADD DISKON"),
              if (idform != 4) const Divider(),
              if (idform != 4)
                SizedBox(
                  width: 250,
                  child: TextField(
                    onChanged: (addDiskon) {
                      setState(() {
                        addesdiskon = int.parse(addDiskon);
                      });
                    },
                    decoration: const InputDecoration(labelText: "ADD DISKON"),
                    controller: addDiskon,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),

              //DP
              if (idform != 4)
                const SizedBox(
                  height: 10,
                ),
              if (idform != 4) const Text("DP"),
              if (idform != 4) const Divider(),
              if (idform != 4)
                SizedBox(
                  width: 250,
                  child: TextField(
                    onChanged: (dp) {
                      setState(() {
                        dpp = int.parse(dp);
                      });
                    },
                    decoration: const InputDecoration(labelText: "DP"),
                    controller: dp,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),

              const SizedBox(height: 30),
              const Divider(
                color: Colors.black,
                thickness: 5,
              ),

              const Text("Total"),
              // Text(
              //   "$total",
              //   style: TextStyle(fontSize: 40),
              // ),
              Text(
                "$totalPrice3",
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Total : $totalPrice3',
                            style: const TextStyle(fontSize: 24),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                showProgress();
                                await postAPItoko();
                                if (idform == 1) {
                                  // print("invoice dari toko");
                                  // //invoice
                                  // for (var item
                                  //     in context.read<PCartToko>().getItems) {
                                  //   FirebaseFirestore.instance
                                  //       .collection('allitemstoko')
                                  //       .doc(item.name)
                                  //       .delete();
                                  //   print('delete data firebase berhasil');
                                  // }
                                  context.read<PCartToko>().clearCart();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) =>
                                              const MySplashScreenTransaksi()));
                                } else {
                                  // for (var item
                                  //     in context.read<PCartToko>().getItems) {
                                  //   CollectionReference orderRef =
                                  //       FirebaseFirestore.instance
                                  //           .collection('allitemstoko');
                                  //   await orderRef.doc(item.name).set({
                                  //     'brand_id': 9999,
                                  //     'category_id': '1',
                                  //     'created_at': DateTime.now(),
                                  //     'customer_id': sharedPreferences!
                                  //         .getString('customer_id')
                                  //         .toString(),
                                  //     'description': item.description,
                                  //     'id': int.parse(item.documentId),
                                  //     'image_name': item.imageUrl,
                                  //     'keterangan_barang':
                                  //         item.keterangan_barang,
                                  //     'kode_refrensi': 'null',
                                  //     'name': item.name,
                                  //     'posisi_id': 3,
                                  //     'price':
                                  //         item.price, //harus int atau double
                                  //     'qty': 1, //harus int
                                  //     'sales_id': int.parse(id!),
                                  //     'slug': item.name,
                                  //     'status_titipan': 99,
                                  //     'updated_at': DateTime.now()
                                  //   });
                                  // }
                                  //kembali barang
                                  print("kembali barang dari toko");
                                  context.read<PCartToko>().clearCart();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) =>
                                              const MySplashScreenTransaksi()));
                                }
                              },
                              child: const Text('Save'))
                        ],
                      ),
                    ),
                  ));
        },
        child: const Text('Save Transaksi'),
      )),
    );
  }

  postAPItoko() async {
    String cart_total = context.read<PCartToko>().totalPrice2.toString();
    String cart_totalquantity = context.read<PCartToko>().count.toString();
    String bayar = dpp.toString();
    String customer_idAPI =
        sharedPreferences!.getString('customer_id').toString();
    String jenisform_id = idformAPI.toString();
    String basicdiskon = diskon.toString();
    String addesdiskon = '0';
    String basicrate = rate.toString();
    String nett = totalPriceAPI;
    String total = totalRp;
    String diskon_rupiah = totalDiskonRp;
    String addesdiskon_rupiah = addesdiskon;
    String total_potongan = totalDiskonRp;
    String keterangan_bayar = 'null';

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
        Uri.parse(ApiConstants.baseUrl + ApiConstants.POSTtokocheckoutendpoint),
        headers: <String, String>{
          'Authorization': 'Bearer ${token!}',
        },
        body: body);
    print(response.body);
  }
}


//elevated firebase
//  ElevatedButton(
//                               onPressed: () async {
//                                 showProgress();
//                                 if (idform == 1) {
//                                   print("invoice dari toko");
//                                   //invoice
//                                   for (var item
//                                       in context.read<PCartToko>().getItems) {
//                                     CollectionReference orderRef =
//                                         FirebaseFirestore.instance
//                                             .collection('invoice');
//                                     orderId =
//                                         //IV-menit + 10 & jam+12 & harga dollar
//                                         'IV-${DateTime.now().minute + 10}${DateTime.now().hour + 12}${context.read<PCartToko>().totalPrice2}';
//                                     await orderRef.doc(orderId).set({
//                                       'id': orderId,
//                                       'toko':
//                                           sharedPreferences!.getString("toko"),
//                                       'salesId': FirebaseAuth
//                                           .instance.currentUser!.uid,
//                                       'jenis_order': idform,
//                                       'customer_id': idtoko.toString(),
//                                       'name': orderId,
//                                       'qty': int.parse(qty), //harus int
//                                       'price':
//                                           totalPrice, //harus int atau double
//                                       'deliverystatus': form,
//                                       'rate': rate.toString(),
//                                       'basicdiskon': diskon.toString(),
//                                       'dp': dpp,
//                                       'price_dollar':
//                                           context.read<PCartToko>().totalPrice2,
//                                       'orderdate': DateTime.now()
//                                     });
//                                     orderRef
//                                         .doc(orderId)
//                                         .collection("invoiceid")
//                                         .doc(item.name)
//                                         .set({
//                                       'id': orderId,
//                                       'salesId': FirebaseAuth
//                                           .instance.currentUser!.uid,
//                                       'name': item.name,
//                                       'toko':
//                                           sharedPreferences!.getString("toko"),
//                                       'qty': item.qty,
//                                       'price': item.price,
//                                       'image_name': item.imageUrl,
//                                       'orderprice': item.qty * item.price,
//                                       'deliverystatus': form,
//                                       'jenis_order': idform,
//                                       'customer_id': idtoko.toString(),
//                                       'description': item.description,
//                                       'keterangan_barang':
//                                           item.keterangan_barang,
//                                       'rate': rate.toString(),
//                                       'basicdiskon': diskon.toString(),
//                                       'dp': dpp,
//                                       'price_dollar':
//                                           context.read<PCartToko>().totalPrice2,
//                                       // 'total': int.parse(totalPrice3),
//                                       'orderdate': DateTime.now()
//                                     }).then((value) {
//                                       FirebaseFirestore.instance
//                                           .collection("invoiceid")
//                                           .doc(item.name)
//                                           .set({
//                                         'id': orderId,
//                                         'salesId': FirebaseAuth
//                                             .instance.currentUser!.uid,
//                                         'name': item.name,
//                                         'toko': sharedPreferences!
//                                             .getString("toko"),
//                                         'qty': item.qty,
//                                         'price': item.price,
//                                         'image_name': item.imageUrl,
//                                         'orderprice': item.qty * item.price,
//                                         'deliverystatus': form,
//                                         'jenis_order': idform,
//                                         'customer_id': idtoko.toString(),
//                                         'description': item.description,
//                                         'keterangan_barang':
//                                             item.keterangan_barang,
//                                         'rate': rate.toString(),
//                                         'basicdiskon': diskon.toString(),
//                                         'dp': dpp,
//                                         'price_dollar': context
//                                             .read<PCartToko>()
//                                             .totalPrice2,
//                                         'orderdate': DateTime.now()
//                                       });
//                                     }).whenComplete(() async {
//                                       await FirebaseFirestore.instance
//                                           .runTransaction((transaction) async {
//                                         DocumentReference documentReference =
//                                             FirebaseFirestore.instance
//                                                 // .collection("users")
//                                                 // .doc(sharedPreferences!
//                                                 //     .getString("uid"))
//                                                 .collection("items")
//                                                 .doc(item.name);
//                                         transaction.update(documentReference, {
//                                           'posisi_id': "100",
//                                           'jenis_order': idform,
//                                           'customer_id': idtoko
//                                         });
//                                       });
//                                     });
//                                   }
//                                   context.read<PCartToko>().clearCart();
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (c) =>
//                                               const MySplashScreenTransaksi()));
//                                 } else {
//                                   //kembali barang
//                                   print('kembali barang');
//                                   for (var item
//                                       in context.read<PCartToko>().getItems) {
//                                     CollectionReference orderRef =
//                                         FirebaseFirestore.instance
//                                             .collection('kembali');
//                                     //KB-menit + 10 & jam+12 & harga dollar
//                                     orderId =
//                                         'KB-${DateTime.now().minute + 10}${DateTime.now().hour + 12}${context.read<PCartToko>().totalPrice2}';
//                                     await orderRef.doc(orderId).set({
//                                       'id': orderId,
//                                       'toko':
//                                           sharedPreferences!.getString("toko"),
//                                       'salesId': FirebaseAuth
//                                           .instance.currentUser!.uid,
//                                       'jenis_order': idform,
//                                       'customer_id': idtoko.toString(),
//                                       'name': orderId,
//                                       'qty': int.parse(qty), //harus int
//                                       'price':
//                                           totalPrice, //harus int atau double
//                                       'deliverystatus': form,
//                                       'rate': rate.toString(),
//                                       'basicdiskon': diskon.toString(),
//                                       'dp': dpp,
//                                       'price_dollar':
//                                           context.read<PCartToko>().totalPrice2,
//                                       'orderdate': DateTime.now()
//                                     });
//                                     orderRef
//                                         .doc(orderId)
//                                         .collection("kembaliid")
//                                         .doc(item.name)
//                                         .set({
//                                       'id': orderId,
//                                       'salesId': FirebaseAuth
//                                           .instance.currentUser!.uid,
//                                       'name': item.name,
//                                       'toko':
//                                           sharedPreferences!.getString("toko"),
//                                       'qty': item.qty,
//                                       'price': item.price,
//                                       'image_name': item.imageUrl,
//                                       'orderprice': item.qty * item.price,
//                                       'deliverystatus': form,
//                                       'jenis_order': idform,
//                                       'customer_id': idtoko.toString(),
//                                       'description': item.description,
//                                       'keterangan_barang':
//                                           item.keterangan_barang,
//                                       'rate': rate.toString(),
//                                       'basicdiskon': diskon.toString(),
//                                       'dp': dpp,
//                                       'price_dollar':
//                                           context.read<PCartToko>().totalPrice2,
//                                       // 'total': int.parse(totalPrice3),
//                                       'orderdate': DateTime.now()
//                                     }).then((value) {
//                                       FirebaseFirestore.instance
//                                           .collection("kembaliid")
//                                           .doc(item.name)
//                                           .set({
//                                         'id': orderId,
//                                         'salesId': FirebaseAuth
//                                             .instance.currentUser!.uid,
//                                         'name': item.name,
//                                         'toko': sharedPreferences!
//                                             .getString("toko"),
//                                         'qty': item.qty,
//                                         'price': item.price,
//                                         'image_name': item.imageUrl,
//                                         'orderprice': item.qty * item.price,
//                                         'deliverystatus': form,
//                                         'jenis_order': idform,
//                                         'customer_id': idtoko.toString(),
//                                         'description': item.description,
//                                         'keterangan_barang':
//                                             item.keterangan_barang,
//                                         'rate': rate.toString(),
//                                         'basicdiskon': diskon.toString(),
//                                         'dp': dpp,
//                                         'price_dollar': context
//                                             .read<PCartToko>()
//                                             .totalPrice2,
//                                         'orderdate': DateTime.now()
//                                       });
//                                     }).whenComplete(() async {
//                                       await FirebaseFirestore.instance
//                                           .runTransaction((transaction) async {
//                                         DocumentReference documentReference =
//                                             FirebaseFirestore.instance
//                                                 // .collection("users")
//                                                 // .doc(sharedPreferences!
//                                                 //     .getString("uid"))
//                                                 .collection("items")
//                                                 .doc(item.name);
//                                         transaction.update(documentReference, {
//                                           'posisi_id': "1",
//                                           'jenis_order': idform,
//                                           'customer_id': 99
//                                         });
//                                       });
//                                     });
//                                   }
//                                   context.read<PCartToko>().clearCart();
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (c) =>
//                                               const MySplashScreenTransaksi()));
//                                 }
//                               },
//                               child: const Text('Save'))