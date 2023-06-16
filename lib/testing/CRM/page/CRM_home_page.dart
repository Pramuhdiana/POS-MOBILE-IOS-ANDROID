// ignore_for_file: file_names, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:e_shop/testing/CRM/data/categories.dart';
import 'package:e_shop/testing/CRM/page/category_page.dart';
import 'package:e_shop/testing/CRM/widget/category_detail_widget.dart';
import 'package:e_shop/testing/CRM/widget/category_header_widget.dart';
import 'package:flutter/material.dart';

class CRMHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            buildCategories(),
            const SizedBox(height: 32),
            buildPopular(context),
          ],
        ),
      );

  Widget buildWelcome(String username) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hello',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            username,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],
      );

  Widget buildCategories() => Container(
        height: 300,
        child: GridView(
          primary: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
          ),
          children: categories
              .map((category) => CategoryHeaderWidget(category: category))
              .toList(),
        ),
      );

  Widget buildPopular(BuildContext context) => Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Popular',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 240,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: categories
                  .map((category) => CategoryDetailWidget(
                        category: category,
                        onSelectedCategory: (category) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CRMCategoryPage(
                              category: category,
                              key: null,
                            ),
                          ));
                        },
                      ))
                  .toList(),
            ),
          )
        ],
      );
}
