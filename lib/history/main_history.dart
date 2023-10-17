// ignore_for_file: prefer_const_constructors, unused_import

import 'package:e_shop/api/api_services.dart';
import 'package:e_shop/database/db_alldetailtransaksi.dart';
import 'package:e_shop/database/db_alltransaksi.dart';
import 'package:e_shop/history/history_invoice_screen.dart';
import 'package:e_shop/history/history_kembalibarang_screen.dart';
import 'package:e_shop/history/history_titipan_screen.dart';
import 'package:e_shop/widgets/fake_search_history.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainHistory extends StatelessWidget {
  const MainHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // DbAlltransaksi.db.deleteAlltransaksi();
    // DbAlldetailtransaksi.db.deleteAlldetailtransaksi();

    // try {
    //   ApiServices().getAllTransaksi(); //ambil data ntransaksi
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all transaksi");
    // }

    // try {
    //   ApiServices().getAllDetailTransaksi(); //ambil data ntransaksi
    // } catch (c) {
    //   Fluttertoast.showToast(msg: "Failed To Load Data all detail transaksi");
    // }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          backgroundColor: Colors.white,
          elevation: 0,
          // title: Text("History"),
          actions: const [
            FakeSearchHistory(),
          ],
          automaticallyImplyLeading: false,
          centerTitle: true,
          bottom: const TabBar(
              indicatorColor: Colors.black,
              indicatorWeight: 5,
              tabs: [
                RepeatedTab(label: 'Invoice'),
                RepeatedTab(label: 'Kembali Barang'),
                RepeatedTab(label: 'Titipan'),
              ]),
        ),
        body: const TabBarView(children: [
          HistoryInvoiceScreen(),
          HistoryKembalibarangScreen(),
          HistoryTitipanScreen(),
        ]),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
          child: Text(
        label,
        style: const TextStyle(color: Colors.black),
      )),
    );
  }
}
