// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, use_build_context_synchronously, non_constant_identifier_names, unused_import

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/api/api_services.dart';
import 'package:e_shop/database/db_alldetailtransaksi.dart';
import 'package:e_shop/database/db_alltransaksi.dart';
import 'package:e_shop/database/db_alltransaksi_baru.dart';
import 'package:e_shop/global/currency_format.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/models/customer_metier.dart';
import 'package:e_shop/splashScreen/my_splas_screen_transaksi.dart';
import 'package:e_shop/splashScreen/transaksi_gagal.dart';
import 'package:e_shop/widgets/custom_dialog.dart';
import 'package:e_shop/widgets/custom_loading.dart';
import 'package:e_shop/widgets/keyboard_overlay.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../provider/provider_cart_toko.dart';
import 'package:http/http.dart' as http;

class TransaksiScreenToko extends StatefulWidget {
  const TransaksiScreenToko({super.key});

  @override
  _TransaksiScreenTokoState createState() => _TransaksiScreenTokoState();
}

class _TransaksiScreenTokoState extends State<TransaksiScreenToko> {
  FocusNode numberFocusNode = FocusNode();
  FocusNode numberFocusNode2 = FocusNode();
  RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  String qty = '';
  String orderId = DateTime.now().second.toString();
  String? form;
  String? toko;
  int idform = 0;
  int idformAPI = 0;
  int idtoko = 0;
  int rate = 1;
  int result = 0;
  double diskon = 0;
  int dpp = 0;
  String? taxApi = '0';
  String? totalPaymentApi = '0';
  int customerMetierId = 0;
  int addesdiskon = 0;
  TextEditingController dp = TextEditingController();
  TextEditingController customerMetier = TextEditingController();
  TextEditingController addDiskon = TextEditingController();
  // int DPP = int.parse(dp);
  List<double> listDiskon = [];
  List<int> listRate = [];

  final _formKey = GlobalKey<FormState>();

  double get totalPrice {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartToko>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        dpp -
        addesdiskon;
    return total;
  }

  String get totalPrice3 {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartToko>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        dpp -
        addesdiskon;
    if (rate <= 2) {
      return sharedPreferences!.getString('role_sales_brand') == '3'
          ? 'Rp.${CurrencyFormat.convertToDollar(total, 0)}'
          : '\$${CurrencyFormat.convertToDollar(total, 0)}';
    } else {
      return CurrencyFormat.convertToIdr(total, 0);
    }
  }

  String get totalPriceAPI {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartToko>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        dpp -
        addesdiskon;
    return total.toString();
  }

  String get totalDiskonRp {
    // var dpin = int.parse(dp);
    var total1 = ((context.read<PCartToko>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        dpp -
        addesdiskon;
    var total = ((context.read<PCartToko>().totalPrice2) * rate);
    var result = total - total1;

    return result.toString();
  }

  String get totalRp {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartToko>().totalPrice2) * rate);
    return 'Rp.${CurrencyFormat.convertToDollar(int.parse(total.round().toString()), 0)}';
  }

