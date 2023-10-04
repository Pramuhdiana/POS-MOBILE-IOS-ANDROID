import 'package:e_shop/database/db_alldetailtransaksi.dart';
import 'package:e_shop/database/db_alltransaksi.dart';
import 'package:e_shop/history/history_model_new.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HistoryInvoiceScreen extends StatelessWidget {
  const HistoryInvoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DbAlltransaksi.db.getAlltransaksi(1),
        //kembali barang 4
        // inv 1
        // ttp 2
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
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
                            order2: snapshot2.data,
                            order: snapshot.data[index],
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