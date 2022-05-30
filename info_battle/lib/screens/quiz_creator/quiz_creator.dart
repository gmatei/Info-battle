// ignore_for_file: prefer_const_constructors
//@dart = 2.9
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/models/user_data.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../services/database.dart';
import '../../utils/constants.dart';
import 'add_question.dart';

class QuizCreator extends StatefulWidget {
  const QuizCreator({Key key}) : super(key: key);

  @override
  State<QuizCreator> createState() => _QuizCreatorState();
}

class _QuizCreatorState extends State<QuizCreator> {
  DatabaseService databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String _quizTitle, _quizDescription;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).profile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: textColor,
                ),
                elevation: 10.0,
                backgroundColor: buttonIdleColor,
                title: Text(
                  'Create a Quiz',
                  style: GoogleFonts.balooDa2(
                      color: textColor,
                      fontSize: deviceWidth / 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
              body: Container(
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: deviceHeight / 7,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              style: GoogleFonts.balooDa2(
                                  color: textColor,
                                  fontSize: deviceWidth / 23,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWidth / 25,
                                  ),
                                  hintText: "Quiz Title",
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
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                              validator: (val) =>
                                  val.isEmpty ? "Enter Quiz Title" : null,
                              onChanged: (val) {
                                _quizTitle = val.trim();
                              },
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight / 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              style: GoogleFonts.balooDa2(
                                  color: textColor,
                                  fontSize: deviceWidth / 23,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWidth / 25,
                                  ),
                                  hintText: "Quiz Description",
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
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                              validator: (val) =>
                                  val.isEmpty ? "Enter Quiz Description" : null,
                              onChanged: (val) {
                                _quizDescription = val.trim();
                              },
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight / 50,
                          ),
                          Container(
                            margin: EdgeInsets.all(25),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: buttonIdleColor,
                                onPrimary: buttonActiveColor,
                                shadowColor: buttonshadowColor,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                minimumSize:
                                    Size(deviceWidth / 1.7, deviceHeight / 14),
                              ),
                              child: Text(
                                'Create Quiz',
                                style: GoogleFonts.balooDa2(
                                    color: textColor,
                                    fontSize: deviceWidth / 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                createQuiz(userData);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      )),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }

  createQuiz(UserData userData) {
    String quizId = '${userData.uid}_${DateTime.now().toIso8601String()}';
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> quizData = {
        "quizId": quizId,
        "quizAddedBy": userData.name,
        "quizTitle": _quizTitle,
        "quizDescription": _quizDescription,
      };

      databaseService.addQuizData(quizData, quizId).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
      });
    }
  }
}
