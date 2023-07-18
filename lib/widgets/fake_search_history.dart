import 'package:e_shop/search/new_search_history.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FakeSearchHistory extends StatelessWidget {
  const FakeSearchHistory({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NewSearchScreenHistory()));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: SizedBox(
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => const NewSearchScreenHistory()));
            },
            icon: const Icon(
              Iconsax.search_normal_14,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
