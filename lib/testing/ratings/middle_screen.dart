// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/testing/ratings/model_ratings.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MidScreen extends StatelessWidget {
  const MidScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
        stream: FirebaseFirestore.instance
            .collection('allcustomer')
            // .where('alamat', isNotEqualTo: 'null')
            .where('score', isGreaterThan: 20)
            .where('score', isLessThan: 36)
            .orderBy('score', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
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
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ModelRatings(
                    customer: snapshot.data!.docs[index],
                  );
                });
          }
        });
  }
}
