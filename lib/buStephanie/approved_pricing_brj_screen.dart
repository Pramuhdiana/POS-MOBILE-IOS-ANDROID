// ignore_for_file: use_key_in_widget_constructors, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/buStephanie/approve_pricing_model.dart';
import 'package:e_shop/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../global/currency_format.dart';
import '../provider/provider_cart.dart';
import 'package:http/http.dart' as http;

import '../widgets/alert_dialog.dart';
import '../widgets/custom_loading.dart';
import 'item_photo_pricing.dart';

class ApprovedPricingBrjScreen extends StatefulWidget {
  @override
  State<ApprovedPricingBrjScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<ApprovedPricingBrjScreen> {
  String searchInput = '';
  bool isLoading = false;
  FocusNode numberFocusNode = FocusNode();
  TextEditingController price = TextEditingController();
  double awalPrice = 0;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<List<ApprovePricingModel>> fetchData() async {
    // var url = Uri.parse('https://fakestoreapi.com/products');
    var url = Uri.parse(
        ApiConstants.baseUrlPricing + ApiConstants.GETapprovelPricingApproved);

    final response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => ApprovePricingModel.fromJson(data))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.baseUrlPricing +
          ApiConstants.GETapprovelPricingApproved));
      // if response successful
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        var g = jsonResponse
            .map((data) => ApprovePricingModel.fromJson(data))
            .toList();
        setState(() {});
        return g;
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (c) {
      return throw Exception(c);
    }
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    await _getData();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          elevation: 0,
          backgroundColor: Colors.white,
          title: CupertinoSearchTextField(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            itemColor: Colors.black,
            // autofocus: false,
            backgroundColor: Colors.black12,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              setState(() {
                searchInput = value;
              });
            },
          ),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 10),
          //     child: Stack(
          //       children: [
          //         IconButton(
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (c) => const CartScreen()));
          //             // }
          //           },
          //           icon: Padding(
          //             padding: const EdgeInsets.all(2),
          //             child: badges.Badge(
          //               showBadge:
          //                   context.read<PCart>().getItems.isEmpty ? false : true,
          //               badgeStyle: const badges.BadgeStyle(
          //                 badgeColor: Colors.green,
          //               ),
          //               badgeContent: Text(
          //                 context.watch<PCart>().getItems.length.toString(),
          //                 style: const TextStyle(
          //                   fontSize: 8,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //               ),
          //               child: Transform.scale(
          //                 scale: 1.3,
          //                 child: Image.asset(
          //                   "assets/cart.png",
          //                   width: 45,
          //                   height: 45,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ],
        ),
        body: isLoading != false
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: refresh,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 35,
                      child: Text(
                        'Approvad BRJ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: _getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = snapshot.data![index];
                                  awalPrice = data.finalPrice3USD!;
                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) =>
                                                    ItemsPhotoPricing(
                                                      model: ApprovePricingModel(
                                                          lotNo: data.lotNo,
                                                          fgImageFileName: data
                                                              .fgImageFileName),
                                                    )));
                                      },
                                      child: SizedBox(
                                        height: 150,
                                        child: Card(
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      'https://110.5.102.154:50001/Files/Images/Product/${data.fgImageFileName!.toString()}',
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data.lotNo!,
                                                  ),
                                                  Text(data.marketingCode!),
                                                  Text(data.productTypeDesc!),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                    child: Text(
                                                      data.detailProduct!,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // Container(
                                                        //   child:
                                                        //  TextField(
                                                        //   enabled: false,
                                                        //   // selectedOmzet != null ? false : true,
                                                        //   onChanged: (price) {
                                                        //     setState(() {});
                                                        //   },
                                                        //   controller: price,
                                                        //   keyboardType: TextInputType.number,
                                                        //   focusNode: numberFocusNode,
                                                        //   inputFormatters: [
                                                        //     FilteringTextInputFormatter.digitsOnly
                                                        //   ],
                                                        // ),
                                                        Text(
                                                          '\$ ${CurrencyFormat.convertToDollar(awalPrice, 0)}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        // ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  MyAlertDilaog
                                                                      .showMyDialog(
                                                                          context:
                                                                              context,
                                                                          title:
                                                                              'Approve Pricing',
                                                                          content:
                                                                              'Are you sure to approve price ?',
                                                                          tabNo:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          tabYes:
                                                                              () async {
                                                                            setState(() {
                                                                              isLoading = true;
                                                                            });
                                                                            Future.delayed(const Duration(seconds: 1)).then((value) async {
                                                                              setState(() {
                                                                                postApi(data.lotNo!);
                                                                                isLoading = false;
                                                                              });
                                                                            });

                                                                            Navigator.pop(context);
                                                                          });
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .done_sharp,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        // ignore: no_leading_underscores_for_local_identifiers
                                                                        final _formKey =
                                                                            GlobalKey<FormState>();

                                                                        RoundedLoadingButtonController
                                                                            btnController =
                                                                            RoundedLoadingButtonController();
                                                                        return AlertDialog(
                                                                          content:
                                                                              Stack(
                                                                            clipBehavior:
                                                                                Clip.none,
                                                                            children: <Widget>[
                                                                              Positioned(
                                                                                right: -40.0,
                                                                                top: -40.0,
                                                                                child: InkResponse(
                                                                                  onTap: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: const CircleAvatar(
                                                                                    backgroundColor: Colors.red,
                                                                                    child: Icon(Icons.close),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Form(
                                                                                key: _formKey,
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: <Widget>[
                                                                                    Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        'Before : \$ ${CurrencyFormat.convertToDollar(data.finalPrice3USD, 0)}',
                                                                                        textAlign: TextAlign.left,
                                                                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                      ),
                                                                                    ),
                                                                                    //price
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: TextFormField(
                                                                                        style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                        textInputAction: TextInputAction.next,
                                                                                        // controller:
                                                                                        //     price,
                                                                                        keyboardType: TextInputType.number,
                                                                                        focusNode: numberFocusNode,
                                                                                        inputFormatters: [
                                                                                          FilteringTextInputFormatter.digitsOnly
                                                                                        ],
                                                                                        onChanged: (value) {
                                                                                          price.text = value;
                                                                                        },
                                                                                        decoration: InputDecoration(
                                                                                          // hintText: "example: Cahaya Sanivokasi",
                                                                                          labelText: "Price",
                                                                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                                                                        ),
                                                                                        validator: (value) {
                                                                                          if (value!.isEmpty) {
                                                                                            return 'Wajib diisi *';
                                                                                          }
                                                                                          return null;
                                                                                        },
                                                                                      ),
                                                                                    ),

                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: SizedBox(
                                                                                        width: 250,
                                                                                        child: CustomLoadingButton(
                                                                                            controller: btnController,
                                                                                            child: const Text("Update"),
                                                                                            onPressed: () async {
                                                                                              if (_formKey.currentState!.validate()) {
                                                                                                _formKey.currentState!.save();
                                                                                                Future.delayed(const Duration(seconds: 2)).then((value) async {
                                                                                                  setState(() {
                                                                                                    awalPrice = double.parse(price.text);
                                                                                                    postApi(data.lotNo!);
                                                                                                  });
                                                                                                  btnController.success();
                                                                                                  // Map<String, dynamic> body = {
                                                                                                  //   'id': id,
                                                                                                  //   'lot': lot.text,
                                                                                                  //   'size': size.text,
                                                                                                  //   'parcel': parcel.text,
                                                                                                  //   'qty': qty.text,
                                                                                                  // };
                                                                                                  // final response = await http.post(
                                                                                                  //     Uri.parse(ApiConstants
                                                                                                  //             .baseUrl +
                                                                                                  //         ApiConstants
                                                                                                  //             .postUpdateListDataBatu),
                                                                                                  //     body: body);
                                                                                                  // print(response.body);
                                                                                                  Future.delayed(const Duration(seconds: 1)).then((value) {
                                                                                                    btnController.reset(); //reset
                                                                                                    Navigator.of(context).pop();
                                                                                                    showDialog<String>(
                                                                                                        context: context,
                                                                                                        builder: (BuildContext context) => const AlertDialog(
                                                                                                              title: Text(
                                                                                                                'Update pricing success',
                                                                                                              ),
                                                                                                            ));
                                                                                                  });
                                                                                                });
                                                                                              } else {
                                                                                                btnController.error();
                                                                                                Future.delayed(const Duration(seconds: 1)).then((value) {
                                                                                                  btnController.reset(); //reset
                                                                                                });
                                                                                              }
                                                                                            }),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      });
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          //     child: ListTile(
                                          //   title: Text(data.entryNo!.toString(),
                                          //       style: const TextStyle(fontSize: 30)),
                                          //   subtitle: Text(
                                          //     data.marketingCode!.toString(),
                                          //   ),
                                          //   leading: ClipRRect(
                                          //     child: CachedNetworkImage(
                                          //       // memCacheWidth: 85, //default 45
                                          //       // memCacheHeight: 100, //default 60
                                          //       // maxHeightDiskCache: 100, //default 60
                                          //       // maxWidthDiskCache: 85, //default 45
                                          //       // imageUrl:
                                          //       //     'https://110.5.102.154:50001/Files/Images/Product/${data.fgImageFileName!.toString()}',
                                          //       imageUrl:
                                          //           'https://110.5.102.154:50001/Files/Images/Product/20100294-03.jpeg',

                                          //       placeholder: (context, url) =>
                                          //           const CircularProgressIndicator(),
                                          //       errorWidget: (context, url, error) => const Icon(
                                          //         Icons.error,
                                          //         color: Colors.black,
                                          //       ),
                                          //       fit: BoxFit.cover,
                                          //     ),
                                          //   ),
                                          // )
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          // By default show a loading spinner.
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
              ));
  }

//method approve pricing
  postApi(lot) async {
    Map<String, String> headersAPI = {
      'Content-Type': 'application/json',
    };
    Map bodyApi = {
      'approvedBy': sharedPreferences!.getString('name')!,
      'approvalPrice': awalPrice
    };
    final response = await http.put(
        Uri.parse(
            '${ApiConstants.baseUrlPricing}${ApiConstants.PUTapprovelPricing}$lot'),
        headers: headersAPI,
        body: jsonEncode(bodyApi));
    print(response.statusCode);
    print(response.body);
  }
}

class SearchModel extends StatelessWidget {
  final dynamic e;
  const SearchModel({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ProductDetailsScreen(proList: e)));
      // Fluttertoast.showToast(msg: "Not Available");
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (c) => ItemsDetailsScreen(
      //               model: e.model,
      //             )));
      // },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          height: 100,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://parvabisnis.id/uploads/products/${e['image_name'].toString()}',
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.asset(
                        "images/noimage.png",
                      ),
                      height: 124,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(
                            e['name'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '\$ ${e['price']}',
                            overflow: TextOverflow.ellipsis,
                            // maxLines: 2,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    var existingitemcart = context
                        .read<PCart>()
                        .getItems
                        .firstWhereOrNull(
                            (element) => element.name == e['name'].toString());
                    //cart API
                    print(existingitemcart);
                    // existingitemcart == null
                    if (existingitemcart == null) {
                      String token =
                          sharedPreferences!.getString("token").toString();

                      //add cart API
                      Map<String, String> body = {
                        // 'user_id': id.toString(),
                        'product_id': e['id'].toString(),
                        'qty': '1',
                        'price': e['price'].toString(),
                        'jenisform_id': '3',
                        'update_by': '1'
                      };
                      final response = await http.post(
                          Uri.parse(ApiConstants.baseUrl +
                              ApiConstants.POSTkeranjangsalesendpoint),
                          headers: <String, String>{
                            'Authorization': 'Bearer $token',
                          },
                          body: body);
                      print(response.body);

                      Fluttertoast.showToast(
                          msg: "Barang Berhasil Di Tambahkan");
                      context.read<PCart>().addItem(
                            e['name'].toString(),
                            int.parse(e['price'].toString()),
                            1,
                            e['image_name'].toString(),
                            e['id'].toString(),
                            e['sales_id'].toString(),
                            e['description'].toString(),
                            e['keterangan_barang'].toString(),
                          );
                    } else {
                      Fluttertoast.showToast(
                          msg: "Barang Sudah Ada Di Keranjang");
                    }
                  },
                  hoverColor: Colors.green,
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
