// // ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, use_build_context_synchronously, unused_local_variable, unused_element

// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:e_shop/splashScreen/my_splas_screen_transaksi.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:sn_progress_dialog/progress_dialog.dart';

// import 'package:http/http.dart' as http;
// import '../global/currency_format.dart';
// import '../global/global.dart';
// import '../provider/provider_cart.dart';

// class SetDiskon extends StatefulWidget {
//   const SetDiskon({super.key});

//   @override
//   _SetDiskonState createState() => _SetDiskonState();
// }

// class _SetDiskonState extends State<SetDiskon> {
//   late FirebaseMessaging messaging;
//   @override
//   void initState() {
//     super.initState();
//     uid = sharedPreferences!.getString("uid")!;
//     messaging = FirebaseMessaging.instance;
//     messaging.getToken().then((value) {
//       print(value);
//     });
//     FirebaseMessaging.onMessage.listen((RemoteMessage event) {
//       print("message recieved");
//       print(event.notification!.body);
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       print('Message clicked!');
//     });
//   }

//   int? id = 0;
//   String qty = '';
//   String orderIdDiskon = DateTime.now().second.toString();
//   String uid = '';
//   String? form;
//   String? toko;
//   int idsales = 0;
//   int idtoko = 0;
//   int rate = 1;
//   int diskonrequest = 90;
//   int result = 0;
//   int diskon = 100;
//   TextEditingController dp = TextEditingController();
//   int dpp = 0;
//   String tokenBC = '';

//   final _formKey = GlobalKey<FormState>();

//   double get totalPrice {
//     // var dpin = int.parse(dp);
//     var total =
//         ((context.read<PCart>().totalPrice2) * rate) * (diskon / 100) - dpp;
//     return total;
//   }

//   String get totalPrice3 {
//     // var dpin = int.parse(dp);
//     var total =
//         ((context.read<PCart>().totalPrice2) * rate) * (diskon / 100) - dpp;
//     if (rate <= 2) {
//       return '\$ ${total.toStringAsFixed(2)}';
//     } else {
//       return CurrencyFormat.convertToIdr(total, 2);
//     }
//   }

//   void showProgress() {
//     ProgressDialog progress = ProgressDialog(context: context);
//     progress.show(max: 100, msg: 'please wait ..', progressBgColor: Colors.red);
//   }

//   sendMotificationToBc(tokenBC, orderIdDiskon) {
//     String bcDeviceToken = '';

//     FirebaseFirestore.instance
//         .collection("users")
//         .doc(tokenBC)
//         .get()
//         .then((snapshot) {
//       // if (snapshot.data()!["uid"] != null) {
//       bcDeviceToken = snapshot.data()!["uid"].toString();
//       // }
//     });

//     notificationFormat(
//       bcDeviceToken,
//       orderIdDiskon,
//       sharedPreferences!.getString("name"),
//     );
//   }

//   notificationFormat(bcDeviceToken, orderIdDiskon, userName) {
//     Map<String, String> headerNotification = {
//       'Content-Type': 'application/json',
//       'Authorization': fcmServerToken,
//     };

//     Map bodyNotification = {
//       'body': "Dear BC, Request diskon has approved. \nPlease check now.",
//       'title': "Request Diskon",
//     };

//     Map dataMap = {
//       "click_action": "FLUTTER_NOTIFICATION_CLICK",
//       "id": "1",
//       "status": "done",
//       "bcOrderId": orderIdDiskon,
//     };

//     Map officialNotificationFormat = {
//       'notification': bodyNotification,
//       'data': dataMap,
//       'priority': 'high',
//       'to': bcDeviceToken,
//     };

//     http.post(
//       Uri.parse("https://fcm.googleapis.com/fcm/send"),
//       headers: headerNotification,
//       body: jsonEncode(officialNotificationFormat),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Form Set Diskon"), centerTitle: true),
//       body: Padding(
//         padding: const EdgeInsets.all(25),
//         child: Form(
//           key: _formKey,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           child: ListView(
//             padding: const EdgeInsets.all(4),
//             children: <Widget>[
//               //Nama BC

