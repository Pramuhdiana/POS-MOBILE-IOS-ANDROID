// ignore_for_file: avoid_print, non_constant_identifier_names, sized_box_for_whitespace, depend_on_referenced_packages

import 'package:e_shop/CRM/detailCrm/detail_list_crm_telephone.dart';
import 'package:e_shop/CRM/detailCrm/detail_list_crm_visit.dart';
import 'package:e_shop/CRM/detailCrm/detail_list_crm_whatsapp.dart';
import 'package:e_shop/history/main_history.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class DetailCrmSalesScreen extends StatefulWidget {
  //fungsi untuk menerima data
  String str = '';
  //init data
  DetailCrmSalesScreen({super.key, required this.str});
  @override
  State<DetailCrmSalesScreen> createState() => _DetailCrmSalesScreenState();
}

class _DetailCrmSalesScreenState extends State<DetailCrmSalesScreen> {
  @override
  void initState() {
    super.initState();
    //show data
    print(widget.str);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
            "CRM ${widget.str}",
            style: const TextStyle(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          // title: const FakeSearch(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          bottom: const TabBar(
              indicatorColor: Colors.black,
              indicatorWeight: 5,
              tabs: [
                RepeatedTab(label: 'Whatsapp'),
                RepeatedTab(label: 'Telephone'),
                RepeatedTab(label: 'Visit'),
              ]),
        ),
        body: const TabBarView(children: [
          DetailListCrmWhatsapp(),
          DetailListCrmTelephone(),
          DetailListCrmVisist(),
        ]),
      ),
    );
  }
}
