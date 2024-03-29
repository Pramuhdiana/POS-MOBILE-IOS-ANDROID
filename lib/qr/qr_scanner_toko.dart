// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_import, unused_element

import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/POSToko/search_pos_toko.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/cartScreens/cart_screen_toko.dart';
import 'package:e_shop/database/db_allitems_toko.dart';
import 'package:e_shop/database/model_allitems_toko.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:e_shop/provider/provider_cart_toko.dart';
import 'package:e_shop/widgets/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../models/products.dart';
import 'package:badges/badges.dart' as badges;

class QrScannerToko extends StatefulWidget {
  const QrScannerToko({super.key});

  @override
  State<StatefulWidget> createState() => _QrScannerTokoState();
}

class _QrScannerTokoState extends State<QrScannerToko> {
  String searchInput = '';
  String? resultQr;

  Products? model;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 1, child: _buildQrView(context)),
          Expanded(flex: 1, child: _searchQr(context)),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Background color
        ),
        onPressed: () {
          controller?.stopCamera();
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => CartScreenToko()));
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: badges.Badge(
            showBadge:
                context.read<PCartToko>().getItems.isEmpty ? false : true,
            badgeStyle: const badges.BadgeStyle(
              badgeColor: AppColors.contentColorGreen,
            ),
            badgeContent: Text(
              context.watch<PCartToko>().getItems.length.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Icon(
              Icons.shopping_cart_checkout,
              color: Colors.black,
              size: 50,
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 40,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        searchInput = result!.code.toString();
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext?>('context', context));
  }

  //widget searchQR
  Widget _searchQr(BuildContext context) {
    String token = sharedPreferences!.getString("token").toString();

    loadCartFromApiPOSSALES() async {
      var url = ApiConstants.baseUrl +
          ApiConstants.GETkeranjangtokoendpoint +
          sharedPreferences!.getString('customer_id').toString();
      Response response = await Dio().get(url,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      return (response.data as List).map((cart) {
        var existingitemcart = context
            .read<PCartToko>()
            .getItems
            .firstWhereOrNull((element) => element.name == cart['lot']);

        print(existingitemcart);
        if (existingitemcart == null) {
          print('Inserting Cart Toko berhasil');
          context.read<PCartToko>().addItem(
                cart['lot'].toString(),
                cart['price'],
                cart['qty'],
                cart['image_name'].toString(),
                cart['product_id'].toString(),
                cart['user_id'].toString(),
                cart['description'].toString(),
                cart['keterangan_barang'].toString(),
              );
        } else {}
        // DbAllItems.db.createAllItems(AllItems.fromJson(items));
      }).toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () async {
            controller?.stopCamera();
            Navigator.pop(context);
          },
        ),
        // title: CupertinoSearchTextField(
        //   autofocus: false,
        //   backgroundColor: Colors.white,
        //   keyboardType: TextInputType.number,
        //   enabled: false,
        //   onChanged: (value) {
        //     setState(() {
        //       searchInput = value;
        //     });
        //   },
        // ),
      ),
      body: searchInput == ''
          ? Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25)),
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Icon(Icons.qr_code_scanner_outlined,
                                  color: Colors.white),
                            ),
                            Text(
                              'Scan QR Toko ${sharedPreferences!.getString('customer_name')}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Icon(Icons.search, color: Colors.white),
                            ),
                          ]),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await controller?.pauseCamera();
                    },
                    child: const Text('Pause', style: TextStyle(fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await controller?.resumeCamera();
                    },
                    child: const Text('Resume', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            )
          : FutureBuilder(
              future: DbAllitemsToko.db.getAllitemsTokoBylot(
                  sharedPreferences!.getString('customer_id'), searchInput),
              builder: (BuildContext context, AsyncSnapshot dataSnapshot) {
                if (dataSnapshot.hasData) //if brands exists
                {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var item = (dataSnapshot.data[index]);
                      return SearchPosToko(
                        model: ModelAllitemsToko(
                            id: item.id,
                            name: item.name,
                            slug: item.slug,
                            image_name: item.image_name,
                            description: item.description,
                            price: item.price,
                            category_id: item.category_id,
                            posisi_id: item.posisi_id,
                            customer_id: item.customer_id,
                            kode_refrensi: item.kode_refrensi,
                            sales_id: item.sales_id,
                            brand_id: item.brand_id,
                            qty: item.qty,
                            status_titipan: item.status_titipan,
                            keterangan_barang: item.keterangan_barang),
                      );
                    },
                    itemCount: dataSnapshot.data.length,
                  );
                } else if (dataSnapshot.hasError) {
                  return Center(
                      child: Container(
                          padding: const EdgeInsets.all(0),
                          width: 90,
                          height: 90,
                          child: Lottie.asset("json/loading_black.json")));
                } //if data NOT exists
                return Center(
                    child: Container(
                        padding: const EdgeInsets.all(0),
                        width: 90,
                        height: 90,
                        child: Lottie.asset("json/loading_black.json")));
              },
            ),
    );
  }
}

