// ignore_for_file: avoid_print, non_constant_identifier_names, sized_box_for_whitespace, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class DetailCrmByCustomer extends StatefulWidget {
  //fungsi untuk menerima data
  String str = '';
  String tokoName = 'Unkonwn';
  int salesId = 0;
  int tokoId = 0;
  int activityId = 0;

  //init data
  DetailCrmByCustomer(
      {super.key,
      required this.str,
      required this.tokoName,
      required this.salesId,
      required this.tokoId,
      required this.activityId});
  @override
  State<DetailCrmByCustomer> createState() => _DetailCrmByCustomerState();
}

class _DetailCrmByCustomerState extends State<DetailCrmByCustomer> {
  @override
  void initState() {
    super.initState();
    //show data
    print(widget.str);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Image.asset(
          //     "assets/arrow.png",
          //     width: 35,
          //     height: 35,
          //   ),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            // "DETAIL ${widget.str}",
            // widget.tokoName,
            "ON PROGRESS",
            style: TextStyle(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          // title: const FakeSearch(),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Container(
          color: Colors.white,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Lottie.asset("json/think.json"),
            ),
            const Center(
              child: Text(
                'Develover \n\n Masih berfikir...',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Acne',
                    letterSpacing: 1.5),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Kembali',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Acne',
                        letterSpacing: 1.5),
                  ),
                ),
              ),
            )
          ]),
        ));
  }
}
