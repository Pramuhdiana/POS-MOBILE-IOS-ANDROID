// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, no_leading_underscores_for_local_identifiers, unused_element

import 'dart:convert';

import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_alldetailtransaksi.dart';
import 'package:e_shop/database/db_alltransaksi_voucher.dart';
import 'package:e_shop/database/model_alldetailtransaksi.dart';
import 'package:e_shop/database/model_alltransaksi_voucher.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/history/history_model_new.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class HistoryInvoiceScreen extends StatelessWidget {
  const HistoryInvoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var errorMsg;
    List<ModelAlltransaksiNewVoucher>? filterList;

    Future<List<ModelAlltransaksiNewVoucher>> _getData(jenisId) async {
      String token = sharedPreferences!.getString("token").toString();

      final response = await http.get(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.GETtransaksiendpoint),
          headers: {
            'Authorization': 'Bearer $token',
          });

      // if response successful

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        var g;
        try {
          g = jsonResponse
              .map((data) => ModelAlltransaksiNewVoucher.fromJson(data))
              .toList();
        } catch (c) {
          errorMsg = 'Error Prosses get data all data transaksi $c';
        }

        var filterByJenisForm = g.where((element) =>
            element.jenisform_id == jenisId &&
            element.user_id.toString() == sharedPreferences!.getString('id'));

        // filterByJenisForm!.sort((a, b) => a.total!.compareTo(b.total!));

        return filterByJenisForm.toList();
      } else {
        throw Exception('Unexpected error occured!');
      }
    }

    Future<List<ModelAlldetailtransaksi>> _getDataDetail(jenisId) async {
      String token = sharedPreferences!.getString("token").toString();

      final response = await http.get(
          Uri.parse(
              ApiConstants.baseUrl + ApiConstants.GETdetailtransaksiendpoint),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      // if response successful

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        var g = jsonResponse
            .map((data) => ModelAlldetailtransaksi.fromJson(data))
            .toList();
        var filterByJenisForm = g.where((element) =>
            element.invoices_number == jenisId &&
            element.user_id.toString() == sharedPreferences!.getString('id'));

        // filterList! = filterByJenisForm!.toList().sort((a,b) => a.created_at.compareTo(b.created_at));
        return filterByJenisForm.toList();
      } else {
        throw Exception('Unexpected error occured!');
      }
    }

    return FutureBuilder(
        // future: DbAlltransaksi.db.getAlltransaksi(1),
        future: DbAlltransaksiNewVoucher.db.getAlltransaksiNewVoucher(1),
        // future: _getData(1),
        //kembali barang 4
        // inv 1
        // ttp 2
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('$errorMsg');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Container(
                    padding: const EdgeInsets.all(0),
                    width: 90,
                    height: 90,
                    child: Lottie.asset("json/loading_black.json")));
          }

          if (snapshot.data.isEmpty) {
            return const Center(
                child: Text(
              'You Have Not \n\n History Invoice',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Acne',
                  letterSpacing: 1.5),
            ));
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(
                      // future:
                      //     _getDataDetail(snapshot.data[index].invoices_number),
                      future: DbAlldetailtransaksi.db.getAlldetailtransaksi(
                          snapshot.data[index].invoices_number),
                      builder: (BuildContext context, AsyncSnapshot snapshot2) {
                        // print(snapshot2.data[index].name);

                        if (snapshot2.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot2.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Container(
                                  padding: const EdgeInsets.all(0),
                                  width: 90,
                                  height: 90,
                                  child:
                                      Lottie.asset("json/loading_black.json")));
                        } else {
                          return HistoryModelNew(
                            detailTransaksi: snapshot2.data,
                            allTransaksi: snapshot.data[index],
                          );
                        }
                      });
                });
          }
        });
  }
}


//stream builder firestore
// return StreamBuilder<QuerySnapshot<Object?>>(
//         stream: FirebaseFirestore.instance
//             // .collection('invoice')
//             // .where('salesId', isEqualTo: sharedPreferences!.getString("uid")!)
//             // .where('deliverystatus', isEqualTo: 'INVOICE')
//             // .orderBy('orderdate', descending: true)
//             .collection('alltransaksi')
//             .where('user_id', isEqualTo: int.parse(id!)) // id sales
//             .where('jenisform_id', isEqualTo: 1) //id form invoice
//             .snapshots(),
//         builder: (BuildContext context,
//             AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
//           if (snapshot.hasError) {
//             return const Text('Something went wrong');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (snapshot.data!.docs.isEmpty) {
//             return const Center(
//                 child: Text(
//               'You Have Not \n\n History Invoice',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   fontSize: 26,
//                   color: Colors.blueGrey,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Acne',
//                   letterSpacing: 1.5),
//             ));
//           } else {
//             return ListView.builder(
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (context, index) {
//                   return StreamBuilder<QuerySnapshot<Object?>>(
//                       stream: FirebaseFirestore.instance
//                           // .collection('invoiceid')
//                           // .where('salesId',
//                           //     isEqualTo: sharedPreferences!.getString("uid")!)
//                           // .where('id',
//                           //     isEqualTo: snapshot.data!.docs[index]['name'])
//                           // .collection('alltransaksi')
//                           // .doc(snapshot.data!.docs[index].toString())
//                           // .where('user_id', isEqualTo: 19) // id sales
//                           // .orderBy('created_at', descending: true)
//                           .collection('alltransaksi')
//                           .doc(snapshot.data!.docs[index]['invoices_number'])
//                           .collection('alldetailtransaksi')
//                           .snapshots(),
//                       builder: (BuildContext context,
//                           AsyncSnapshot<QuerySnapshot<Object?>> snapshot2) {
//                         if (snapshot2.hasError) {
//                           return const Text('Something went wrong');
//                         }

//                         if (snapshot2.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         } else {
//                           return HistoryModelNew(
//                             order2: snapshot2.data!,
//                             order: snapshot.data!.docs[index],
//                           );
//                         }
//                       });
//                 });
//           }
//         });