//@dart=2.9
// ignore_for_file: prefer_const_constructors, missing_return

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/models/game_player.dart';
import 'package:info_battle/utils/constants.dart';

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
            backgroundColor: formColor,
            elevation: 10.0,
            title: Text(
              "Info Battle started",
              style: GoogleFonts.balooDa2(
                color: buttonIdleColor,
                fontSize: deviceWidth / 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText(
                  "Wait for everyone to connect...",
                  textStyle: GoogleFonts.balooDa2(
                    color: textColor,
                    fontSize: deviceWidth / 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        }

      case 'round':
        {
          return AlertDialog(
            backgroundColor: formColor,
            elevation: 10.0,
            title: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  "Round ${widget.gameData.currentRound} / ${widget.gameData.totalRounds}",
                  textStyle: GoogleFonts.balooDa2(
                    color: buttonIdleColor,
                    fontSize: deviceWidth / 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    '${widget.gameData.activePlayer}\'s turn',
                    textStyle: GoogleFonts.balooDa2(
                      color: textColor,
                      fontSize: deviceWidth / 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

      case 'playerChoice':
        {
          if (widget.userData.name == widget.gameData.activePlayer) {
            return AlertDialog(
              insetPadding:
                  EdgeInsets.only(top: 5, bottom: 20, left: 0, right: 0),
              backgroundColor: formColor,
              elevation: 10.0,
              title: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Round ${widget.gameData.currentRound} / ${widget.gameData.totalRounds}",
                    textStyle: GoogleFonts.balooDa2(
                      color: buttonIdleColor,
                      fontSize: deviceWidth / 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                child: Column(
                  children: [
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Who do you want to attack?',
                          textStyle: GoogleFonts.balooDa2(
                            color: textColor,
                            fontSize: deviceWidth / 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
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
                            return Column(
                              children: [
                                TextButton.icon(
                                  icon: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(playerData[0].imagePath),
                                    radius: deviceWidth / 16,
                                  ),
                                  label: Text(
                                    playerData[0].name,
                                    style: GoogleFonts.balooDa2(
                                      color: buttonActiveColor,
                                      fontSize: deviceWidth / 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () async {
                                    DatabaseService(
                                            gameid: widget.gameData.gameId)
                                        .updateCommand('attack',
                                            widget.gameData.activePlayer,
                                            attacked: playerData[0].name);
                                  },
                                ),
                                TextButton.icon(
                                  icon: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(playerData[1].imagePath),
                                    radius: deviceWidth / 16,
                                  ),
                                  label: Text(
                                    playerData[1].name,
                                    style: GoogleFonts.balooDa2(
                                      color: buttonActiveColor,
                                      fontSize: deviceWidth / 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
            );
          } else {
            return AlertDialog(
              backgroundColor: formColor,
              elevation: 10.0,
              title: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Round ${widget.gameData.currentRound} / ${widget.gameData.totalRounds}",
                    textStyle: GoogleFonts.balooDa2(
                      color: buttonIdleColor,
                      fontSize: deviceWidth / 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                child: Column(
                  children: [
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Wait for ${widget.gameData.activePlayer} to make their choice...',
                          textStyle: GoogleFonts.balooDa2(
                            color: textColor,
                            fontSize: deviceWidth / 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
        break;

      case 'attack':
        {
          return AlertDialog(
            backgroundColor: formColor,
            elevation: 10.0,
            title: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  "Round ${widget.gameData.currentRound} / ${widget.gameData.totalRounds}",
                  textStyle: GoogleFonts.balooDa2(
                    color: buttonIdleColor,
                    fontSize: deviceWidth / 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              child: Column(
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        '${widget.gameData.activePlayer} is attacking ${widget.gameData.attackedPlayer}',
                        textStyle: GoogleFonts.balooDa2(
                          color: textColor,
                          fontSize: deviceWidth / 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
            backgroundColor: formColor,
            elevation: 10.0,
            title: Text(
              'So this happened:',
              style: GoogleFonts.balooDa2(
                color: buttonIdleColor,
                fontSize: deviceWidth / 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText(
                  widget.gameData.activeUpdate,
                  speed: Duration(milliseconds: 100),
                  textStyle: GoogleFonts.balooDa2(
                    color: textColor,
                    fontSize: deviceWidth / 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                WavyAnimatedText(
                  widget.gameData.attackedUpdate,
                  speed: Duration(milliseconds: 100),
                  textStyle: GoogleFonts.balooDa2(
                    color: textColor,
                    fontSize: deviceWidth / 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        }
        break;

      default:
        {
          return AlertDialog(
            backgroundColor: formColor,
            elevation: 10.0,
            title: Text(
              widget.gameData.command,
              style: GoogleFonts.balooDa2(
                color: buttonIdleColor,
                fontSize: deviceWidth / 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText(
                  "Work going on behind the scenes...",
                  textStyle: GoogleFonts.balooDa2(
                    color: textColor,
                    fontSize: deviceWidth / 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
          );
        }
    }
  }
}
