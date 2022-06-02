// ignore_for_file: prefer_const_constructors
//@dart=2.9
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/models/questionset.dart';
import 'package:info_battle/screens/play/quiz_list.dart';
import 'package:info_battle/screens/play/quiz_tile.dart';
import 'package:info_battle/services/database.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';

class QuestionSelector extends StatefulWidget {
  QuestionSelector(this.callBack, {Key key}) : super(key: key);

  final Function callBack;
  final List<QuestionSet> selectedList = [];

  callBackCheck(bool checked, String qSetId) {
    if (checked) {
      selectedList.add(QuestionSet(qsetId: qSetId));
    } else {
      selectedList.remove(QuestionSet(qsetId: qSetId));
    }
  }

  @override
  State<QuestionSelector> createState() => _QuestionSelectorState();
}

class _QuestionSelectorState extends State<QuestionSelector> {
  final _formKey = GlobalKey<FormState>();
  String quizName = 'none';
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<QuestionSet>>.value(
      value: DatabaseService().questionSets,
      initialData: const [],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: buttonIdleColor,
          elevation: 10.0,
          iconTheme: IconThemeData(
            color: textColor,
          ),
          title: Text(
            'Select question sets to include',
            style: GoogleFonts.balooDa2(
              color: textColor,
              fontSize: deviceWidth / 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.fill,
              image: createImage,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: deviceHeight / 10),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: deviceHeight / 40),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: buttonIdleColor,
                        onPrimary: buttonActiveColor,
                        shadowColor: buttonshadowColor,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minimumSize: Size(deviceWidth / 1.3, deviceHeight / 16),
                      ),
                      child: Text(
                        'Set Questions',
                        style: GoogleFonts.balooDa2(
                            color: textColor,
                            fontSize: deviceWidth / 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        widget.callBack(widget.selectedList);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(height: deviceHeight / 500),
                  SizedBox(
                    width: deviceWidth / 1.5,
                    height: deviceHeight / 11,
                    child: TextFormField(
                      style: GoogleFonts.balooDa2(
                          color: textColor,
                          fontSize: deviceWidth / 25,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: deviceWidth / 25,
                          ),
                          filled: true,
                          fillColor: formColor,
                          hintText: 'Filter quizzes by name',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: buttonActiveColor,
                              width: 4.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: buttonIdleColor,
                              width: 4.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      validator: (val) =>
                          val.isEmpty ? "Enter Quiz Name" : null,
                      onChanged: (val) {
                        setState(() {
                          quizName = val;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: deviceHeight / 40),
                  SizedBox(
                      height: deviceHeight / 1.7,
                      width: deviceWidth / 1,
                      child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: QuizList(widget.callBackCheck, quizName))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
