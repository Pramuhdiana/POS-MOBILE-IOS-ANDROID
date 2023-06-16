// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_import, unused_element

import 'package:e_shop/database/db_alldetailtransaksi.dart';
import 'package:e_shop/database/db_allitems.dart';
import 'package:e_shop/database/model_alldetailtransaksi.dart';
import 'package:e_shop/history/history_invoice_screen.dart';
import 'package:e_shop/history/history_kembalibarang_screen.dart';
import 'package:e_shop/history/history_titipan_screen.dart';
import 'package:e_shop/history/main_history.dart';
import 'package:e_shop/history/search_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/products.dart';

class NewSearchScreenHistory extends StatefulWidget {
  const NewSearchScreenHistory({super.key});

  @override
  State<StatefulWidget> createState() => _NewSearchScreenHistoryState();
}

class _NewSearchScreenHistoryState extends State<NewSearchScreenHistory> {
  String searchInput = '';

  Products? model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 1, child: _searchLot(context)),
          Expanded(flex: 2, child: _buildLotView(context)),
        ],
      ),
    );
  }

  Widget _buildLotView(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
              indicatorColor: Colors.blue,
              indicatorWeight: 8,
              tabs: const [
                RepeatedTab(label: 'Invoice'),
                RepeatedTab(label: 'Kembali Baran'),
                RepeatedTab(label: 'Titipan'),
              ]),
        ),
        body: TabBarView(children: const [
          HistoryInvoiceScreen(),
          HistoryKembalibarangScreen(),
          HistoryTitipanScreen(),
        ]),
      ),
    );
  }

  Widget _searchLot(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade300,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: CupertinoSearchTextField(
          autofocus: true,
          backgroundColor: Colors.white,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              searchInput = value;
            });
          },
        ),
      ),
      body: searchInput == ''
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25)),
                height: 30,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(Icons.search, color: Colors.white),
                      ),
                      Text(
                        'Search lot number ...',
                        style: TextStyle(color: Colors.white),
                      )
                    ]),
              ),
            )
          : FutureBuilder(
              future: DbAlldetailtransaksi.db
                  .getAlldetailtransaksiBysearch(searchInput),
              builder: (BuildContext context, AsyncSnapshot dataSnapshot) {
                if (dataSnapshot.hasData) //if brands exists
                {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var item = (dataSnapshot.data[index]);
                      return SearchHistory(
                        model: ModelAlldetailtransaksi(
                            name: item.name,
                            image_name: item.image_name,
                            description: item.description,
                            price: item.price,
                            kode_refrensi: item.kode_refrensi,
                            invoices_number: item.invoices_number,
                            keterangan_barang: item.keterangan_barang),
                      );
                    },
                    itemCount: dataSnapshot.data.length,
                  );
                } else if (dataSnapshot.hasError) {
                  return const CircularProgressIndicator();
                } //if data NOT exists
                return const CircularProgressIndicator();
              },
            ),
    );
  }
}
