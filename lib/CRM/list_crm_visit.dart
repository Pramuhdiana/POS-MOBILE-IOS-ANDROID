import 'package:e_shop/CRM/list_crm_screen.dart';
import 'package:e_shop/database/db_crm.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ListCrmVisist extends StatelessWidget {
  const ListCrmVisist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DbCRM.db.getAllCrmById(3),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Container(
                    padding: const EdgeInsets.all(0),
                    width: 90,
                    height: 90,
                    child: Lottie.asset("json/loading_black.json")));
          }

          if (snapshot.data.isEmpty) {
            return const Center(
                child: Text(
              'You Have not \n\n report Visit',
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
                  return ListCrmScreen(
                    // customer: snapshot2.data[index],
                    crm: snapshot.data[index],
                  );
                });
          }
        });
  }
}
