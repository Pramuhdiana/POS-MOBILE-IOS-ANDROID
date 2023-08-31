// ignore_for_file: avoid_print, non_constant_identifier_names, sized_box_for_whitespace, depend_on_referenced_packages

import 'package:e_shop/database/db_crm.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class DetailActivitySalesScreen extends StatefulWidget {
  //fungsi untuk menerima data
  String str = '';
  String tokoName = 'Unkonwn';
  int salesId = 0;
  int tokoId = 0;
  int activityId = 0;

  //init data
  DetailActivitySalesScreen(
      {super.key,
      required this.str,
      required this.tokoName,
      required this.salesId,
      required this.tokoId,
      required this.activityId});
  @override
  State<DetailActivitySalesScreen> createState() =>
      _DetailActivitySalesScreenState();
}

class _DetailActivitySalesScreenState extends State<DetailActivitySalesScreen> {
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
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            // "DETAIL ${widget.str}",
            widget.tokoName,
            style: const TextStyle(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          // title: const FakeSearch(),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Container(
          color: Colors.grey.shade200,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BubbleSpecialOne(
                text: widget.str,
                isSender: false,
                color: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
                child: FutureBuilder(
                    future: DbCRM.db.getAllDetailCrm(
                        widget.activityId, widget.salesId, widget.tokoId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = snapshot.data![index];
                            var date = DateTime.parse(data.tanggal_aktivitas!);

                            return Padding(
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  children: [
                                    DateChip(
                                      date: DateTime(
                                          date.year, date.month, date.day),
                                    ),
                                    BubbleSpecialThree(
                                      text: data.detail.toString(),
                                      color:
                                          const Color.fromARGB(255, 7, 19, 27),
                                      tail: true,
                                      isSender: true, //true kanan
                                      seen: true,
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    // Text(data.tanggal_aktivitas.toString()),
                                  ],
                                ));
                          });
                    }))
          ]),
        ));
  }
}
