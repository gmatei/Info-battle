//@dart=2.9
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/models/game_player.dart';
import 'package:info_battle/screens/game/question_screen.dart';

import '../../models/user_data.dart';
import '../../services/database.dart';

class AlertDialogManager extends StatefulWidget {
  const AlertDialogManager(this.gameData, this.userData, {Key key})
      : super(key: key);

  final GameData gameData;
  final UserData userData;
  @override
  State<AlertDialogManager> createState() => _AlertDialogManagerState();
}

class _AlertDialogManagerState extends State<AlertDialogManager> {
  @override
  Widget build(BuildContext context) {
    switch (widget.gameData.command) {
      case "init":
        {
          return AlertDialog(
            title: Text("Info Battle started"),
            content: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText("Wait for everyone to connect..."),
              ],
            ),
            actions: [],
          );
        }

      case 'round':
        {
          return AlertDialog(
            title: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                    "Round ${widget.gameData.currentRound} / 5"),
              ],
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 17,
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                      '${widget.gameData.activePlayer}\'s turn'),
                ],
              ),
            ),
            actions: [],
          );
        }

      case 'playerChoice':
        {
          if (widget.userData.name == widget.gameData.activePlayer) {
            return AlertDialog(
              title: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                      "Round ${widget.gameData.currentRound} / 5"),
                ],
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                child: Column(
                  children: [
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText('Who do you want to attack?'),
                      ],
                    ),
                    StreamBuilder<List<PlayerData>>(
                        stream: DatabaseService(gameid: widget.gameData.gameId)
                            .gamePlayers,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<PlayerData> playerData = snapshot.data;
                            playerData.removeWhere((element) =>
                                element.uid == widget.userData.uid);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton.icon(
                                  icon: Icon(Icons.person),
                                  label: Text(playerData[0].name),
                                  onPressed: () async {
                                    DatabaseService(
                                            gameid: widget.gameData.gameId)
                                        .updateCommand('attack',
                                            widget.gameData.activePlayer,
                                            attacked: playerData[0].name);
                                  },
                                ),
                                TextButton.icon(
                                  icon: Icon(Icons.person),
                                  label: Text(playerData[1].name),
                                  onPressed: () async {
                                    DatabaseService(
                                            gameid: widget.gameData.gameId)
                                        .updateCommand('attack',
                                            widget.gameData.activePlayer,
                                            attacked: playerData[1].name);
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Text('...');
                          }
                        }),
                  ],
                ),
              ),
              actions: [],
            );
          } else {
            return AlertDialog(
              title: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                      "Round ${widget.gameData.currentRound} / 5"),
                ],
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                child: Column(
                  children: [
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                            'Wait for ${widget.gameData.activePlayer} to make his choice...'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [],
            );
          }
        }
        break;

      case 'attack':
        {
          return AlertDialog(
            title: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                    "Round ${widget.gameData.currentRound} / 5"),
              ],
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 10,
              child: Column(
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                          '${widget.gameData.activePlayer} is attacking ${widget.gameData.attackedPlayer}'),
                    ],
                  ),
                ],
              ),
            ),
            actions: [],
          );
        }

      case 'question':
        {}
        break;

      case 'showAnswer':
        {}
        break;

      case 'returnFromQuestion':
        {
          return AlertDialog(
            title: Text(widget.gameData.command),
            content: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText(widget.gameData.activeUpdate),
                WavyAnimatedText(widget.gameData.attackedUpdate),
              ],
            ),
            actions: [],
          );
        }
        break;

      default:
        {
          return AlertDialog(
            title: Text(widget.gameData.command),
            content: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText("Work going on behind the scenes...")
              ],
            ),
            actions: [],
          );
        }
    }
  }
}
