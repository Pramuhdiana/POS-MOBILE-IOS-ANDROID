// ignore_for_file: avoid_print, non_constant_identifier_names, sized_box_for_whitespace, depend_on_referenced_packages

import 'package:e_shop/eTICKETING/add_request_ticketing.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class HomeEticketing extends StatefulWidget {
  @override
  State<HomeEticketing> createState() => _HomeEticketingState();
}

class _HomeEticketingState extends State<HomeEticketing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "E-TICKETING",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          clipBehavior: Clip.none,
          children: [
            Card(
              color: Colors.green.shade50,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(32, 56, 32, 32),
                child: Text('Successful', style: TextStyle(fontSize: 32)),
              ),
            ),
            Positioned(
              top: -40,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.green.shade50, width: 4),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.gpp_good, color: Colors.green, size: 48),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => AddRequestEticketing()));
        },
        label: const Text(
          "Add request",
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add_circle_outline_sharp,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}
