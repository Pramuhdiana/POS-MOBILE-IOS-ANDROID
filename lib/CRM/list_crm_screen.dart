// ignore_for_file: depend_on_referenced_packages, unnecessary_import, unused_local_variable, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, avoid_print, deprecated_member_use, must_be_immutable, unused_element

import 'package:e_shop/database/db_allcustomer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../global/currency_format.dart';

class ListCrmScreen extends StatelessWidget {
  //Read an image data from website/webspace
  String nameToko = 'awal';

  final dynamic crm;
  final dynamic customer;
  ListCrmScreen({Key? key, required this.crm, this.customer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(15)),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(maxHeight: 40),
            width: double.infinity,
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                          future:
                              DbAllCustomer.db.getNameCustomer(crm.customer_id),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                'Customer       : ${snapshot.data}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600),
                              );
                            } else {
                              return const Text('0');
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(crm.tanggal_aktivitas),
              Text(
                CurrencyFormat.convertToIdr(crm.nominal_hasil, 2).toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blue.shade300.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 950,
                      child: SingleChildScrollView(
                        child: Text(
                          ('Detail report : \n') + (crm.detail),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    // Text(
                    //   'Total price   : ${CurrencyFormat.convertToIdr(int.parse(order.nominal_hasil), 2)}',
                    //   style: const TextStyle(fontSize: 15),
                    // ),
                    const SizedBox(height: 2),
                    // Row(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 120),
                    //       child: IconButton(
                    //           onPressed: () async {
                    //             // _launchURLInApp();
                    //             // _launchURLInBrowser();
                    //           },
                    //           icon: const Icon(
                    //             Icons.link_sharp,
                    //             color: Colors.red,
                    //             size: 30,
                    //           )),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 15),
                    //       child: IconButton(
                    //           onPressed: () async {
                    //             showDialog(
                    //                 context: context,
                    //                 builder: (c) {
                    //                   return const LoadingDialogWidget(
                    //                     message: "",
                    //                   );
                    //                 });
                    //           },
                    //           icon: const Icon(
                    //             Icons.print,
                    //             color: Colors.blue,
                    //             size: 30,
                    //           )),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 15),
                    //       child: IconButton(
                    //           onPressed: () async {
                    //             showDialog(
                    //                 context: context,
                    //                 builder: (c) {
                    //                   return const LoadingDialogWidget(
                    //                     message: "",
                    //                   );
                    //                 });
                    //           },
                    //           icon: const Icon(
                    //             Icons.share,
                    //             color: Colors.greenAccent,
                    //             size: 30,
                    //           )),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
