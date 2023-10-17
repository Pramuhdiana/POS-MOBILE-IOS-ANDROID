// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, use_build_context_synchronously, unused_local_variable, unused_element, prefer_const_constructors, unnecessary_new, prefer_collection_literals, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/event/add_customer_event.dart';
import 'package:e_shop/event/cart_event_screen.dart';
import 'package:e_shop/models/user_model.dart';
import 'package:e_shop/provider/provider_cart_event.dart';
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

class TransaksiScreenEvent extends StatefulWidget {
  const TransaksiScreenEvent({super.key});

  @override
  _TransaksiScreenEventState createState() => _TransaksiScreenEventState();
}

class _TransaksiScreenEventState extends State<TransaksiScreenEvent> {
  FocusNode numberFocusNode = FocusNode();
  FocusNode numberFocusNode2 = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
  String? idBarang = '';

  final _formKey = GlobalKey<FormState>();

  double get totalPrice {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        dpp -
        addesdiskon;
    return total;
  }

  double get upto10 {
    // var dpin = int.parse(dp);
    var totalAwal = ((context.read<PCartEvent>().totalPrice2) * rate) *
        (1 - (diskon / 100));
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
        (1 - (diskon / 100));
    var max10 = totalAwal - (total * (1 - (10 / 100)));
    return max10;
  }

  String get totalPrice3 {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        dpp -
        addesdiskon;
    if (rate <= 2) {
      return 'Rp. ${CurrencyFormat.convertToDollar(total, 0)}';
    } else {
      return CurrencyFormat.convertToIdr(total, 0);
    }
  }

  String get totalPriceAPI {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        dpp -
        addesdiskon;
    return total.toString();
  }

  String get totalDiskonRp {
    // var dpin = int.parse(dp);
    var total1 = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        dpp -
        addesdiskon;
    var total = ((context.read<PCartEvent>().totalPrice2) * rate);
    var result = total - total1;

    return result.toString();
  }

