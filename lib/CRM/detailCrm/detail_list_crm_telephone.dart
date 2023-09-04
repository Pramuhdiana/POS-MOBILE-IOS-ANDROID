import 'package:e_shop/CRM/detailCrm/detail_list_crm_screen.dart';
import 'package:e_shop/database/db_crm.dart';
import 'package:e_shop/global/global.dart';
import 'package:flutter/material.dart';

class DetailListCrmTelephone extends StatelessWidget {
  const DetailListCrmTelephone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DbCRM.db
            .getAllCrmBySales(2, sharedPreferences!.getInt('detailIdSales')),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data.isEmpty) {
            return const Center(
                child: Text(
              'Report Telephone',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Acne',
                  letterSpacing: 1.5),
            ));
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return DetailListCrmScreen(
                    // customer: snapshot2.data[index],
                    crm: snapshot.data[index],
                  );
                });
          }
        });
  }
}