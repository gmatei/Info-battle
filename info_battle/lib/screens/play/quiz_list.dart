//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:info_battle/models/questionset.dart';
import 'package:info_battle/screens/play/quiz_tile.dart';
import 'package:provider/provider.dart';

class QuizList extends StatefulWidget {
  const QuizList(
    this.callBackCheck,
    this.quizName, {
    Key key,
  }) : super(key: key);

  final Function callBackCheck;
  final String quizName;

  @override
  State<QuizList> createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  @override
  Widget build(BuildContext context) {
    final quizzes = Provider.of<List<QuestionSet>>(context);
    if (widget.quizName != 'none') {
      quizzes.removeWhere((quiz) => !quiz.title.contains(widget.quizName));
    }

    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.symmetric(
        horizontal: 32,
      ),
      physics: BouncingScrollPhysics(),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 3),
          child: QuizTile(
            quiz: quizzes[index],
            callBackCheck: widget.callBackCheck,
          ),
        );
      },
    );
  }
}
