import 'package:e_shop/search/new_search.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FakeSearch extends StatelessWidget {
  const FakeSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NewSearchScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: SizedBox(
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => NewSearchScreen()));
            },
            icon: const Icon(
              Iconsax.search_normal_14,
              color: Colors.black,
            ),
            // Expanded(
            //   child: Text('Search by Lot...',
            //       maxLines: 1,
            //       style: TextStyle(
            //         color: Colors.grey.shade400,
            //         fontSize: 16,
            //         overflow: TextOverflow.fade,
            //       )),
            // ),
          ),
        ),
      ),
    );
  }
}
