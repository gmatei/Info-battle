//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:info_battle/models/questionset.dart';
import 'package:info_battle/services/database.dart';

class QuizTile extends StatefulWidget {
  const QuizTile({Key key, this.quiz, this.callBackCheck}) : super(key: key);
  final QuestionSet quiz;
  final Function callBackCheck;
  @override
  State<QuizTile> createState() => _QuizTileState();
}

class _QuizTileState extends State<QuizTile> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: CheckboxListTile(
            title: Text(widget.quiz.title),
            value: _checked,
            onChanged: (bool value) {
              setState(() {
                _checked = value;
                widget.callBackCheck(value, widget.quiz.qsetId);
              });
            }));
  }
}
