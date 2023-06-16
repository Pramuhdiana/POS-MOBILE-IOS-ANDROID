// ignore_for_file: unnecessary_import, implementation_imports, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/testing/ratings/model_ratings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';

class InactiveScreen extends StatelessWidget {
  const InactiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
        stream: FirebaseFirestore.instance
            .collection('allcustomer')
            // .where('score', isNotEqualTo: 0)
            .where('score', isLessThan: 21)
            .orderBy('score', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
