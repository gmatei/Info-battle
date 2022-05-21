// ignore_for_file: prefer_const_constructors
//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:info_battle/models/questionset.dart';
import 'package:info_battle/screens/play/quiz_list.dart';
import 'package:info_battle/screens/play/quiz_tile.dart';
import 'package:info_battle/services/database.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:provider/provider.dart';

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
  bool showAlertDialog = false;
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
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            showAlertDialog
                ? AlertDialog(
                    title: Text("No Set of Questions selected!"),
                    content: Text("Please select at least one question set!"),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          setState(() {
                            showAlertDialog = false;
                          });
                        },
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                if (widget.selectedList.isNotEmpty) {
                  widget.callBack(widget.selectedList);
                  Navigator.pop(context);
                } else {
                  setState(() {
                    showAlertDialog = true;
                  });
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 1.1,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  "Set Questions",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            QuizList(widget.callBackCheck),
          ],
        )),
      ),
    );
  }
}
