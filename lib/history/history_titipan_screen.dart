// ignore_for_file: unnecessary_import, implementation_imports, avoid_print

import 'package:e_shop/database/db_alldetailtransaksi.dart';
import 'package:e_shop/database/db_alltransaksi.dart';
import 'package:e_shop/history/history_model_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

class HistoryTitipanScreen extends StatelessWidget {
  const HistoryTitipanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DbAlltransaksi.db.getAlltransaksi(2),
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
              'You Have not \n\n History Invoice',
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
