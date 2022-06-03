//@dart=2.9
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_call_super

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/models/game_player.dart';
import 'package:info_battle/models/user_data.dart';
import 'package:info_battle/screens/game/alert_dialog_manager.dart';
import 'package:info_battle/screens/game/question_screen.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:provider/provider.dart';

import '../../services/database.dart';
import '../../utils/constants.dart';
import 'command_manager.dart';
import 'game_over.dart';
import 'player_list.dart';

class GameManager extends StatefulWidget {
  const GameManager(this.userData, this.gameData, {Key key}) : super(key: key);
  final UserData userData;
  final GameData gameData;
  @override
  State<GameManager> createState() => _GameManagerState();
}

class _GameManagerState extends State<GameManager> {
  String _gameCode;
  String command = 'init';

  @override
  void initState() {
    _gameCode = widget.gameData.gameId;
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PlayerData>>.value(
        value: DatabaseService(gameid: _gameCode).gamePlayers,
        initialData: const [],
        child: StreamBuilder<GameData>(
            stream: DatabaseService(gameid: _gameCode).currentGame,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                GameData gameData = snapshot.data;
                if (gameData.currentRound <= gameData.totalRounds) {
                  return Scaffold(
                      resizeToAvoidBottomInset: false,
                      extendBodyBehindAppBar: true,
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: buttonIdleColor,
                        elevation: 10.0,
                        iconTheme: IconThemeData(
                          color: textColor,
                        ),
                        title: Center(
                          child: Text(
                            'Info Battle',
                            style: GoogleFonts.balooDa2(
                              color: textColor,
                              fontSize: deviceWidth / 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      body: Container(
                        width: deviceWidth,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.topCenter,
                            fit: BoxFit.fill,
                            image: gameImage,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Column(
                            children: [
                              SizedBox(
                                height: deviceHeight / 8,
                              ),
                              gameData.command != 'question' &&
                                      gameData.command != 'showAnswer'
                                  ? PlayerList(gameData)
                                  : SizedBox(width: 0.0, height: 0.0),
                              gameData.command != 'question' &&
                                      gameData.command != 'showAnswer'
                                  ? AlertDialogManager(
                                      gameData, widget.userData)
                                  : SizedBox(width: 0.0, height: 0.0),
                              gameData.command == 'question' ||
                                      gameData.command == 'showAnswer'
                                  ? QuestionScreen(gameData, widget.userData)
                                  : SizedBox(
                                      width: 0.0,
                                      height: 0.0,
                                    ),
                              widget.gameData.activePlayer ==
                                          widget.userData.name ||
                                      widget.gameData.command == 'init'
                                  ? CommandManager(widget.userData, gameData)
                                  : SizedBox(width: 0.0, height: 0.0),
                            ],
                          ),
                        ),
                      ));
                } else {
                  return GameOver(gameData);
                }
              } else {
                return Loading();
              }
            }));
  }
}
