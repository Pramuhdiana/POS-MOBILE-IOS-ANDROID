// ignore_for_file: use_key_in_widget_constructors, unnecessary_import, avoid_print, use_build_context_synchronously

import 'package:badges/badges.dart' as badges;
import 'package:e_shop/cartScreens/cart_screen_retur.dart';
import 'package:e_shop/database/db_allitems_retur.dart';
import 'package:e_shop/database/model_allitems_retur.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/posRetur/search_pos_retur.dart';
import 'package:e_shop/provider/provider_cart_retur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewSearchScreenRetur extends StatefulWidget {
  @override
  State<NewSearchScreenRetur> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<NewSearchScreenRetur> {
  String searchInput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
                            builder: (c) => const CartScreenRetur()));
                    // }
                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(2),
                    child: badges.Badge(
                      showBadge: context.read<PCartRetur>().getItems.isEmpty
                          ? false
                          : true,
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.green,
                      ),
                      badgeContent: Text(
                        context.watch<PCartRetur>().getItems.length.toString(),
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Icon(
                        Icons.shopping_cart_checkout,
                        color: Colors.blue,
                        size: 35,
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
                    color: Colors.blue,
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
              future: DbAllitemsRetur.db.getAllitemsReturBylot(
                  sharedPreferences!.getString('customer_id'), searchInput),
              builder: (BuildContext context, AsyncSnapshot dataSnapshot) {
                if (dataSnapshot.hasData) //if brands exists
                {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var item = (dataSnapshot.data[index]);
                      return SearchPosRetur(
                        model: ModelAllitemsRetur(
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
                  return const CircularProgressIndicator();
                } //if data NOT exists
                return const CircularProgressIndicator();
              },
            ),
    );
  }
}