//               const Text("Pilih BC"),
//               const Divider(),
//               Row(
//                 children: [
//                   const Padding(padding: EdgeInsets.all(4)),
//                   Expanded(
//                     child: DropdownSearch<String>(
//                       items: const ["JONATHAN", "FEBRI", "ANDI"],
//                       onChanged: (text) {
//                         setState(() {
//                           form = text;
//                           if (form == "JONATHAN") {
//                             idsales = 99;
//                             tokenBC = 'yDDNEgvmWfOhxWq9tsmWKmJjKqp1';
//                             print(idsales);
//                             print(id);
//                           } else if (form == "FEBRI") {
//                             tokenBC = 'yDDNEgvmWfOhxWq9tsmWKmJjKqp1';
//                             idsales = 99;
//                             print(idsales);
//                           } else if (form == "ANDI") {
//                             tokenBC = 'yDDNEgvmWfOhxWq9tsmWKmJjKqp1';
//                             idsales = 99;
//                             print(idsales);
//                           } else {
//                             tokenBC = 'yDDNEgvmWfOhxWq9tsmWKmJjKqp1';
//                             idsales = 99;
//                             print(idsales);
//                           }
//                         });
//                       },
//                       dropdownDecoratorProps: DropDownDecoratorProps(
//                         dropdownSearchDecoration: InputDecoration(
//                           labelText: 'Pilih BC',
//                           filled: true,
//                           fillColor:
//                               Theme.of(context).inputDecorationTheme.fillColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text("Pilih Toko"),
//               const Divider(),
//               Row(
//                 children: [
//                   const Padding(padding: EdgeInsets.all(4)),
//                   Expanded(
//                     child: DropdownSearch<String>(
//                       items: const ["ANEKA", "SINAR FAJAR", "SBS"],
//                       onChanged: (text) {
//                         setState(() {
//                           toko = text;
//                           if (toko == "ANEKA") {
//                             idtoko = 1;
//                             print(idtoko);
//                           } else if (toko == "SINAR FAJAR") {
//                             idtoko = 2;
//                             print(idtoko);
//                           } else if (toko == "SBS") {
//                             idtoko = 3;
//                             print(idtoko);
//                           } else {
//                             idtoko = 0;
//                             print(idtoko);
//                           }
//                           qty =
//                               context.read<PCart>().getItems.length.toString();
//                         });
//                       },
//                       dropdownDecoratorProps: DropDownDecoratorProps(
//                         dropdownSearchDecoration: InputDecoration(
//                           labelText: 'Pilih Toko',
//                           filled: true,
//                           fillColor:
//                               Theme.of(context).inputDecorationTheme.fillColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               //DP
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text("Set Diskon"),
//               const Divider(),
//               SizedBox(
//                 width: 250,
//                 child: TextField(
//                   onChanged: (dp) {
//                     setState(() {
//                       dpp = int.parse(dp);
//                     });
//                   },
//                   decoration: const InputDecoration(labelText: "Set Diskon"),
//                   controller: dp,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: <TextInputFormatter>[
//                     FilteringTextInputFormatter.digitsOnly
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//           child: ElevatedButton(
//         onPressed: () {
//           // showProgress();
//           // Navigator.push(
//           //     context,
//           //     MaterialPageRoute(
//           //         builder: (c) => const MySplashScreenTransaksi()));
//           showModalBottomSheet(
//               context: context,
//               builder: (context) => SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.3,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 100),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Text(
//                             'Set Diskon : $dpp %',
//                             style: const TextStyle(fontSize: 24),
//                           ),
//                           ElevatedButton(
//                               onPressed: () async {
//                                 showProgress();
//                                 CollectionReference orderDiskon =
//                                     FirebaseFirestore.instance
//                                         .collection('setdiskon');
//                                 orderIdDiskon =
//                                     idsales.toString() + idtoko.toString();
//                                 await orderDiskon.doc(orderIdDiskon).set({
//                                   'id': orderIdDiskon,
//                                   'bc_id': idsales,
//                                   'customer_id': idtoko.toString(),
//                                   'name_bc': form,
//                                   'name_toko': toko,
//                                   'set_diskon': dpp,
//                                   'orderdate': DateTime.now(),
//                                   'use': 0,
//                                 });
//                                 // .then((value) {});
//                                 // .whenComplete(() async {
//                                 //   await FirebaseFirestore.instance
//                                 //       .runTransaction((transaction) async {
//                                 //     DocumentReference documentReference =
//                                 //         FirebaseFirestore.instance
//                                 //             .collection("items")
//                                 //             .doc(item.name);
//                                 //     transaction.update(documentReference, {
//                                 //       'posisi_id': "100",
//                                 //       'jenis_order': idform,
//                                 //       'customer_id': idtoko
//                                 //     });
//                                 //   });
//                                 // });
//                                 //     .whenComplete(() {
//                                 // });
//                                 //send push notification
//                                 sendMotificationToBc(tokenBC, orderIdDiskon);
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (c) =>
//                                             const MySplashScreenTransaksi()));
//                               },
//                               child: const Text('Save'))
//                         ],
//                       ),
//                     ),
//                   ));
//         },
//         child: const Text('Save Diskon'),
//       )),
//     );
//   }
// }