  String get totalRp {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartEvent>().totalPrice2) * rate);
    return total.toString();
  }

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'please wait ..', progressBgColor: Colors.red);
  }

  @override
  void initState() {
    super.initState();
    idBarang = sharedPreferences!.getString('idBarang');
    idBarang == '4' ? rate = 1 : rate = 15000;
    print(idBarang);
    sharedPreferences!.getString('role_sales_brand') == '3'
        ? idform = 2
        : idform = 0;
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
            "Billing Event",
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const CartEventScreen()));
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
                //choose customer
                sharedPreferences!.getString('role_sales_brand') == '3'
                    ? SizedBox()
                    : Container(
                        padding: const EdgeInsets.only(top: 10),
                        height: 80,
                        child: DropdownSearch<UserModel>(
                          asyncItems: (String? filter) => getData(filter),
                          popupProps: PopupPropsMultiSelection.modalBottomSheet(
                            searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                              labelText: "Search..",
                              prefixIcon: Icon(Icons.search),
                              //fungsi add customer
                              suffixIcon: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) =>
                                                AddCustomerEventScreen()));
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  )),
                            )),
                            showSelectedItems: true,
                            itemBuilder: _customPopupItemBuilderExample2,
                            showSearchBox: true,
                          ),
                          compareFn: (item, sItem) => item.id == sItem.id,
                          onChanged: (item) {
                            setState(() {
                              idform = 1;
                              idformAPI = 1;
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

                //Rate
                // idform == 0
                //     ? const SizedBox()
                //     : idform == 4
                //         ? const SizedBox()
                //         : sharedPreferences!.getString('role_sales_brand') ==
                //                 '3'
                //             ? const SizedBox()
                //             : Container(
                //                 padding: const EdgeInsets.only(top: 10),
                //                 height: 80,
                //                 child: DropdownSearch<int>(
                //                   items: const [11500, 11900, 13000],
                //                   onChanged: (value) {
                //                     setState(() {
                //                       rate = value!;
                //                     });
                //                   },
                //                   dropdownDecoratorProps:
                //                       DropDownDecoratorProps(
                //                     dropdownSearchDecoration: InputDecoration(
                //                       labelText: "Rate",
                //                       filled: true,
                //                       fillColor: Theme.of(context)
                //                           .inputDecorationTheme
                //                           .fillColor,
                //                     ),
                //                   ),
                //                 ),
                //               ),

                //Basic Diskon
                // if (idform != 4 &&
                //     sharedPreferences!.getString('role_sales_brand') != '3')
                idform == 0
                    ? const SizedBox()
                    : idform == 4
                        ? const SizedBox()
                        : sharedPreferences!.getString('role_sales_brand') ==
                                '3'
                            ? const SizedBox()
                            : idBarang == '4'
                                ? const SizedBox()
                                : Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    height: 80,
                                    child: DropdownSearch<int>(
                                      items: const [48, 49, 50],
                                      onChanged: (value) {
                                        setState(() {
                                          diskon = value!;
                                        });
                                      },
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
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
                        : sharedPreferences!.getString('role_sales_brand') ==
                                '3'
                            ? const SizedBox()
                            : idBarang == '4'
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
                                        print(upto10);
                                        addDiskon.isEmpty
                                            ? setState(() {
                                                addesdiskon = 0;
                                              })
                                            : setState(() {
                                                addesdiskon =
                                                    int.parse(addDiskon);
                                              });
                                        addesdiskon > upto10
                                            ? showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                    title: const Text(
                                                      'Diskon tambahan melebihi limit',
                                                    ),
                                                  );
                                                })
                                            : print('oke');
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Add discount",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                      ),
                                    ),
                                  ),

                // //DP
                // idform == 0
                //     ? const SizedBox()
                //     : idform == 4
                //         ? const SizedBox()
                //         : sharedPreferences!.getString('role_sales_brand') ==
                //                 '3'
                //             ? const SizedBox()
                //             : Container(
                //                 padding: const EdgeInsets.only(top: 10),
                //                 height: 80,
                //                 child: TextFormField(
                //                   style: const TextStyle(
                //                       fontSize: 14,
                //                       color: Colors.black,
                //                       fontWeight: FontWeight.bold),
                //                   textInputAction: TextInputAction.next,
                //                   controller: dp,
                //                   focusNode: numberFocusNode2,
                //                   keyboardType: TextInputType.number,
                //                   inputFormatters: <TextInputFormatter>[
                //                     FilteringTextInputFormatter.digitsOnly
                //                   ],
                //                   onChanged: (dp) {
                //                     dp.isEmpty
                //                         ? setState(() {
                //                             dpp = 0;
                //                           })
                //                         : setState(() {
                //                             dpp = int.parse(dp);
                //                           });
                //                   },
                //                   decoration: InputDecoration(
                //                     labelText: "DP",
                //                     border: OutlineInputBorder(
                //                         borderRadius:
                //                             BorderRadius.circular(5.0)),
                //                   ),
                //                 ),
                //               ),
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
        bottomNavigationBar: idform == 0
            ? const SizedBox()
            : addesdiskon > upto10
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: CustomLoadingButton(
                      controller: btnController,
                      onPressed: () async {
                        await postAPI();
                        btnController.success(); //sucses
                        context.read<PCartEvent>().clearCart(); //clear cart
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) =>
                                    const MySplashScreenTransaksi()));
                      },
                      child: const Text(
                        "Save Transaction",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ));
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
      ApiConstants.baseUrl + ApiConstants.GETcustomerMetier,
      options: Options(headers: {"Authorization": 'Bearer $token'}),
      queryParameters: {"filter": filter},
    );

    final data = response.data;
    if (data != null) {
      return UserModel.fromJsonList(data);
    }

    return [];
  }

  postAPI() async {
    String token = sharedPreferences!.getString("token").toString();
    String cart_total = context.read<PCartEvent>().totalPrice2.toString();
    String cart_totalquantity = context.read<PCartEvent>().count.toString();
    String customer_id = '440'; //id beliberlian
    String jenisform_id = '1';
    String basicdiskon = diskon.toString();
    String customerbeliberlian = idtoko.toString();
    String pajak = '0';
    String rate = '15000';
    String total = totalRp;
    String total_potongan = totalDiskonRp;
    String totalkurangdiskon = totalPriceAPI;
    String totalkurangpajak = totalRp;
    String addesdiskonApi = addesdiskon.toString();
    print('cart_total : $cart_total');
    print('cart_totalquantity : $cart_totalquantity');
    print('customer_id : $customer_id');
    print('jenisform_id : $jenisform_id');
    print('basicdiskon : $basicdiskon');
    print('customerbeliberlian : $customerbeliberlian');
    print('pajak : $pajak');
    print('total : $total');
    print('total_potongan : $total_potongan');
    print('totalkurangdiskon : $totalkurangdiskon');
    print('totalkurangpajak : $totalkurangpajak');
    print('addesdiskonApi : $addesdiskonApi');
    Map<String, String> body = {
      'cart_total': cart_total,
      'cart_totalquantity': cart_totalquantity, //total item di cart
      'customer_id': customer_id,
      'jenisform_id': jenisform_id,
      'basic_discount': basicdiskon,
      'customerbeliberlian': customerbeliberlian,
      'pajak': pajak,
      'rate': rate,
      'total': total,
      'total_potongan': total_potongan,
      'totalkurangdiskon': totalkurangdiskon,
      'totalkurangpajak': totalkurangpajak,
      'addesdiskon': addesdiskonApi,
    };
    final response = await http.post(
        Uri.parse(ApiConstants.baseUrl +
            ApiConstants.POSTtokobeliberliancheckoutendpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
  }
}
