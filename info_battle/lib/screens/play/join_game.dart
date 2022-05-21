//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/screens/game/game_manager.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../models/user_data.dart';
import '../../services/database.dart';

class JoinGame extends StatefulWidget {
  const JoinGame({Key key}) : super(key: key);

  @override
  State<JoinGame> createState() => _JoinGameState();
}

class _JoinGameState extends State<JoinGame> {
  final _formKey = GlobalKey<FormState>();
  bool _joinedGame = false;
  String _currentCode;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).profile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            if (_joinedGame == true) {
              return StreamBuilder<GameData>(
                  stream: DatabaseService(uid: user.uid, gameid: _currentCode)
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
                              title: Text('Join a game'),
                              elevation: 10.0,
                            ),
                            body: Form(
                              key: _formKey,
                              child: ListView(
                                padding: EdgeInsets.symmetric(horizontal: 32),
                                physics: BouncingScrollPhysics(),
                                children: [
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.all(25),
                                      child: Text(
                                        'Enter code:',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    initialValue: null,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    )),
                                    validator: (val) => val.length != 6
                                        ? 'Please enter a 6 character code'
                                        : null,
                                    onChanged: (val) => setState(
                                        () => _currentCode = val.trim()),
                                  ),
                                  SizedBox(height: 20.0),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue),
                                      ),
                                      child: Text(
                                        'Join Game',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {}),
                                  _joinedGame
                                      ? Container(
                                          margin: EdgeInsets.all(25),
                                          child: Text(
                                            'Wait for players to connect... (${gameData.nrConnectedUsers} / 3)',
                                            style: TextStyle(fontSize: 20.0),
                                          ),
                                        )
                                      : Container(),
                                  gameData.nrConnectedUsers != 3 && _joinedGame
                                      ? Container(
                                          color:
                                              Color.fromARGB(0, 215, 204, 200),
                                          child: Center(
                                            child: SpinKitChasingDots(
                                              color: Color.fromARGB(
                                                  255, 121, 85, 72),
                                              size: 50.0,
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ));
                      }
                    } else {
                      return Loading();
                    }
                  });
            } else {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.brown[400],
                    title: Text('Join a game'),
                    elevation: 10.0,
                  ),
                  body: Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      physics: BouncingScrollPhysics(),
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.all(25),
                            child: Text(
                              'Enter code:',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ),
                        TextFormField(
                          initialValue: null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                          validator: (val) => val.length != 6
                              ? 'Please enter a 6 character code'
                              : null,
                          onChanged: (val) =>
                              setState(() => _currentCode = val.trim()),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            child: Text(
                              'Join Game',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                try {
                                  await DatabaseService(gameid: _currentCode)
                                      .addPlayer(userData, _currentCode);
                                  setState(() {
                                    _joinedGame = true;
                                  });
                                } catch (e) {
                                  _joinedGame = false;
                                }
                              }
                            }),
                        _joinedGame
                            ? Container(
                                color: Color.fromARGB(0, 215, 204, 200),
                                child: Center(
                                  child: SpinKitChasingDots(
                                    color: Color.fromARGB(255, 121, 85, 72),
                                    size: 50.0,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ));
            }
          } else {
            return Loading();
          }
        });
  }
}
