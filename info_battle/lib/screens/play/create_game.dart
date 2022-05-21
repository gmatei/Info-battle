//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:info_battle/models/questionset.dart';
import 'package:info_battle/screens/game/game_manager.dart';
import 'package:info_battle/screens/play/question_selector.dart';
import 'dart:math';

import 'package:info_battle/utils/loading.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../models/game_data.dart';
import '../../models/user_data.dart';
import '../../services/database.dart';

class CreateGame extends StatefulWidget {
  CreateGame({Key key}) : super(key: key);

  List<QuestionSet> listOfQSets;

  callBack(List<QuestionSet> listFromChild) {
    listOfQSets = listFromChild;
  }

  @override
  State<CreateGame> createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  bool _createGameOn = false;
  String inviteCode = generateInviteCode();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).profile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            if (_createGameOn == true) {
              return StreamBuilder<GameData>(
                  stream: DatabaseService(uid: user.uid, gameid: inviteCode)
                      .currentGame,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      GameData gameData = snapshot.data;
                      if (gameData.nrConnectedUsers == 3) {
                        Future.delayed(Duration.zero, () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  GameManager(userData, gameData)));
                        });
                        return Container();
                      } else {
                        return Scaffold(
                            appBar: AppBar(
                              backgroundColor: Colors.brown[400],
                              title: Text('Create a new game'),
                              elevation: 10.0,
                            ),
                            body: Center(
                                child: Column(children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(25),
                                child: ElevatedButton(
                                  child: Text(
                                    'Select Question Set',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(25),
                                child: Text(
                                  'Invite code: $inviteCode',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(25),
                                child: ElevatedButton(
                                  child: Text(
                                    'Create game',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  onPressed: () async {},
                                ),
                              ),
                              _createGameOn
                                  ? Container(
                                      margin: EdgeInsets.all(25),
                                      child: Text(
                                        'Wait for players to connect... (${gameData.nrConnectedUsers} / 3)',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    )
                                  : Container(),
                              gameData.nrConnectedUsers != 3 && _createGameOn
                                  ? Container(
                                      color: Color.fromARGB(0, 215, 204, 200),
                                      child: Center(
                                        child: SpinKitChasingDots(
                                          color:
                                              Color.fromARGB(255, 121, 85, 72),
                                          size: 50.0,
                                        ),
                                      ),
                                    )
                                  : Container()
                            ])));
                      }
                    } else {
                      return Loading();
                    }
                  });
            } else {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.brown[400],
                    title: Text('Create a new game'),
                    elevation: 10.0,
                  ),
                  body: Center(
                      child: Column(children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(25),
                      child: ElevatedButton(
                        child: Text(
                          'Select Question Set',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          if (widget.listOfQSets != null) {
                            widget.listOfQSets.clear();
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    QuestionSelector(widget.callBack)),
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(25),
                      child: Text(
                        'Invite code: $inviteCode',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(25),
                      child: ElevatedButton(
                        child: Text(
                          'Create game',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () async {
                          if (widget.listOfQSets != null) {
                            setState(() {
                              _createGameOn = true;
                            });
                            await DatabaseService()
                                .createGame(user.uid, inviteCode);
                            await DatabaseService(gameid: inviteCode)
                                .addPlayer(userData, inviteCode);
                            await DatabaseService(gameid: inviteCode)
                                .addQuestionsToGame(widget.listOfQSets);
                          }
                        },
                      ),
                    ),
                  ])));
            }
          } else {
            return Loading();
          }
        });
  }
}

String generateInviteCode() {
  final random = Random();
  const availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final randomString = List.generate(
          6, (index) => availableChars[random.nextInt(availableChars.length)])
      .join();

  return randomString;
}
