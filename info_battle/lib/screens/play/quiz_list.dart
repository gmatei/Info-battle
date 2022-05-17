//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:info_battle/models/questionset.dart';
import 'package:info_battle/screens/play/quiz_tile.dart';
import 'package:provider/provider.dart';

class QuizList extends StatefulWidget {
  const QuizList({Key key}) : super(key: key);

  @override
  State<QuizList> createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  @override
  Widget build(BuildContext context) {
    final quizzes = Provider.of<List<QuestionSet>>(context);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 32),
      physics: BouncingScrollPhysics(),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        return QuizTile(quiz: quizzes[index]);
      },
    );
  }
}
