//@dart = 2.9

// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/utils/constants.dart';
import 'package:info_battle/utils/loading.dart';

import '../../services/database.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  const AddQuestion(this.quizId, {Key key}) : super(key: key);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  DatabaseService databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String question, option1, option2, option3, option4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: buttonIdleColor,
        title: Text(
          'Add Quiz Question',
          style: GoogleFonts.balooDa2(
              color: textColor,
              fontSize: deviceWidth / 17,
              fontWeight: FontWeight.bold),
        ),
        elevation: 10.0,
      ),
      body: isLoading
          ? Loading()
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fill,
                  image: questionImage,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(
                          height: deviceHeight / 7,
                        ),
                        TextFormField(
                          style: GoogleFonts.balooDa2(
                              color: textColor,
                              fontSize: deviceHeight / 50,
                              fontWeight: FontWeight.bold),
                          validator: (val) =>
                              val.isEmpty ? "Enter Question" : null,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: deviceHeight / 65,
                              ),
                              hintText: "Question",
                              filled: true,
                              fillColor: formColor,
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
                                borderRadius: BorderRadius.circular(20),
                              )),
                          onChanged: (val) {
                            question = val;
                          },
                        ),
                        SizedBox(
                          height: deviceHeight / 60,
                        ),
                        TextFormField(
                          style: GoogleFonts.balooDa2(
                              color: textColor,
                              fontSize: deviceHeight / 50,
                              fontWeight: FontWeight.bold),
                          validator: (val) => val.isEmpty ? "Option 1 " : null,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: deviceHeight / 65,
                              ),
                              filled: true,
                              fillColor: formColor,
                              hintText: "Option 1 (Correct answer)",
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
                                borderRadius: BorderRadius.circular(20),
                              )),
                          onChanged: (val) {
                            option1 = val;
                          },
                        ),
                        SizedBox(
                          height: deviceHeight / 60,
                        ),
                        TextFormField(
                          style: GoogleFonts.balooDa2(
                              color: textColor,
                              fontSize: deviceHeight / 50,
                              fontWeight: FontWeight.bold),
                          validator: (val) => val.isEmpty ? "Option 2 " : null,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: deviceHeight / 65,
                              ),
                              filled: true,
                              fillColor: formColor,
                              hintText: "Option 2",
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
                                borderRadius: BorderRadius.circular(20),
                              )),
                          onChanged: (val) {
                            option2 = val;
                          },
                        ),
                        SizedBox(
                          height: deviceHeight / 60,
                        ),
                        TextFormField(
                          style: GoogleFonts.balooDa2(
                              color: textColor,
                              fontSize: deviceHeight / 50,
                              fontWeight: FontWeight.bold),
                          validator: (val) => val.isEmpty ? "Option 3 " : null,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: deviceHeight / 65,
                              ),
                              filled: true,
                              fillColor: formColor,
                              hintText: "Option 3",
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
                                borderRadius: BorderRadius.circular(20),
                              )),
                          onChanged: (val) {
                            option3 = val;
                          },
                        ),
                        SizedBox(
                          height: deviceHeight / 60,
                        ),
                        TextFormField(
                          style: GoogleFonts.balooDa2(
                              color: textColor,
                              fontSize: deviceHeight / 50,
                              fontWeight: FontWeight.bold),
                          validator: (val) => val.isEmpty ? "Option 4 " : null,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: deviceHeight / 65,
                              ),
                              filled: true,
                              fillColor: formColor,
                              hintText: "Option 4",
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
                                borderRadius: BorderRadius.circular(20),
                              )),
                          onChanged: (val) {
                            option4 = val;
                          },
                        ),
                        SizedBox(
                          height: deviceHeight / 50,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(deviceWidth / 85),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: buttonIdleColor,
                                  onPrimary: buttonActiveColor,
                                  shadowColor: buttonshadowColor,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  minimumSize:
                                      Size(deviceWidth / 6, deviceHeight / 15),
                                ),
                                child: Text(
                                  'Submit Quiz',
                                  style: GoogleFonts.balooDa2(
                                      color: textColor,
                                      fontSize: deviceWidth / 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(deviceWidth / 19),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: buttonIdleColor,
                                  onPrimary: buttonActiveColor,
                                  shadowColor: buttonshadowColor,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  minimumSize:
                                      Size(deviceWidth / 6, deviceHeight / 15),
                                ),
                                child: Text(
                                  'Add Question',
                                  style: GoogleFonts.balooDa2(
                                      color: textColor,
                                      fontSize: deviceWidth / 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  uploadQuizData();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  uploadQuizData() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
        'correctAnswer': option1
      };

      databaseService.addQuestionData(questionMap, widget.quizId).then((value) {
        question = "";
        option1 = "";
        option2 = "";
        option3 = "";
        option4 = "";

        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        print(e);
      });
    }
  }
}
