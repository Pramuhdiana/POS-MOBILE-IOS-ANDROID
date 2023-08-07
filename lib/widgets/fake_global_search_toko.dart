import 'package:flutter/material.dart';

import '../search/new_search_global_toko.dart';

class FakeGlobalSearchToko extends StatelessWidget {
  const FakeGlobalSearchToko({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewSearchScreenGlobalToko()));
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.4),
            borderRadius: BorderRadius.circular(25)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Global search all Toko..',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
