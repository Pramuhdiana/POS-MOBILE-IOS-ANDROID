// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_local_variable

import 'package:e_shop/testing/CRM/model/category.dart';
import 'package:e_shop/testing/CRM/model/option.dart';
import 'package:e_shop/testing/CRM/model/question.dart';
import 'package:e_shop/testing/CRM/widget/question_numbers_widget.dart';
import 'package:e_shop/testing/CRM/widget/questions_widget.dart';
import 'package:flutter/material.dart';

class CRMCategoryPage extends StatefulWidget {
  final Category? category;

  const CRMCategoryPage({this.category, required key});
  @override
  _CRMCategoryPageState createState() => _CRMCategoryPageState();
}

class _CRMCategoryPageState extends State<CRMCategoryPage> {
  late PageController controller;
  late Question question;

  @override
  void initState() {
    super.initState();

    controller = PageController();
    question = widget.category!.questions.first;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.lightBlueAccent,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )),
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: QuestionNumbersWidget(
                questions: widget.category!.questions,
                question: question,
                onClickedNumber: (index) =>
                    nextQuestion(index: index, jump: true),
              ),
            ),
          ),
        ),
        body: QuestionsWidget(
          category: widget.category,
          controller: controller,
          onChangedPage: (index) => nextQuestion(index: index),
          onClickedOption: selectOption,
        ),
      );

  void selectOption(Option option) {
    if (question.isLocked) {
      setState(() {
        question.isLocked = true;
        question.selectedOption = option;
      });
    } else {
      setState(() {
        question.isLocked = true;
        question.selectedOption = option;
      });
    }
  }

  void nextQuestion({required int index, bool jump = false}) {
    final nextPage = controller.page! + 1;
    final indexPage = index;

    setState(() {
      question = widget.category!.questions[indexPage];
    });

    if (jump) {
      controller.jumpToPage(indexPage);
    }
  }
}