  String get totalRpApi {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartToko>().totalPrice2) * rate);
    return total.toString();
  }

  String get tax {
    var total = (((context.read<PCartToko>().totalPrice2) * rate) *
                (1 - (diskon / 100)) -
            dpp -
            addesdiskon) *
        0.022;
    taxApi = total.toString();
    if (rate <= 2) {
      return sharedPreferences!.getString('role_sales_brand') == '3'
          ? 'Rp.${CurrencyFormat.convertToDollar(total, 0)}'
          : '\$${CurrencyFormat.convertToDollar(total, 0)}';
    } else {
      return CurrencyFormat.convertToIdr(total, 0);
    }
  }

  String get totalPayment {
    var totalPrice = ((context.read<PCartToko>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        dpp -
        addesdiskon;
    var totalTax = ((context.read<PCartToko>().totalPrice2) * rate) * (2 / 100);

    var total = totalPrice - totalTax;
    totalPaymentApi = total.toString();
    return 'Rp.${CurrencyFormat.convertToDollar(int.parse(total.round().toString()), 0)}';
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
    getDiskon();
  }

  @override
  void dispose() {
    // Clean up the focus node
    numberFocusNode.dispose();
    numberFocusNode2.dispose();
    super.dispose();
  }

  getDiskon() async {
    listDiskon = [];
    listRate = [];
    String token = sharedPreferences!.getString("token").toString();
    try {
      var url = ApiConstants.baseUrl + ApiConstants.GETlistdiskon;
      Response response = await Dio().get(url,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      var data = response.data;
      for (var i = 0; i < data.length; i++) {
        listDiskon.add(double.parse(data[i]['diskonpersen']));
      }
      setState(() {
        print(listDiskon);
      });
    } catch (e) {
      //*HINTS Panggil fungsi showCustomDialog
      showCustomDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'GET Diskon',
        description: '$e',
      );
    }
    try {
      var urlRate = ApiConstants.baseUrl + ApiConstants.GETlistrate;
      Response response = await Dio().get(urlRate,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      var dataRate = response.data;
      for (var i = 0; i < dataRate.length; i++) {
        listRate.add(int.parse(dataRate[i]['rate']));
      }
      setState(() {
        print(listRate);
      });
    } catch (e) {
      //*HINTS Panggil fungsi showCustomDialog
      showCustomDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'GET Rate',
        description: '$e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                //jenis form
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  height: 80,
                  child: DropdownSearch<String>(
                    items: const ["INVOICE", "KEMBALI BARANG"],
                    onChanged: (text) {
                      setState(() {
                        form = text;
                        if (form == "INVOICE") {
                          idform = 1;
                          idformAPI = 1;
                        } else if (form == "KEMBALI BARANG") {
                          idform = 4;
                          idformAPI = 4;
                          print(idform);
                        } else {
                          idform = 0;
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
                        labelText: "Select type of form",
                        filled: true,
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                    ),
                  ),
                ),

                //Rate
                idform == 0
                    ? const SizedBox()
                    : idform == 4
                        ? const SizedBox()
                        : sharedPreferences!.getString('role_sales_brand') ==
                                '3'
                            ? Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                height: 65,
                                width: 230,
                                child: DropdownSearch<CustomerMetierModel>(
                                  asyncItems: (String? filter) =>
                                      getCustomerMetier(filter),
                                  popupProps: const PopupPropsMultiSelection
                                      .modalBottomSheet(
                                    searchFieldProps: TextFieldProps(
                                        decoration: InputDecoration(
                                      labelText: "Search..",
                                      prefixIcon: Icon(Icons.search),
                                    )),
                                    showSelectedItems: true,
                                    itemBuilder: _listCustomerMetier,
                                    showSearchBox: true,
                                  ),
                                  compareFn: (item, sItem) =>
                                      item.id == sItem.id,
                                  onChanged: (item) {
                                    setState(() {
                                      customerMetier.text = item!.name;
                                      customerMetierId = item.id;
                                    });
                                  },
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Choose customer",
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.only(top: 10),
                                height: 80,
                                child: DropdownSearch<int>(
                                  items: listRate,
                                  onChanged: (value) {
                                    setState(() {
                                      rate = value!;
                                    });
                                  },
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Rate",
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                    ),
                                  ),
                                ),
                              ),

                //Basic Diskon
                idform == 0
                    ? const SizedBox()
                    : idform == 4
                        ? const SizedBox()
                        : sharedPreferences!.getString('role_sales_brand') ==
                                '3'
                            ? const SizedBox()
                            : Container(
                                padding: const EdgeInsets.only(top: 10),
                                height: 80,
                                child: DropdownSearch<double>(
                                  items: (sharedPreferences!
                                                  .getString('customer_id')
                                                  .toString() ==
                                              '520' ||
                                          sharedPreferences!
                                                  .getString('customer_id')
                                                  .toString() ==
                                              '522')
                                      ? const [
                                          50,
                                          53,
                                          55,
                                          60,
                                          61,
                                          62,
                                          60.5,
                                          61.5,
                                          62.5,
                                          63
                                        ]
                                      : listDiskon,
                                  onChanged: (value) {
                                    setState(() {
                                      diskon = value!;
                                    });
                                  },
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Basic discount",
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                    ),
                                  ),
                                ),
                              ),
//addesdiskon

                idform == 0
                    ? const SizedBox()
                    : idform == 4
                        ? const SizedBox()
                        : Container(
                            padding: const EdgeInsets.only(top: 10),
                            height: 80,
                            child: TextFormField(
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textInputAction: TextInputAction.next,
                              controller: addDiskon,
                              focusNode: numberFocusNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (addDiskon) {
                                addDiskon.isEmpty
                                    ? setState(() {
                                        addesdiskon = 0;
                                      })
                                    : setState(() {
                                        addesdiskon = int.parse(addDiskon);
                                      });
                              },
                              decoration: InputDecoration(
                                labelText: "Add discount",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                            ),
                          ),

                //DP
                idform == 0
                    ? const SizedBox()
                    : idform == 4
                        ? const SizedBox()
                        : sharedPreferences!.getString('role_sales_brand') ==
                                '3'
                            ? const SizedBox()
                            : Container(
                                padding: const EdgeInsets.only(top: 10),
                                height: 80,
                                child: TextFormField(
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  textInputAction: TextInputAction.next,
                                  controller: dp,
                                  focusNode: numberFocusNode2,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (dp) {
                                    dp.isEmpty
                                        ? setState(() {
                                            dpp = 0;
                                          })
                                        : setState(() {
                                            dpp = int.parse(dp);
                                          });
                                  },
                                  decoration: InputDecoration(
                                    labelText: "DP",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                ),
                              ),

                idform == 4 ? const SizedBox() : const SizedBox(height: 30),
                idform == 4
                    ? const SizedBox()
                    : const Divider(
                        color: Colors.black,
                        thickness: 5,
                      ),
                idform == 4
                    ? const SizedBox()
                    : sharedPreferences!.getString('role_sales_brand') == '3'
                        ? Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2.5, color: Colors.grey)),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "$totalRp",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.black,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Discount',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      'Rp.${CurrencyFormat.convertToDollar(addesdiskon, 0)}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.black,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'After Disc',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "$totalPrice3",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.black,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Tax',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "$tax",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.black,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Payment',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      // "$totalPayment",
                                      "$totalPrice3",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              const Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text("Total")),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "$totalPrice3",
                                  style: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ),
                            ],
                          ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: idform == 0
            ? const SizedBox()
            : Padding(
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
    if (form == null) {
      btnController.error(); //error
      await Future.delayed(const Duration(seconds: 2)).then((value) {});
      btnController.reset(); //error
      Fluttertoast.showToast(msg: 'Jenis form required');
    } else {
      sharedPreferences!.getString('role_sales_brand') == '3'
          ? await postAPItokoMetier()
          : await postAPItoko();
    }
  }

  Future<List<CustomerMetierModel>> getCustomerMetier(filter) async {
    String token = sharedPreferences!.getString("token").toString();
    var response = await Dio().get(
      ApiConstants.baseUrl + ApiConstants.GETcustomerMetier,
      options: Options(headers: {"Authorization": 'Bearer $token'}),
      queryParameters: {"filter": filter},
    );

    final data = response.data;
    if (data != null) {
      return CustomerMetierModel.fromJsonList(data);
    }

    return [];
  }

  postAPItoko() async {
    String cart_total = context.read<PCartToko>().totalPrice2.toString();
    String cart_totalquantity = context.read<PCartToko>().count.toString();
    String bayar = dpp.toString();
    String customer_idAPI =
        sharedPreferences!.getString('customer_id').toString();
    String jenisform_id = idformAPI.toString();
    String basicdiskon = diskon.toString();
    String addesdiskonApi = addesdiskon.toString();
    String basicrate = rate.toString();
    String nett = totalPriceAPI;
    String total = totalRpApi;
    String diskon_rupiah = totalDiskonRp;
    String addesdiskon_rupiah = addesdiskon.toString();
    String total_potongan = totalDiskonRp;
    String keterangan_bayar = 'null';
    String token = sharedPreferences!.getString("token").toString();

    Map<String, String> body = {
      'cart_total': cart_total,
      'cart_totalquantity': cart_totalquantity, //total item di cart
      'bayar': bayar,
      'customer_id': customer_idAPI,
      'jenisform_id': jenisform_id,
      'diskon': basicdiskon,
      'addesdiskon': addesdiskonApi,
      'rate': basicrate,
      'nett': nett,
      'total': total,
      'diskon_rupiah': diskon_rupiah,
      'addesdiskon_rupiah': addesdiskon_rupiah,
      'total_potongan': total_potongan,
      'keterangan_bayar': keterangan_bayar
    };
    try {
      final response = await http.post(
          Uri.parse(
              ApiConstants.baseUrl + ApiConstants.POSTtokocheckoutendpoint),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
          },
          body: body);
      if (response.statusCode != 200) {
        btnController.error(); //sucses
        btnController.reset();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => TransaksiGagal(
                      title: 'Transaksi Toko gagal',
                      err: '${response.body}',
                    )));
      } else {
        print(response.body);
        context.read<PCartToko>().clearCart(); //clear cart
        await DbAlldetailtransaksi.db.deleteAlldetailtransaksi();
        await DbAlltransaksi.db.deleteAlltransaksiBaru();
        var apiProvider = ApiServices();
        await apiProvider.getAllTransaksiBaru();
        await apiProvider.getAllDetailTransaksi();
        btnController.success(); //sucses
        Navigator.push(context,
            MaterialPageRoute(builder: (c) => const MySplashScreenTransaksi()));
      }
    } catch (c) {
      btnController.error(); //sucses
      btnController.reset();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => TransaksiGagal(
                    title: 'Transaksi Toko gagal',
                    err: '$c',
                  )));
    }
  }

  postAPItokoMetier() async {
    String cart_total = context.read<PCartToko>().totalPrice2.toString();
    String cart_totalquantity = context.read<PCartToko>().count.toString();
    String customer_idAPI =
        sharedPreferences!.getString('customer_id').toString();
    String jenisform_id = idformAPI.toString();
    String customermetier = customerMetierId.toString();
    String pajak = taxApi!;
    String addesdiskonApi = addesdiskon.toString();

    String total_potongan = totalDiskonRp;
    String totalKurangDiskon = totalPrice.toString();
    String totalKurangPajak = totalPrice.toString();
    String token = sharedPreferences!.getString("token").toString();

    Map<String, String> body = {
      'cart_total': cart_total,
      'cart_totalquantity': cart_totalquantity, //total item di cart
      'customer_id': customer_idAPI,
      'jenisform_id': jenisform_id,
      'diskon': total_potongan,
      'addesdiskon': addesdiskonApi,
      'customermetier': customermetier,
      'pajak': pajak,
      'total': cart_total,
      'diskon_rupiah': total_potongan,
      'total_potongan': total_potongan,
      'totalkurangdiskon': totalKurangDiskon,
      'totalkurangpajak': totalKurangPajak,
      'totalpembayaran': totalKurangDiskon
    };
    print(body);
    try {
      final response = await http.post(
          Uri.parse(ApiConstants.baseUrl +
              ApiConstants.POSTtokometiercheckoutendpoint),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
          },
          body: body);
      if (response.statusCode != 200) {
        btnController.error(); //sucses
        btnController.reset();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => TransaksiGagal(
                      title: 'Transaksi Toko gagal',
                      err: '${response.body}',
                    )));
      } else {
        context.read<PCartToko>().clearCart(); //clear cart
        await DbAlldetailtransaksi.db.deleteAlldetailtransaksi();
        await DbAlltransaksi.db.deleteAlltransaksiBaru();
        var apiProvider = ApiServices();
        await apiProvider.getAllTransaksiBaru();
        await apiProvider.getAllDetailTransaksi();
        btnController.success(); //sucses
        Navigator.push(context,
            MaterialPageRoute(builder: (c) => const MySplashScreenTransaksi()));
      }
    } catch (c) {
      btnController.error(); //sucses
      btnController.reset();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => TransaksiGagal(
                    title: 'Transaksi Toko gagal',
                    err: '$c',
                  )));
    }
  }
}

Widget _listCustomerMetier(
  BuildContext context,
  CustomerMetierModel? item,
  bool isSelected,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Colors.black, width: 5),
            borderRadius: BorderRadius.circular(50),
          ),
    child: ListTile(
      selected: isSelected,
      title: Text(item?.name ?? ''),
    ),
  );
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
