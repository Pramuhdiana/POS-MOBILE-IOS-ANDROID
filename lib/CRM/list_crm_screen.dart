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
            border: Border.all(color: Colors.black),
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
                              return const Text('');
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
              Expanded(child: Text(crm.tanggal_aktivitas)),
              Expanded(
                child: Text(
                  CurrencyFormat.convertToIdr(crm.nominal_hasil, 0).toString(),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.shade600.withOpacity(0.2),
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
                    const SizedBox(height: 2),
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
