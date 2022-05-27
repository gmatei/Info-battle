//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/models/question.dart';
import 'package:info_battle/models/user_data.dart';
import 'package:info_battle/utils/loading.dart';

import '../../services/database.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen(this.gameData, this.userData, {Key key})
      : super(key: key);

  final GameData gameData;
  final UserData userData;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int timeRemaining = 20;
  @override
  Widget build(BuildContext context) {
    bool isActivePlayer = widget.userData.name == widget.gameData.activePlayer;
    bool isAttackedPlayer =
        widget.userData.name == widget.gameData.attackedPlayer;
    return StreamBuilder<Question>(
        stream: DatabaseService(gameid: widget.gameData.gameId).currentQuestion,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Question questionData = snapshot.data;
            List<String> options = [
              questionData.option1,
              questionData.option2,
              questionData.option3,
              questionData.option4
            ];

            if (questionData.qText == 'none') {
              return Loading();
            } else {
              return Column(
                children: [
                  AlertDialog(
                    title: Text(questionData.qText),
                  ),
                  SizedBox(height: 20.0),
                  for (int i = 0; i < 4; i++)
                    Container(
                      width: MediaQuery.of(context).size.width / 1.25,
                      height: MediaQuery.of(context).size.height / 12,
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: widget.gameData.command == 'showAnswer' &&
                                  options[i] ==
                                      widget.gameData
                                          .currentQuestion['correctAnswer']
                              ? BorderSide(width: 5.0, color: Colors.yellow)
                              : BorderSide(width: 1.0, color: Colors.black),
                          backgroundColor: isActivePlayer
                              ? (widget.gameData.attackedAnswer == options[i] &&
                                      options[i] ==
                                          widget.gameData.activeAnswer &&
                                      widget.gameData.command == 'showAnswer'
                                  ? Colors.purple
                                  : widget.gameData.activeAnswer == options[i]
                                      ? Colors.blue
                                      : options[i] ==
                                                  widget.gameData
                                                      .attackedAnswer &&
                                              widget.gameData.command ==
                                                  'showAnswer'
                                          ? Colors.red
                                          : Colors.white70)
                              : isAttackedPlayer
                                  ? (widget.gameData.attackedAnswer ==
                                              options[i] &&
                                          options[i] ==
                                              widget.gameData.activeAnswer &&
                                          widget.gameData.command ==
                                              'showAnswer'
                                      ? Colors.purple
                                      : widget.gameData.attackedAnswer ==
                                              options[i]
                                          ? Colors.red
                                          : options[i] ==
                                                      widget.gameData
                                                          .activeAnswer &&
                                                  widget.gameData.command ==
                                                      'showAnswer'
                                              ? Colors.blue
                                              : Colors.white70)
                                  : (options[i] ==
                                              widget.gameData.activeAnswer &&
                                          widget.gameData.attackedAnswer ==
                                              options[i]
                                      ? Colors.purple
                                      : options[i] ==
                                              widget.gameData.activeAnswer
                                          ? Colors.blue
                                          : widget.gameData.attackedAnswer ==
                                                  options[i]
                                              ? Colors.red
                                              : Colors.white70),
                          primary: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                        onPressed: () {
                          if (widget.gameData.command == 'question') {
                            if (isActivePlayer &&
                                widget.gameData.activeAnswer == 'none') {
                              DatabaseService(gameid: widget.gameData.gameId)
                                  .setActiveAnswer(options[i]);
                            }
                            if (isAttackedPlayer &&
                                widget.gameData.attackedAnswer == 'none') {
                              DatabaseService(gameid: widget.gameData.gameId)
                                  .setAttackedAnswer(options[i]);
                            }
                          }
                        },
                        child: Text(
                          options[i],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  widget.gameData.activeAnswer == 'none' &&
                          widget.gameData.attackedAnswer == 'none'
                      ? CountdownTimer(
                          endTime:
                              DateTime.now().millisecondsSinceEpoch + 1000 * 20,
                          widgetBuilder: (_, CurrentRemainingTime time) {
                            if (time == null) {
                              return Text(
                                'Time\'s up!',
                                style: TextStyle(fontSize: 20),
                              );
                            }

                            return CircularCountdown(
                              countdownTotal: 20,
                              countdownRemaining: time.sec,
                              countdownRemainingColor: Colors.greenAccent,
                              textStyle: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 25,
                              ),
                            );
                          })
                      : SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                ],
              );
            }
          } else {
            return Loading();
          }
        });
  }
}
