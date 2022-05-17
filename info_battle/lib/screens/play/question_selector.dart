// ignore_for_file: prefer_const_constructors
//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:info_battle/models/questionset.dart';
import 'package:info_battle/screens/play/quiz_list.dart';
import 'package:info_battle/services/database.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:provider/provider.dart';

class QuestionSelector extends StatefulWidget {
  const QuestionSelector({Key key}) : super(key: key);

  @override
  State<QuestionSelector> createState() => _QuestionSelectorState();
}

class _QuestionSelectorState extends State<QuestionSelector> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<QuestionSet>>.value(
        value: DatabaseService().questionSets,
        initialData: const [],
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              title: Text('Select question sets to include'),
              elevation: 10.0,
            ),
            body: QuizList()));
  }
}
