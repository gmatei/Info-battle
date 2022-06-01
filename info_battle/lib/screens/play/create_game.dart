//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
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
import '../../utils/constants.dart';
import 'counter.dart';

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
  bool _noQuestions = false;
  String inviteCode = generateInviteCode();
  int counter = 3;

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
                            resizeToAvoidBottomInset: false,
                            extendBodyBehindAppBar: true,
                            appBar: AppBar(
                              backgroundColor: buttonIdleColor,
                              elevation: 10.0,
                              iconTheme: IconThemeData(
                                color: textColor,
                              ),
                              title: Text(
                                'Create a new game',
                                style: GoogleFonts.balooDa2(
                                  color: textColor,
                                  fontSize: deviceWidth / 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            body: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.topCenter,
                                  fit: BoxFit.fill,
                                  image: createImage,
                                ),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Center(
                                    child: Column(children: <Widget>[
                                  SizedBox(
                                    height: deviceHeight / 7,
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(25),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: buttonIdleColor,
                                        onPrimary: buttonActiveColor,
                                        shadowColor: buttonshadowColor,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minimumSize: Size(deviceWidth / 1.7,
                                            deviceHeight / 14),
                                      ),
                                      child: Text(
                                        'Select Question Set',
                                        style: GoogleFonts.balooDa2(
                                            color: textColor,
                                            fontSize: deviceWidth / 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: deviceWidth / 5,
                                            right: deviceWidth / 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          color: formColor,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 16),
                                          child: Text(
                                            'Rounds: ',
                                            style: GoogleFonts.balooDa2(
                                                color: textColor,
                                                fontSize: deviceWidth / 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Counter(
                                        initialValue: counter,
                                        minValue: counter,
                                        maxValue: counter,
                                        decimalPlaces: 0,
                                        step: 0,
                                        color: buttonIdleColor,
                                        buttonSize: deviceWidth / 13,
                                        textStyle: GoogleFonts.balooDa2(
                                            color: buttonIdleColor,
                                            fontSize: deviceWidth / 15,
                                            fontWeight: FontWeight.bold),
                                        onChanged: (value) {},
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: formColor,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 16),
                                      child: Text(
                                        'Invite code: $inviteCode',
                                        style: GoogleFonts.balooDa2(
                                            color: textColor,
                                            fontSize: deviceWidth / 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(25),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: buttonIdleColor,
                                        onPrimary: buttonActiveColor,
                                        shadowColor: buttonshadowColor,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minimumSize: Size(deviceWidth / 1.7,
                                            deviceHeight / 14),
                                      ),
                                      child: Text(
                                        'Create Game',
                                        style: GoogleFonts.balooDa2(
                                            color: textColor,
                                            fontSize: deviceWidth / 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () async {},
                                    ),
                                  ),
                                  _createGameOn
                                      ? Container(
                                          margin: EdgeInsets.all(25),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            color: formColor,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 16),
                                            child: Text(
                                              'Wait for players to connect... (${gameData.nrConnectedUsers} / 3)',
                                              style: GoogleFonts.balooDa2(
                                                  color: textColor,
                                                  fontSize: deviceWidth / 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  gameData.nrConnectedUsers != 3 &&
                                          _createGameOn
                                      ? Container(
                                          color:
                                              Color.fromARGB(0, 215, 204, 200),
                                          child: Center(
                                            child: SpinKitCircle(
                                              color: buttonIdleColor,
                                              size: deviceWidth / 6,
                                            ),
                                          ),
                                        )
                                      : Container()
                                ])),
                              ),
                            ));
                      }
                    } else {
                      return Loading();
                    }
                  });
            } else {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    backgroundColor: buttonIdleColor,
                    elevation: 10.0,
                    iconTheme: IconThemeData(
                      color: textColor,
                    ),
                    title: Text(
                      'Create a new game',
                      style: GoogleFonts.balooDa2(
                        color: textColor,
                        fontSize: deviceWidth / 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  body: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fill,
                        image: createImage,
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Center(
                          child: Column(children: <Widget>[
                        SizedBox(
                          height: deviceHeight / 7,
                        ),
                        Container(
                          margin: EdgeInsets.all(25),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: buttonIdleColor,
                              onPrimary: buttonActiveColor,
                              shadowColor: buttonshadowColor,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              minimumSize:
                                  Size(deviceWidth / 1.7, deviceHeight / 14),
                            ),
                            child: Text(
                              'Select Question Set',
                              style: GoogleFonts.balooDa2(
                                  color: textColor,
                                  fontSize: deviceWidth / 15,
                                  fontWeight: FontWeight.bold),
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
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: deviceWidth / 5,
                                  right: deviceWidth / 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: formColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                child: Text(
                                  'Rounds: ',
                                  style: GoogleFonts.balooDa2(
                                      color: textColor,
                                      fontSize: deviceWidth / 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Counter(
                              initialValue: counter,
                              minValue: 1,
                              maxValue: 10,
                              decimalPlaces: 0,
                              step: 1,
                              color: buttonIdleColor,
                              buttonSize: deviceWidth / 13,
                              textStyle: GoogleFonts.balooDa2(
                                  color: buttonIdleColor,
                                  fontSize: deviceWidth / 15,
                                  fontWeight: FontWeight.bold),
                              onChanged: (value) {
                                setState(() {
                                  counter = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: formColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                            child: Text(
                              'Invite code: $inviteCode',
                              style: GoogleFonts.balooDa2(
                                  color: textColor,
                                  fontSize: deviceWidth / 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(25),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: buttonIdleColor,
                              onPrimary: buttonActiveColor,
                              shadowColor: buttonshadowColor,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              minimumSize:
                                  Size(deviceWidth / 1.7, deviceHeight / 14),
                            ),
                            child: Text(
                              'Create Game',
                              style: GoogleFonts.balooDa2(
                                  color: textColor,
                                  fontSize: deviceWidth / 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              if (widget.listOfQSets != null) {
                                setState(() {
                                  _createGameOn = true;
                                });
                                await DatabaseService()
                                    .createGame(user.uid, inviteCode, counter);
                                await DatabaseService(gameid: inviteCode)
                                    .addPlayer(userData, inviteCode);
                                await DatabaseService(gameid: inviteCode)
                                    .addQuestionsToGame(widget.listOfQSets);
                              } else {
                                setState(() {
                                  _noQuestions = true;
                                });
                              }
                            },
                          ),
                        ),
                        _noQuestions
                            ? Container(
                                margin: EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: formColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 16),
                                  child: Text(
                                    'Select at least one set of questions!',
                                    style: GoogleFonts.balooDa2(
                                        color: textColor,
                                        fontSize: deviceWidth / 21,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 0.0,
                                width: 0.0,
                              ),
                      ])),
                    ),
                  ));
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
