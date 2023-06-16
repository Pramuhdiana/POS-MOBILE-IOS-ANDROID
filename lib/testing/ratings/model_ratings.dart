// ignore_for_file: depend_on_referenced_packages, unnecessary_import, unused_local_variable, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class ModelRatings extends StatelessWidget {
  //Read an image data from website/webspace

  final dynamic customer;
  const ModelRatings({Key? key, required this.customer}) : super(key: key);

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
            constraints: const BoxConstraints(maxHeight: 18),
            width: double.infinity,
            child: Row(
              children: [
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Name       : ${customer['name']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(('${customer['alamat']}')),
              SmoothStarRating(
                // rating: double.parse((42 / 10).toString()),
                rating: double.parse((customer['score'] / 10).toString()),
                starCount: 5,
                color: Colors.blueAccent,
                borderColor: Colors.blue,
                size: 30,
              ),
            ],
          ),
          // children: [
          //   Container(
          //     height: 120,
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //         color: Colors.blue.shade300.withOpacity(0.2),
          //         borderRadius: BorderRadius.circular(15)),
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             ('Toko              : ') + (customer.phone),
          //             style: const TextStyle(fontSize: 15),
          //           ),
          //           // Text(
          //           //   ('Total Item     : ') + (order.total_quantity.toString()),
          //           //   style: const TextStyle(fontSize: 15),
          //           // ),
          //           // Text(
          //           //   'Total Harga   : ${CurrencyFormat.convertToIdr(int.parse(order.total_rupiah), 2)}',
          //           //   style: const TextStyle(fontSize: 15),
          //           // ),
          //           const SizedBox(height: 2),
          //           Row(
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.only(left: 120),
          //                 child: IconButton(
          //                     onPressed: () async {
          //                       // _createPdf();
          //                     },
          //                     icon: const Icon(
          //                       Icons.print,
          //                       color: Colors.blue,
          //                       size: 30,
          //                     )),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.only(left: 15),
          //                 child: IconButton(
          //                     onPressed: () async {
          //                       // _sharePdf();
          //                     },
          //                     icon: const Icon(
          //                       Icons.share,
          //                       color: Colors.greenAccent,
          //                       size: 30,
          //                     )),
          //               ),
          //             ],
          //           )
          //         ],
          //       ),
          //     ),
          //   )
          // ],
        ),
      ),
    );
  }
}
