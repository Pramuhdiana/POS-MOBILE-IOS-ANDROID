import 'package:e_shop/testing/CRM/data/questions.dart';
import 'package:e_shop/testing/CRM/model/category.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final categories = <Category>[
  Category(
    questions: questions,
    backgroundColor: Colors.blue,
    icon: FontAwesomeIcons.rocket,
    description: 'Practice questions from various chapters in physics',
  ),
];
