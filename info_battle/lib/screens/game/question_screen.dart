//@dart=2.9
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/models/question.dart';
import 'package:info_battle/utils/loading.dart';

import '../../services/database.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen(this.gameData, {Key key}) : super(key: key);

  final GameData gameData;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Question>(
        stream: DatabaseService(gameid: widget.gameData.gameId).randomQuestion,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Question questionData = snapshot.data;
            return Scaffold(
              body: Column(
                children: [
                  AlertDialog(
                    title: Text(questionData.qText),
                    content: AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText(questionData.option1),
                        WavyAnimatedText(questionData.option2),
                        WavyAnimatedText(questionData.option3),
                        WavyAnimatedText(questionData.option4),
                      ],
                    ),
                    actions: [],
                  ),
                  SizedBox(height: 20.0)
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
