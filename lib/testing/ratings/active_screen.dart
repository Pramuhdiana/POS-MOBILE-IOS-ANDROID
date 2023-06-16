import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/testing/ratings/model_ratings.dart';
import 'package:flutter/material.dart';

class ActiveScreen extends StatelessWidget {
  const ActiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
        stream: FirebaseFirestore.instance
            .collection('allcustomer')
            // .where('alamat', isNotEqualTo: 'null')
            .where('score', isGreaterThan: 30)
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

//  return FutureBuilder(
//         future: DbAllCustomer.db.getAllcustomer(0), //kirim score
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasError) {
//             return const Text('Something went wrong');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             return ListView.builder(
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ModelRatings(
//                     customer: snapshot.data[index],
//                   );
//                 });
//           }
//         });