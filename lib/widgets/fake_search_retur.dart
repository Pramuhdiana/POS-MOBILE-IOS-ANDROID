import 'package:e_shop/search/new_search_retur.dart';
import 'package:flutter/material.dart';

class FakeSearchRetur extends StatelessWidget {
  const FakeSearchRetur({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NewSearchScreenRetur()));
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
                  'Search lot by Toko...',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ],
            ),
            // Container(
            //   height: 32,
            //   width: 75,
            //   decoration: BoxDecoration(
            //       color: Colors.blue, borderRadius: BorderRadius.circular(25)),
            //   child: const Center(
            //     child: Text(
            //       'Search',
            //       style: TextStyle(fontSize: 16, color: Colors.white),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