class SearchModel extends StatelessWidget {
  final dynamic e;
  const SearchModel({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var existingitemcart = context
        .read<PCart>()
        .getItems
        .firstWhereOrNull((element) => element.name == e['name'].toString());
    if (existingitemcart == null) {
      if (Platform.isAndroid) {
        FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_ABBR_ALERT);
        Fluttertoast.showToast(msg: "Barang Berhasil Di Tambahkan");
        context.read<PCartToko>().addItem(
              e['name'].toString(),
              int.parse(e['price'].toString()),
              1,
              e['image_name'].toString(),
              e['id'].toString(),
              e['sales_id'].toString(),
              e['description'].toString(),
              e['keterangan_barang'].toString(),
            );
        postAPIcart();
        DbAllitemsToko.db.updateAllitemsTokoByname(e['name'].toString(), 0);
      } else {
        FlutterBeep.playSysSound(iOSSoundIDs.CalendarAlert);
        Fluttertoast.showToast(msg: "Barang Berhasil Di Tambahkan");
        context.read<PCartToko>().addItem(
              e['name'].toString(),
              int.parse(e['price'].toString()),
              1,
              e['image_name'].toString(),
              e['id'].toString(),
              e['sales_id'].toString(),
              e['description'].toString(),
              e['keterangan_barang'].toString(),
            );
        postAPIcart();
        DbAllitemsToko.db.updateAllitemsTokoByname(e['name'].toString(), 0);
      }
    }

    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ProductDetailsScreen(proList: e)));
        Fluttertoast.showToast(msg: "Not Available");
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (c) => ItemsDetailsScreen(
        //               model: e.model,
        //             )));
      },
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
                          '${ApiConstants.baseImageUrl}${e['image_name'].toString()}',
                      placeholder: (context, url) => Center(
                          child: Container(
                              padding: const EdgeInsets.all(0),
                              width: 90,
                              height: 90,
                              child: Lottie.asset("json/loading_black.json"))),
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
                // IconButton(
                //   onPressed: () {

                //     var existingitemcart = context
                //         .read<PCart>()
                //         .getItems
                //         .firstWhereOrNull(
                //             (element) => element.name == e['name'].toString());

                //     // ignore: avoid_print
                //     print(existingitemcart);
                //     // existingitemcart == null
                //     if (existingitemcart == null) {
                //       var documentId = DateTime.now().millisecond;
                //       Fluttertoast.showToast(
                //           msg: "Barang Berhasil Di Tambahkan");
                //       context.read<PCart>().addItem(
                //             e['name'].toString(),
                //             int.parse(e['price'].toString()),
                //             1,
                //             e['image_name'].toString(),
                //             DateTime.now.toString(),
                //             documentId.toString(),
                //             e['salesUID'].toString(),
                //             e['keterangan_barang'].toString(),
                //           );
                //     } else {
                //       Fluttertoast.showToast(
                //           msg: "Barang Sudah Ada Di Keranjang");
                //     }
                //   },
                //   hoverColor: Colors.green,
                //   icon: const Icon(
                //     Icons.shopping_cart,
                //     color: Colors.blue,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  postAPIcart() async {
    String token = sharedPreferences!.getString("token").toString();

    Map<String, String> body = {
      // 'user_id': id.toString(),
      'product_id': e['id'].toString(),
      'qty': '1',
      'price': e['price'].toString(),
      'jenisform_id': '3',
      'update_by': '1'
    };
    final response = await http.post(
        Uri.parse(
            ApiConstants.baseUrl + ApiConstants.POSTkeranjangsalesendpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
  }
}
