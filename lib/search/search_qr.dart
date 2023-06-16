// // ignore_for_file: avoid_print, use_build_context_synchronously

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:collection/collection.dart';
// import 'package:e_shop/api/api_constant.dart';
// import 'package:e_shop/global/global.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

// import '../provider/provider_cart.dart';

// class SearchQr extends StatefulWidget {
//   const SearchQr({super.key});

//   @override
//   State<SearchQr> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchQr> {
//   String searchInput = '';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade300,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.grey.shade300,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: CupertinoSearchTextField(
//           autofocus: true,
//           backgroundColor: Colors.white,
//           onChanged: (value) {
//             setState(() {
//               searchInput = value;
//             });
//           },
//         ),
//       ),
//       body: searchInput == ''
//           ? Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(25)),
//                 height: 30,
//                 width: MediaQuery.of(context).size.width * 0.7,
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: const [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 15),
//                         child: Icon(Icons.search, color: Colors.white),
//                       ),
//                       Text(
//                         'Search for any thing ...',
//                         style: TextStyle(color: Colors.white),
//                       )
//                     ]),
//               ),
//             )
//           : StreamBuilder<QuerySnapshot>(
//               stream:
//                   FirebaseFirestore.instance.collection('allitems').snapshots(),
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
//     );
//   }
// }

// class SearchModel extends StatelessWidget {
//   final dynamic e;
//   const SearchModel({Key? key, required this.e}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       // onTap: () {
//       // Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (context) => ProductDetailsScreen(proList: e)));
//       // Fluttertoast.showToast(msg: "Not Available");
//       // Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (c) => ItemsDetailsScreen(
//       //               model: e.model,
//       //             )));
//       // },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//         child: Container(
//           decoration: BoxDecoration(
//               color: Colors.white, borderRadius: BorderRadius.circular(12)),
//           height: 100,
//           width: double.infinity,
//           child: Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: SizedBox(
//                     height: 100,
//                     width: 100,
//                     child: CachedNetworkImage(
//                       imageUrl:
//                           'https://parvabisnis.id/uploads/products/${e['image_name'].toString()}',
//                       placeholder: (context, url) =>
//                           const CircularProgressIndicator(),
//                       errorWidget: (context, url, error) => Image.asset(
//                         "images/noimage.png",
//                       ),
//                       height: 124,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Flexible(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             e['name'],
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             '\$ ${e['price']}',
//                             overflow: TextOverflow.ellipsis,
//                             // maxLines: 2,
//                             style: const TextStyle(
//                               fontSize: 15,
//                               color: Colors.red,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () async {
//                     var existingitemcart = context
//                         .read<PCart>()
//                         .getItems
//                         .firstWhereOrNull(
//                             (element) => element.name == e['name'].toString());

//                     print(existingitemcart);
//                     // existingitemcart == null
//                     if (existingitemcart == null) {
//                       //add cart API
//                       Map<String, String> body = {
//                         'user_id': id.toString(),
//                         'product_id': e['id'].toString(),
//                         'qty': '1',
//                         'price': e['price'].toString(),
//                         'jenisform_id': '3'
//                       };
//                       final response = await http.post(
//                           Uri.parse(ApiConstants.baseUrl +
//                               ApiConstants.POSTkeranjangsalesendpoint),
//                           headers: <String, String>{
//                             'Authorization': 'Bearer ${token!}',
//                           },
//                           body: body);
//                       print(response.body);
//                       Fluttertoast.showToast(
//                           msg: "Barang Berhasil Di Tambahkan");
//                       context.read<PCart>().addItem(
//                             e['name'].toString(),
//                             int.parse(e['price'].toString()),
//                             1,
//                             e['image_name'].toString(),
//                             e['id'].toString(),
//                             e['sales_id'].toString(),
//                             e['description'].toString(),
//                             e['keterangan_barang'].toString(),
//                           );
//                     } else {
//                       Fluttertoast.showToast(
//                           msg: "Barang Sudah Ada Di Keranjang");
//                     }
//                   },
//                   hoverColor: Colors.green,
//                   icon: const Icon(
//                     Icons.shopping_cart,
//                     color: Colors.blue,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
