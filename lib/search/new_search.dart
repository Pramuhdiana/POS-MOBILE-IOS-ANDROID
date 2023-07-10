// ignore_for_file: use_key_in_widget_constructors, avoid_print, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:badges/badges.dart' as badges;
import 'package:collection/collection.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/cartScreens/cart_screen.dart';
import 'package:e_shop/database/db_allitems.dart';
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/posSales/search_pos_sales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../provider/provider_cart.dart';
import 'package:http/http.dart' as http;

class NewSearchScreen extends StatefulWidget {
  @override
  State<NewSearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<NewSearchScreen> {
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
            color: Colors.black,
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const CartScreen()));
                    // }
                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(2),
                    child: badges.Badge(
                      showBadge:
                          context.read<PCart>().getItems.isEmpty ? false : true,
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.green,
                      ),
                      badgeContent: Text(
                        context.watch<PCart>().getItems.length.toString(),
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Icon(
                        Icons.shopping_cart_checkout,
                        color: Colors.black,
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
              future: DbAllitems.db.getAllitemsBylot(searchInput),
              builder: (BuildContext context, AsyncSnapshot dataSnapshot) {
                if (dataSnapshot.hasData) //if brands exists
                {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var item = (dataSnapshot.data[index]);
                      return SearchPosSales(
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
                  return const CircularProgressIndicator();
                } //if data NOT exists
                return const CircularProgressIndicator();
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
    return InkWell(
      // onTap: () {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ProductDetailsScreen(proList: e)));
      // Fluttertoast.showToast(msg: "Not Available");
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (c) => ItemsDetailsScreen(
      //               model: e.model,
      //             )));
      // },
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
                          'https://parvabisnis.id/uploads/products/${e['image_name'].toString()}',
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
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
                IconButton(
                  onPressed: () async {
                    var existingitemcart = context
                        .read<PCart>()
                        .getItems
                        .firstWhereOrNull(
                            (element) => element.name == e['name'].toString());
                    //cart API
                    print(existingitemcart);
                    // existingitemcart == null
                    if (existingitemcart == null) {
                      String token =
                          sharedPreferences!.getString("token").toString();

                      //add cart API
                      Map<String, String> body = {
                        // 'user_id': id.toString(),
                        'product_id': e['id'].toString(),
                        'qty': '1',
                        'price': e['price'].toString(),
                        'jenisform_id': '3',
                        'update_by': '1'
                      };
                      final response = await http.post(
                          Uri.parse(ApiConstants.baseUrl +
                              ApiConstants.POSTkeranjangsalesendpoint),
                          headers: <String, String>{
                            'Authorization': 'Bearer $token',
                          },
                          body: body);
                      print(response.body);

                      Fluttertoast.showToast(
                          msg: "Barang Berhasil Di Tambahkan");
                      context.read<PCart>().addItem(
                            e['name'].toString(),
                            int.parse(e['price'].toString()),
                            1,
                            e['image_name'].toString(),
                            e['id'].toString(),
                            e['sales_id'].toString(),
                            e['description'].toString(),
                            e['keterangan_barang'].toString(),
                          );
                    } else {
                      Fluttertoast.showToast(
                          msg: "Barang Sudah Ada Di Keranjang");
                    }
                  },
                  hoverColor: Colors.green,
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//stream buildnder with firebase
// StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   // .collection('items')
//                   // .where('salesUID',
//                   //     isEqualTo: sharedPreferences!.getString("uid")!)
//                   // .where('posisi_id', isEqualTo: '1')
//                   // .snapshots(),
//                   .collection('allitems')
//                   .where('sales_id', isEqualTo: int.parse(id!)) //sales id
//                   .where('posisi_id', isEqualTo: 3)
//                   .snapshots(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Material(
//                     child: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   );
//                 }
//                 final result = snapshot.data!.docs.where(
//                   (e) => e['name'.toLowerCase()]
//                       .contains(searchInput.toLowerCase()),
//                 );
//                 return ListView(
//                   children: result.map((e) => SearchModel(e: e)).toList(),
//                 );
//               }),


