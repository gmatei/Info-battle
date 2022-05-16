// ignore_for_file: prefer_const_constructors
//@dart = 2.9
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:info_battle/models/user_data.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../services/database.dart';
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
              appBar: AppBar(
                backgroundColor: Colors.brown[400],
                title: Text('Create a Quiz'),
                elevation: 10.0,
              ),
              body: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (val) =>
                              val.isEmpty ? "Enter Quiz Title" : null,
                          decoration: InputDecoration(
                              hintText: "Quiz Title",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          onChanged: (val) {
                            _quizTitle = val;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (val) =>
                              val.isEmpty ? "Enter Quiz Description" : null,
                          decoration: InputDecoration(
                              hintText: "Quiz Description",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          onChanged: (val) {
                            _quizDescription = val;
                          },
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          createQuiz(userData);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "Create Quiz",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  )),
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
        "quizAddedBy": userData.name,
        "quizTitle": _quizTitle,
        "quizDescription": _quizDescription
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
