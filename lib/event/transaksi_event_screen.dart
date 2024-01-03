// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, use_build_context_synchronously, unused_local_variable, unused_element, prefer_const_constructors, unnecessary_new, prefer_collection_literals, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/api/api_services.dart';
import 'package:e_shop/database/db_alldetailtransaksi.dart';
import 'package:e_shop/database/db_alltransaksi_baru.dart';
import 'package:e_shop/event/add_customer_event.dart';
import 'package:e_shop/event/cart_event_screen.dart';
import 'package:e_shop/models/user_model.dart';
import 'package:e_shop/provider/provider_cart_event.dart';
import 'package:e_shop/splashScreen/my_splas_screen_transaksi.dart';
import 'package:e_shop/widgets/custom_loading.dart';
import 'package:e_shop/widgets/keyboard_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
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
  String? kodeVocher;
  int nilaiVocher = 0;
  bool isClear = false;
  int getLimitAddDis1 = 0;
  int getLimitAddDis2 = 0;

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
  bool isGift = false;
  int diskon = 0;
  TextEditingController dp = TextEditingController();
  TextEditingController addDiskon = TextEditingController();
  TextEditingController addDiskon2 = TextEditingController();
  int dpp = 0;
  int addesdiskon = 0;
  int addesdiskon2 = 0;
  String? idBarang = '';

  final _formKey = GlobalKey<FormState>();

  double get totalPrice {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        dpp -
        addesdiskon -
        addesdiskon2;
    return total;
  }

  double get limitDis1 {
    // var dpin = int.parse(dp);
    var totalAwal = ((context.read<PCartEvent>().totalPrice2) * rate) *
        (1 - (diskon / 100));
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
        (1 - (diskon / 100));
    var max10 = totalAwal - (total * (1 - (getLimitAddDis1 / 100)));
    return max10;
  }

  double get limitDis2 {
    // var dpin = int.parse(dp);
    var totalAwal = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        addesdiskon;
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        addesdiskon;
    var max10 = totalAwal - (total * (1 - (getLimitAddDis2 / 100)));
    return max10;
  }

  double get disAdd1 {
    var totalAwal = ((context.read<PCartEvent>().totalPrice2) * rate) *
        (1 - (diskon / 100));
    var addDis1 = addesdiskon;
    var result = (addDis1 / totalAwal) * 100;
    return result;
  }

  double get disAdd2 {
    var totalAwal = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        addesdiskon;
    var addDis2 = addesdiskon2;
    var result = (addDis2 / totalAwal) * 100;

    return addDiskon.text.isEmpty ? 0 : result;
  }

  String get totalPrice3 {
    // var dpin = int.parse(dp);

    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        dpp -
        addesdiskon -
        nilaiVocher -
        addesdiskon2;
    if (isGift != true) {
      if (rate <= 2) {
        return 'Rp. ${CurrencyFormat.convertToDollar(total, 0)}';
      } else {
        return CurrencyFormat.convertToIdr(total, 0);
      }
    } else {
      return CurrencyFormat.convertToIdr(0, 0);
    }
  }

  String get totalPriceAPI {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        dpp -
        addesdiskon -
        addesdiskon2;
    return total.toString();
  }

  String get totalDiskonRp {
    // var dpin = int.parse(dp);
    var total1 = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) -
        dpp -
        addesdiskon -
        addesdiskon2;
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
    print('ini bit:${sharedPreferences!.getInt('panjangHarga')}');
    getLimitDiskon();
    idBarang = sharedPreferences!.getString('idBarang');
    sharedPreferences!.getInt('panjangHarga')! > 17
        ? rate = 1
        : idBarang == '4'
            ? rate = 1
            : rate = 15000;
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

  getLimitDiskon() async {
    String token = sharedPreferences!.getString("token").toString();
    var url = ApiConstants.baseUrl + ApiConstants.GETlimitdiskon;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    print(response.data[0]['addiskon']);
    print(response.data[0]['addiskon2']);
    getLimitAddDis1 = int.parse(response.data[0]['addiskon'] ?? '0');
    getLimitAddDis2 = int.parse(response.data[0]['addiskon2'] ?? '0');
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
                              //* fungsi add customer
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
                              //! end fungsi
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
                    // : idform == 4
                    //     ? const SizedBox()
                    //     : sharedPreferences!.getString('role_sales_brand') ==
                    //             '3'
                    //         ? const SizedBox()
                    //         : idBarang == '4'
                    //             ? const SizedBox()
                    : Stack(clipBehavior: Clip.none, children: [
                        Positioned(
                          right: 2,
                          bottom: 15,
                          child: Text(
                            '${disAdd1.toStringAsFixed(2)}%',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Positioned(
                          left: 2,
                          bottom: 15,
                          child: Text(
                            'Limit ${getLimitAddDis1.toStringAsFixed(2)}%',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
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
                              print(limitDis1);
                              addDiskon.isEmpty
                                  ? setState(() {
                                      addesdiskon = 0;
                                      addesdiskon2 = 0;
                                      addDiskon2.clear();
                                    })
                                  : setState(() {
                                      addesdiskon = int.parse(addDiskon);
                                    });
                              addesdiskon > limitDis1
                                  ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          title: const Text(
                                            'Diskon tambahan melebihi limit',
                                          ),
                                        );
                                      })
                                  : print('oke');
                            },
                            decoration: InputDecoration(
                              labelText: "Add discount 1",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                        ),
                      ]),

                idform == 0
                    ? const SizedBox()
                    : addDiskon.text.isEmpty
                        ? const SizedBox()
                        : Stack(clipBehavior: Clip.none, children: [
                            Positioned(
                              right: 2,
                              bottom: 15,
                              child: Text(
                                addDiskon.text.isEmpty
                                    ? '0'
                                    : '${disAdd2.toStringAsFixed(2)}%',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Positioned(
                              left: 2,
                              bottom: 15,
                              child: Text(
                                'Limit ${getLimitAddDis2.toStringAsFixed(2)}%',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              height: 80,
                              child: TextFormField(
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                textInputAction: TextInputAction.next,
                                controller: addDiskon2,
                                focusNode: numberFocusNode2,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (addDiskon2) {
                                  print(limitDis2);
                                  addDiskon2.isEmpty
                                      ? setState(() {
                                          addesdiskon2 = 0;
                                        })
                                      : setState(() {
                                          addesdiskon2 = int.parse(addDiskon2);
                                        });
                                  addesdiskon2 > limitDis2
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              title: const Text(
                                                'Diskon tambahan melebihi limit',
                                              ),
                                            );
                                          })
                                      : print('oke');
                                },
                                decoration: InputDecoration(
                                  labelText: "Add discount 2",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                              ),
                            ),
                          ]),
                // //DP
                idform == 0
                    ? const SizedBox()
                    : idform == 4
                        ? const SizedBox()
                        : totalPrice < 5000000.00
                            ? Row(
                                children: [
                                  Container(
                                    width: 225,
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 0),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: kodeVocher != null
                                              ? Colors.black
                                              : const Color.fromRGBO(
                                                  238,
                                                  240,
                                                  235,
                                                  1), //background color of dropdown button
                                          border: Border.all(
                                              color: Colors.black38,
                                              width:
                                                  3), //border of dropdown button
                                          borderRadius: BorderRadius.circular(
                                              50), //border raiuds of dropdown button
                                          boxShadow: const <BoxShadow>[
                                            //apply shadow on Dropdown button
                                            BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0,
                                                    0.57), //shadow for button
                                                blurRadius:
                                                    5) //blur radius of shadow
                                          ]),
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: DropdownButton(
                                            value: kodeVocher,
                                            items: const [
                                              //add items in the dropdown
                                              DropdownMenuItem(
                                                value: "50000",
                                                child: Text("BB50RB"),
                                              ),
                                              DropdownMenuItem(
                                                value: "100000",
                                                child: Text("BB100RB"),
                                              ),
                                            ],
                                            hint: const Text('Select a cupon'),
                                            onChanged: (value) {
                                              print("You have selected $value");
                                              setState(() {
                                                kodeVocher = value;
                                                nilaiVocher =
                                                    int.parse(kodeVocher!);
                                                isClear = true;
                                              });
                                            },
                                            icon: const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: Icon(Icons
                                                    .arrow_circle_down_sharp)),
                                            iconEnabledColor: kodeVocher != null
                                                ? Colors.white //Icon color
                                                : Colors.black, //Icon color
                                            style: TextStyle(
                                                color: kodeVocher != null
                                                    ? Colors.white
                                                    : Colors.black, //Font color
                                                fontSize:
                                                    15 //font size on dropdown button
                                                ),

                                            dropdownColor: kodeVocher != null
                                                ? Colors.black
                                                : Colors
                                                    .white, //dropdown background color
                                            underline:
                                                Container(), //remove underline
                                            isExpanded:
                                                true, //make true to make width 100%
                                          )),
                                    ),
                                  ),
                                  isClear == false
                                      ? SizedBox(
                                          height: 20,
                                        )
                                      : SizedBox(
                                          width: 80,
                                          child: InkResponse(
                                            onTap: () {
                                              setState(() {
                                                kodeVocher = null;
                                                nilaiVocher = 0;
                                                isClear = false;
                                              });
                                            },
                                            child: Lottie.asset(
                                                "json/icon_delete.json"),
                                            // child: const CircleAvatar(
                                            //   backgroundColor: Colors.red,
                                            //   child: Icon(Icons.close),
                                            // ),
                                          ),
                                        )
                                ],
                              )
                            : Row(
                                children: [
                                  Container(
                                    width: 225,
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 0),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: kodeVocher != null
                                              ? Colors.black
                                              : const Color.fromRGBO(
                                                  238,
                                                  240,
                                                  235,
                                                  1), //background color of dropdown button
                                          border: Border.all(
                                              color: Colors.black38,
                                              width:
                                                  3), //border of dropdown button
                                          borderRadius: BorderRadius.circular(
                                              50), //border raiuds of dropdown button
                                          boxShadow: const <BoxShadow>[
                                            //apply shadow on Dropdown button
                                            BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0,
                                                    0.57), //shadow for button
                                                blurRadius:
                                                    5) //blur radius of shadow
                                          ]),
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: DropdownButton(
                                            value: kodeVocher,
                                            items: const [
                                              //add items in the dropdown
                                              DropdownMenuItem(
                                                value: "50000",
                                                child: Text("BB50RB"),
                                              ),
                                              DropdownMenuItem(
                                                value: "100000",
                                                child: Text("BB100RB"),
                                              ),
                                              DropdownMenuItem(
                                                value: "500000",
                                                child: Text("BB500RB"),
                                              ),
                                            ],
                                            hint: const Text('Select a cupon'),
                                            onChanged: (value) {
                                              print("You have selected $value");
                                              setState(() {
                                                kodeVocher = value;
                                                nilaiVocher =
                                                    int.parse(kodeVocher!);
                                                isClear = true;
                                              });
                                            },
                                            icon: const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: Icon(Icons
                                                    .arrow_circle_down_sharp)),
                                            iconEnabledColor: kodeVocher != null
                                                ? Colors.white //Icon color
                                                : Colors.black, //Icon color
                                            style: TextStyle(
                                                color: kodeVocher != null
                                                    ? Colors.white
                                                    : Colors.black, //Font color
                                                fontSize:
                                                    15 //font size on dropdown button
                                                ),

                                            dropdownColor: kodeVocher != null
                                                ? Colors.black
                                                : Colors
                                                    .white, //dropdown background color
                                            underline:
                                                Container(), //remove underline
                                            isExpanded:
                                                true, //make true to make width 100%
                                          )),
                                    ),
                                  ),
                                  isClear == false
                                      ? SizedBox(
                                          height: 20,
                                        )
                                      : SizedBox(
                                          width: 80,
                                          child: InkResponse(
                                            onTap: () {
                                              setState(() {
                                                kodeVocher = null;
                                                nilaiVocher = 0;
                                                isClear = false;
                                              });
                                            },
                                            child: Lottie.asset(
                                                "json/icon_delete.json"),
                                            // child: const CircleAvatar(
                                            //   backgroundColor: Colors.red,
                                            //   child: Icon(Icons.close),
                                            // ),
                                          ),
                                        )
                                ],
                              ),

                kodeVocher != null
                    ? Container(
                        padding: EdgeInsets.only(top: 5, left: 15),
                        child: Text(
                          'Diskon Vocher ${CurrencyFormat.convertToIdr(nilaiVocher, 0)}',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ))
                    : SizedBox(),

                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Gift ? ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      Checkbox(
                        value: isGift,
                        onChanged: (bool? value) {
                          setState(() {
                            isGift = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
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
            : addesdiskon > limitDis1 || addesdiskon2 > limitDis2
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: CustomLoadingButton(
                      controller: btnController,
                      onPressed: () async {
                        if (isGift != true) {
                          await postAPI();
                        } else {
                          await postAPIGift();
                        }
                        context.read<PCartEvent>().clearCart(); //clear cart
                        await DbAlldetailtransaksi.db
                            .deleteAlldetailtransaksi();
                        await DbAlltransaksiBaru.db.deleteAlltransaksiBaru();
                        var apiProvider = ApiServices();
                        try {
                          await apiProvider.getAllTransaksiBaru();
                        } catch (c) {
                          Fluttertoast.showToast(
                              msg: "Failed To Load Data all transaksi");
                        }
                        try {
                          await apiProvider.getAllDetailTransaksi();
                        } catch (c) {
                          Fluttertoast.showToast(
                              msg: "Failed To Load Data all details transaksi");
                        }
                        btnController.success(); //sucses

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
    String addesdiskonApi2 = addesdiskon2.toString();
    String nilaiVoucherApi = nilaiVocher.toString();
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
      'addesdiskon2': addesdiskonApi2,
      'voucher_diskon': nilaiVoucherApi,
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

  postAPIGift() async {
    String token = sharedPreferences!.getString("token").toString();
    String cart_total = '0';
    String cart_totalquantity = context.read<PCartEvent>().count.toString();
    String customer_id = '440'; //id beliberlian
    String jenisform_id = '1';
    String basicdiskon = '0';
    String customerbeliberlian = idtoko.toString();
    String pajak = '0';
    String rate = '0';
    String total = '0';
    String total_potongan = '0';
    String totalkurangdiskon = '0';
    String totalkurangpajak = '0';
    String addesdiskonApi = '0';
    String nilaiVoucherApi = '0';
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
      'voucher_diskon': nilaiVoucherApi,
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
