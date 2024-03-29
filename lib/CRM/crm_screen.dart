// ignore_for_file: avoid_print, non_constant_identifier_names, sized_box_for_whitespace, depend_on_referenced_packages

import 'package:e_shop/CRM/add_form_crm.dart';
import 'package:e_shop/CRM/dashboard_erick.dart';
import 'package:e_shop/CRM/list_crm_telephone.dart';
import 'package:e_shop/CRM/list_crm_visit.dart';
import 'package:e_shop/CRM/list_crm_whatsapp.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/history/main_history.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class CrmScreen extends StatefulWidget {
  @override
  State<CrmScreen> createState() => _CrmScreenState();
}

class _CrmScreenState extends State<CrmScreen> {
  @override
  void initState() {
    super.initState();
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
          title: const Text(
            "CRM",
            style: TextStyle(
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
          actions: [
            // IconButton(
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (c) => const DashboardErick()));
            //   },
            //   icon: const Icon(
            //     Icons.security_rounded,
            //     color: Colors.black,
            //   ),
            // )
            // ignore: unrelated_type_equality_checks
            sharedPreferences!.getString('id') == '21' ||
                    sharedPreferences!.getString('role_sales_brand') == '15'
                ? IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const DashboardErick()));
                    },
                    icon: const Icon(
                      Icons.security_rounded,
                      color: Colors.black,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        body: const TabBarView(children: [
          ListCrmWhatsapp(),
          ListCrmTelephone(),
          ListCrmVisist(),
        ]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => AddFormCRM()));
          },
          label: const Text(
            "Add report CRM",
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(
            Icons.add_circle_outline_sharp,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
