//@dart=2.9
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/models/game_player.dart';
import 'package:info_battle/models/user_data.dart';
import 'package:info_battle/screens/game/alert_dialog_manager.dart';
import 'package:info_battle/screens/game/player_widget.dart';
import 'package:info_battle/screens/game/question_screen.dart';
import 'package:info_battle/screens/profile/profile_widget.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:provider/provider.dart';

import '../../services/database.dart';
import 'command_manager.dart';
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
                if (gameData.command != 'question') {
                  return Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.brown[400],
                        title: Text('Game'),
                        elevation: 10.0,
                      ),
                      body: Column(
                        children: [
                          PlayerList(),
                          AlertDialogManager(gameData, widget.userData),
                          CommandManager(gameData),
                        ],
                      ));
                } else {
                  return Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.brown[400],
                        title: Text('Question'),
                        elevation: 10.0,
                      ),
                      body: QuestionScreen(gameData));
                }
              } else {
                return Loading();
              }
            }));
  }
}