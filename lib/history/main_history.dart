// ignore_for_file: prefer_const_constructors

import 'package:e_shop/history/history_invoice_screen.dart';
import 'package:e_shop/history/history_kembalibarang_screen.dart';
import 'package:e_shop/history/history_titipan_screen.dart';
import 'package:e_shop/widgets/fake_search_history.dart';
import 'package:flutter/material.dart';

class MainHistory extends StatelessWidget {
  const MainHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.blue,
            ),
            onPressed: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (c) => PosSalesScreen()));
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          // title: Text("History"),
          title: FakeSearchHistory(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          bottom: const TabBar(
              indicatorColor: Colors.blue,
              indicatorWeight: 8,
              tabs: [
                RepeatedTab(label: 'Invoice'),
                RepeatedTab(label: 'Kembali Baran'),
                RepeatedTab(label: 'Titipan'),
              ]),
        ),
        body: const TabBarView(children: [
          HistoryInvoiceScreen(),
          HistoryKembalibarangScreen(),
          HistoryTitipanScreen(),
        ]),
        // bottomNavigationBar: BottomAppBar(
        //     child: ElevatedButton(
        //   onPressed: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (c) => HomeScreen()));
        //   },
        //   child: const Icon(
        //     Icons.home,
        //     color: Colors.white,
        //     size: 50,
        //   ),
        // )),
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
        style: const TextStyle(color: Colors.blue),
      )),
    );
  }
}
