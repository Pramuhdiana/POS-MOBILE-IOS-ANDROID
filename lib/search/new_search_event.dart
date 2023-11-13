// ignore_for_file: use_key_in_widget_constructors, avoid_print, use_build_context_synchronously

import 'dart:convert';

// import 'package:badges/badges.dart' as badges;
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/model_allitems.dart';
// import 'package:e_shop/event/cart_event_screen.dart';
import 'package:e_shop/event/search_pos_event.dart';
// import 'package:e_shop/event/transaksi_event_screen.dart';
import 'package:e_shop/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class NewSearchEventScreen extends StatefulWidget {
  @override
  State<NewSearchEventScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<NewSearchEventScreen> {
  Future<List<ModelAllitems>> _getDataBySearch(lot) async {
    String? tokens = sharedPreferences!.getString('token');
    final response = await http.get(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.GETposTokoendpoint),
        headers: {"Authorization": "Bearer $tokens"});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      var allData =
          jsonResponse.map((data) => ModelAllitems.fromJson(data)).toList();
      var filterByIdToko = allData.where(
          (element) => element.customer_id.toString().toLowerCase() == '440');
      var filterByLot = filterByIdToko
          .where((element) => element.name.toString().contains(lot));
      allData = filterByLot.toList();

      return allData;
    } else {
      throw Fluttertoast.showToast(msg: "Database Off");
    }
  }

  String searchInput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
        title: CupertinoSearchTextField(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          itemColor: Colors.black,
          autofocus: true,
          backgroundColor: Colors.black12,
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
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25)),
                height: 30,
                width: MediaQuery.of(context).size.width * 0.7,
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
              future: _getDataBySearch(searchInput),
              builder: (BuildContext context, AsyncSnapshot dataSnapshot) {
                if (dataSnapshot.hasData) //if brands exists
                {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var item = (dataSnapshot.data[index]);
                      return SearchPosEvent(
                        model: ModelAllitems(
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
