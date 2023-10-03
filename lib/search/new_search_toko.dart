// ignore_for_file: use_key_in_widget_constructors, unnecessary_import, avoid_print, use_build_context_synchronously

import 'package:e_shop/POSToko/search_pos_toko.dart';
import 'package:badges/badges.dart' as badges;
import 'package:e_shop/cartScreens/cart_screen_toko.dart';
import 'package:e_shop/database/db_allitems_toko.dart';
import 'package:e_shop/database/model_allitems_toko.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/provider/provider_cart_toko.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class NewSearchScreenToko extends StatefulWidget {
  @override
  State<NewSearchScreenToko> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<NewSearchScreenToko> {
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const CartScreenToko()));
                    // }
                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(2),
                    child: badges.Badge(
                      showBadge: context.read<PCartToko>().getItems.isEmpty
                          ? false
                          : true,
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.green,
                      ),
                      badgeContent: Text(
                        context.watch<PCartToko>().getItems.length.toString(),
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Transform.scale(
                        scale: 1.3,
                        child: Image.asset(
                          "assets/cart.png",
                          width: 45,
                          height: 45,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
