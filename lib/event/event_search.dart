import 'package:e_shop/search/new_search_event.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EventSearch extends StatelessWidget {
  const EventSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NewSearchEventScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Container(
            padding: const EdgeInsets.all(0),
            child: Lottie.asset("json/search.json")),
      ),
    );
  }
}
