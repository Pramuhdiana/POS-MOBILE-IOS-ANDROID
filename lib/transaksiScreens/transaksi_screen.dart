// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, use_build_context_synchronously, unused_local_variable, unused_element, prefer_const_constructors, unnecessary_new, prefer_collection_literals, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/models/user_model.dart';
import 'package:e_shop/splashScreen/my_splas_screen_transaksi.dart';
import 'package:e_shop/widgets/custom_loading.dart';
import 'package:e_shop/widgets/keyboard_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

import '../global/currency_format.dart';
import '../global/global.dart';
import '../provider/provider_cart.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  _TransaksiScreenState createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  FocusNode numberFocusNode = FocusNode();
  FocusNode numberFocusNode2 = FocusNode();

  RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  String qty = '';
  String orderId = DateTime.now().second.toString();
  String uid = '';
  String? form;
  String? toko;
  int? idtoko = 0;
  int idform = 0;
  int idformAPI = 0;
  int rate = 1;
  int diskonrequest = 90;
  int result = 0;
  int diskon = 0;
  TextEditingController dp = TextEditingController();
  TextEditingController addDiskon = TextEditingController();
  int dpp = 0;
  int addesdiskon = 0;

  final _formKey = GlobalKey<FormState>();

  double get totalPrice {
    // var dpin = int.parse(dp);
    var total =
        ((context.read<PCart>().totalPrice2) * rate) * (1 - (diskon / 100)) -
            dpp -
            addesdiskon;
    return total;
  }

  String get totalPrice3 {
    // var dpin = int.parse(dp);
    var total =
        ((context.read<PCart>().totalPrice2) * rate) * (1 - (diskon / 100)) -
            dpp -
            addesdiskon;
    if (rate <= 2) {
      return '\$ ${CurrencyFormat.convertToDollar(total, 0)}';
    } else {
      return CurrencyFormat.convertToIdr(total, 0);
    }
  }

  String get totalPriceAPI {
    // var dpin = int.parse(dp);
    var total =
        ((context.read<PCart>().totalPrice2) * rate) * (1 - (diskon / 100)) -
            dpp -
            addesdiskon;
    return total.toString();
  }

  String get totalDiskonRp {
    // var dpin = int.parse(dp);
    var total1 =
        ((context.read<PCart>().totalPrice2) * rate) * (1 - (diskon / 100)) -
            dpp -
            addesdiskon;
    var total = ((context.read<PCart>().totalPrice2) * rate);
    var result = total - total1;

    return result.toString();
  }

  String get totalRp {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCart>().totalPrice2) * rate);
    return total.toString();
  }

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'please wait ..', progressBgColor: Colors.red);
  }

  @override
  void initState() {
    super.initState();
    numberFocusNode.addListener(() {
      bool hasFocus = numberFocusNode.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    numberFocusNode2.addListener(() {
      bool hasFocus = numberFocusNode2.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    // Clean up the focus node
    numberFocusNode.dispose();
    numberFocusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Billing Information",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(4),
              children: <Widget>[
                ///************************[dropdownBuilder examples]********************************///
                // const Text("Pilih Toko"),
                // const Divider(),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.all(4)),
                    Expanded(
                      child: DropdownSearch<UserModel>(
                        asyncItems: (String? filter) => getData(filter),
                        popupProps: PopupPropsMultiSelection.modalBottomSheet(
                          showSelectedItems: true,
                          itemBuilder: _customPopupItemBuilderExample2,
                          showSearchBox: true,
                        ),
                        compareFn: (item, sItem) => item.id == sItem.id,
                        onChanged: (item) {
                          setState(() {
                            // print(text);
                            print('toko : ${item?.name}');
                            print('id  : ${item?.id}');
                            print('diskonnya  : ${item?.diskon_customer}');
                            idtoko = item?.id; // menyimpan id toko
                            toko = item?.name; // menyimpan nama toko
                          });
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Choose customer',
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
                //jenis form
                const SizedBox(
                  height: 10,
                ),
                const Text("Select type of form"),
                const Divider(),
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.all(4)),
                    Expanded(
                      child: DropdownSearch<String>(
                        items: const ["INVOICE", "TITIPAN", "PAMERAN"],
                        onChanged: (text) {
                          setState(() {
                            form = text;
                            if (form == "INVOICE") {
                              idform = 1;
                              idformAPI = 1;
                              print(idform);
                            } else if (form == "TITIPAN") {
                              idform = 2;
                              idformAPI = 2;

                              print(idform);
                            } else if (form == "PAMERAN") {
                              idform = 3;
                              idformAPI = 2;

                              print(idform);
                            } else {
                              idform = 0;
                              idformAPI = 0;

                              print(idform);
                            }
                          });
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Jenis Form',
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

                //rate
                const SizedBox(
                  height: 10,
                ),
                const Text("Rate"),
                const Divider(),
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
                const SizedBox(
                  height: 10,
                ),
                const Text("Basic Diskon"),
                const Divider(),
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

                // addesdiskon
                const SizedBox(
                  height: 10,
                ),
                const Text("ADD DISKON"),
                const Divider(),
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
                    focusNode: numberFocusNode,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),

                //DP
                const SizedBox(
                  height: 10,
                ),
                const Text("DP"),
                const Divider(),
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
                    focusNode: numberFocusNode2,
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: CustomLoadingButton(
            controller: btnController,
            onPressed: () {
              formValidation();
            },
            child: const Text(
              "Save Transaction",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }

  formValidation() async {
    if (toko == null) {
      btnController.error(); //error
    } else {
      await postAPIsales();
      btnController.success(); //sucses
      context.read<PCart>().clearCart(); //clear cart
      Navigator.push(context,
          MaterialPageRoute(builder: (c) => const MySplashScreenTransaksi()));
    }
  }

  Widget _customPopupItemBuilderExample2(
    BuildContext context,
    UserModel? item,
    bool isSelected,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.name ?? ''), // menampilkan nama
        subtitle: Text(item?.alamat?.toString() ?? ''), // menampilkan alamat
      ),
    );
  }

  Future<List<UserModel>> getData(filter) async {
    String token = sharedPreferences!.getString("token").toString();
    var response = await Dio().get(
      ApiConstants.baseUrl + ApiConstants.GETcustomerendpoint,
      options: Options(headers: {"Authorization": 'Bearer $token'}),
      queryParameters: {"filter": filter},
    );

    final data = response.data;
    if (data != null) {
      return UserModel.fromJsonList(data);
    }

    return [];
  }

  postAPIsales() async {
    String token = sharedPreferences!.getString("token").toString();
    String cart_total = context.read<PCart>().totalPrice2.toString();
    String cart_totalquantity = context.read<PCart>().count.toString();
    String bayar = dpp.toString();
    String customer_id = idtoko.toString();
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
      'customer_id': customer_id,
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
    final response = await http.post(
        Uri.parse(
            ApiConstants.baseUrl + ApiConstants.POSTsalescheckoutendpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
  }
}

 // bottomNavigationBar: BottomAppBar(
        //     child: ElevatedButton(
        //   onPressed: () {
        //     showModalBottomSheet(
        //         context: context,
        //         builder: (context) => SizedBox(
        //               height: MediaQuery.of(context).size.height * 0.3,
        //               child: Padding(
        //                 padding: const EdgeInsets.only(bottom: 100),
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                   children: [
        //                     Text(
        //                       'Total : $totalPrice3',
        //                       style: const TextStyle(fontSize: 24),
        //                     ),
        //                     ElevatedButton(
        //                         style: ElevatedButton.styleFrom(
        //                             backgroundColor:
        //                                 Colors.black), // set the backgroun
        //                         onPressed: () async {
        //                           showProgress();

        //                           if (idform == 1) {
        //                             print("invoice");
        //                             await postAPIsales();
        //                             //invoice
        //                             for (var item
        //                                 in context.read<PCart>().getItems) {
        //                               //real bawah
        //                               //delete semua items karena akan pindah ke all transaksi details
        //                               // var apiProvider = ApiServices();
        //                               // await apiProvider.getAllDetailTransaksi();
        //                               // await apiProvider.getAllTransaksi();
        //                               // print('inserting API');
        //                               //update posisi id ke firestore
        //                               // await FirebaseFirestore.instance
        //                               //     .runTransaction((transaction) async {
        //                               //   DocumentReference documentReference =
        //                               //       FirebaseFirestore.instance
        //                               //           .collection("allitems")
        //                               //           .doc(item.name);
        //                               //   transaction.update(documentReference, {
        //                               //     'posisi_id':
        //                               //         "100", //ganti posisi sales (3) menjadi terjual (100)
        //                               //     'customer_id': idtoko
        //                               //         .toString(), //tambahkan customer id agar tahu terjual oleh tko mana
        //                               //     'qty': 0 //set qty menjadi 0
        //                               //   });
        //                               // });

        //                               // delete all items id
        //                               // FirebaseFirestore.instance
        //                               //     .collection('allitems')
        //                               //     .doc(item.name)
        //                               //     .delete();
        //                             }
        //                             // print('delete data firebase berhasil');
        //                             context
        //                                 .read<PCart>()
        //                                 .clearCart(); //clear cart
        //                             Navigator.push(
        //                                 context,
        //                                 MaterialPageRoute(
        //                                     builder: (c) =>
        //                                         const MySplashScreenTransaksi()));
        //                           } else if (idform == 2) {
        //                             //titipan
        //                             await postAPIsales();
        //                             // for (var item
        //                             //     in context.read<PCart>().getItems) {
        //                             //   CollectionReference orderRef =
        //                             //       FirebaseFirestore.instance
        //                             //           .collection('allitemstoko');
        //                             //   await orderRef.doc(item.name).set({
        //                             //     'brand_id': 9999,
        //                             //     'category_id': '1',
        //                             //     'created_at': DateTime.now(),
        //                             //     'customer_id': idtoko.toString(),
        //                             //     'description': item.description,
        //                             //     'id': item.documentId,
        //                             //     'image_name': item.imageUrl,
        //                             //     'keterangan_barang':
        //                             //         item.keterangan_barang,
        //                             //     'kode_refrensi': 'null',
        //                             //     'name': item.name,
        //                             //     'posisi_id': 2,
        //                             //     'price':
        //                             //         item.price, //harus int atau double
        //                             //     'qty': 1, //harus int
        //                             //     'sales_id': int.parse(id!),
        //                             //     'slug': item.name,
        //                             //     'status_titipan': 0,
        //                             //     'updated_at': DateTime.now()
        //                             //   });
        //                             //   // delete all items id
        //                             //   // FirebaseFirestore.instance
        //                             //   //     .collection('allitems')
        //                             //   //     .doc(item.name)
        //                             //   //     .delete();
        //                             // }
        //                             // print('delete data firebase berhasil');
        //                             context.read<PCart>().clearCart();
        //                             Navigator.push(
        //                                 context,
        //                                 MaterialPageRoute(
        //                                     builder: (c) =>
        //                                         const MySplashScreenTransaksi()));
        //                           } else if (idform == 3) {
        //                             //PAMERAN
        //                             await postAPIsales();
        //                             // for (var item
        //                             //     in context.read<PCart>().getItems) {
        //                             //   CollectionReference orderRef =
        //                             //       FirebaseFirestore.instance
        //                             //           .collection('allitemstoko');
        //                             //   await orderRef.doc(item.name).set({
        //                             //     'brand_id': 9999,
        //                             //     'category_id': '1',
        //                             //     'created_at': DateTime.now(),
        //                             //     'customer_id': idtoko.toString(),
        //                             //     'description': item.description,
        //                             //     'id': int.parse(item.documentId),
        //                             //     'image_name': item.imageUrl,
        //                             //     'keterangan_barang':
        //                             //         item.keterangan_barang,
        //                             //     'kode_refrensi': 'null',
        //                             //     'name': item.name,
        //                             //     'posisi_id': 2,
        //                             //     'price':
        //                             //         item.price, //harus int atau double
        //                             //     'qty': 1, //harus int
        //                             //     'sales_id': int.parse(id!),
        //                             //     'slug': item.name,
        //                             //     'status_titipan': 1,
        //                             //     'updated_at': DateTime.now()
        //                             //   });

        //                             //   // delete all items id
        //                             //   // FirebaseFirestore.instance
        //                             //   //     .collection('allitems')
        //                             //   //     .doc(item.name)
        //                             //   //     .delete();
        //                             // }
        //                             // print('delete data firebase berhasil');

        //                             context.read<PCart>().clearCart();
        //                             Navigator.push(
        //                                 context,
        //                                 MaterialPageRoute(
        //                                     builder: (c) =>
        //                                         const MySplashScreenTransaksi()));
        //                           }
        //                         },
        //                         child: const Text('Save'))
        //                   ],
        //                 ),
        //               ),
        //             ));
        //   },
        //   child: const Text('Save Transaksi'),
        // )),