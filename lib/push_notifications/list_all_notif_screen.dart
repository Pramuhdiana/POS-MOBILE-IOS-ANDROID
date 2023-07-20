// ignore_for_file: depend_on_referenced_packages, unnecessary_import, unused_local_variable, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, avoid_print, deprecated_member_use, must_be_immutable, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListAllNotifScreen extends StatelessWidget {
  //Read an image data from website/webspace
  String nameToko = 'awal';

  final dynamic notif;
  final dynamic customer;
  ListAllNotifScreen({Key? key, required this.notif, this.customer})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    void myAlert(detail) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text(
                detail,
                style: const TextStyle(fontSize: 15),
              ),
              content: Container(
                height: MediaQuery.of(context).size.height / 6,
              ),
            );
          });
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.black, shape: const StadiumBorder()),
        onPressed: () {
          myAlert(notif.body);
        },
        child: Container(
          constraints: const BoxConstraints(maxHeight: 40),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Title   :  ${notif.title}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notif.created_at,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Read more...',
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue.shade100,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // subtitle: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(notif.created_at),
        //     // Text(
        //     //   CurrencyFormat.convertToIdr(crm.nominal_hasil, 2).toString(),
        //     //   overflow: TextOverflow.ellipsis,
        //     //   maxLines: 1,
        //     //   style: TextStyle(
        //     //       fontSize: 15,
        //     //       color: Colors.grey.shade600,
        //     //       fontWeight: FontWeight.w600),
        //     // ),
        //   ],
        // ),
        // children: [
        //   Container(
        //     height: 120,
        //     width: double.infinity,
        //     decoration: BoxDecoration(
        //         color: Colors.grey.shade600.withOpacity(0.2),
        //         borderRadius: BorderRadius.circular(15)),
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           SizedBox(
        //             height: 100,
        //             width: 950,
        //             child: SingleChildScrollView(
        //               child: Text(
        //                 ('Detail report : \n') + (notif.body),
        //                 style: const TextStyle(fontSize: 15),
        //               ),
        //             ),
        //           ),
        //           const SizedBox(height: 2),
        //         ],
        //       ),
        //     ),
        //   )
        // ],
      ),
      // ),
    );
  }
}
