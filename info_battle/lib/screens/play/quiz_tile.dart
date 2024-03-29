//@dart=2.9
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/models/questionset.dart';

import '../../utils/constants.dart';

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
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: buttonIdleColor, width: 3),
            borderRadius: BorderRadius.circular(25),
            color: formColor,
          ),
          child: CheckboxListTile(
              title: Text(
                widget.quiz.title,
                style: GoogleFonts.balooDa2(
                  color: textColor,
                  fontSize: deviceWidth / 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${widget.quiz.description}\nAdded by: ${widget.quiz.addedBy}',
                style: GoogleFonts.balooDa2(
                  color: buttonIdleColor,
                  fontSize: deviceWidth / 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: _checked,
              activeColor: textColor,
              checkColor: buttonIdleColor,
              onChanged: (bool value) {
                setState(() {
                  _checked = value;
                  widget.callBackCheck(value, widget.quiz.qsetId);
                });
              }),
        ));
  }
}
