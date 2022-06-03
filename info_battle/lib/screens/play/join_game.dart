//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/screens/game/game_manager.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../models/user_data.dart';
import '../../services/database.dart';
import '../../utils/constants.dart';

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
                            resizeToAvoidBottomInset: false,
                            extendBodyBehindAppBar: true,
                            appBar: AppBar(
                              backgroundColor: buttonIdleColor,
                              elevation: 10.0,
                              iconTheme: IconThemeData(
                                color: textColor,
                              ),
                              title: Text(
                                'Join a game',
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
                                  image: gameImage,
                                ),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                child: Form(
                                  key: _formKey,
                                  child: ListView(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 32),
                                    physics: BouncingScrollPhysics(),
                                    children: [
                                      SizedBox(
                                        height: deviceHeight / 5,
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 16),
                                          child: Text(
                                            'Enter code:',
                                            style: GoogleFonts.balooDa2(
                                                color: textColor,
                                                fontSize: deviceWidth / 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        style: GoogleFonts.balooDa2(
                                            color: textColor,
                                            fontSize: deviceHeight / 30,
                                            fontWeight: FontWeight.bold),
                                        initialValue: null,
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: deviceHeight / 65,
                                            ),
                                            filled: true,
                                            fillColor: formColor,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              borderSide: BorderSide(
                                                color: buttonActiveColor,
                                                width: 4.0,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              borderSide: BorderSide(
                                                color: buttonIdleColor,
                                                width: 4.0,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                      ),
                                      SizedBox(height: 20.0),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: buttonIdleColor,
                                            onPrimary: buttonActiveColor,
                                            shadowColor: buttonshadowColor,
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            minimumSize: Size(deviceWidth / 1.7,
                                                deviceHeight / 14),
                                          ),
                                          child: Text(
                                            'Join Game',
                                            style: GoogleFonts.balooDa2(
                                                color: textColor,
                                                fontSize: deviceWidth / 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () async {}),
                                      _joinedGame
                                          ? Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 25,
                                                  horizontal: deviceWidth / 20),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                color: formColor,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 16),
                                                child: Text(
                                                  'Wait for players to connect... (${gameData.nrConnectedUsers} / 3)',
                                                  style: GoogleFonts.balooDa2(
                                                      color: textColor,
                                                      fontSize:
                                                          deviceWidth / 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      gameData.nrConnectedUsers != 3 &&
                                              _joinedGame
                                          ? Container(
                                              color: Color.fromARGB(
                                                  0, 215, 204, 200),
                                              child: Center(
                                                child: SpinKitCircle(
                                                  color: buttonIdleColor,
                                                  size: deviceWidth / 6,
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
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
                      'Join a game',
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
                        image: gameImage,
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          physics: BouncingScrollPhysics(),
                          children: [
                            SizedBox(
                              height: deviceHeight / 5,
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                child: Text(
                                  'Enter code:',
                                  style: GoogleFonts.balooDa2(
                                      color: textColor,
                                      fontSize: deviceWidth / 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TextFormField(
                              style: GoogleFonts.balooDa2(
                                  color: textColor,
                                  fontSize: deviceHeight / 30,
                                  fontWeight: FontWeight.bold),
                              initialValue: null,
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceHeight / 65,
                                  ),
                                  filled: true,
                                  fillColor: formColor,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: buttonActiveColor,
                                      width: 4.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: buttonIdleColor,
                                      width: 4.0,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              validator: (val) => val.length != 6
                                  ? 'Please enter a 6 character code'
                                  : null,
                              onChanged: (val) =>
                                  setState(() => _currentCode = val.trim()),
                            ),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: buttonIdleColor,
                                  onPrimary: buttonActiveColor,
                                  shadowColor: buttonshadowColor,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  minimumSize: Size(
                                      deviceWidth / 1.7, deviceHeight / 14),
                                ),
                                child: Text(
                                  'Join Game',
                                  style: GoogleFonts.balooDa2(
                                      color: textColor,
                                      fontSize: deviceWidth / 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    try {
                                      await DatabaseService(
                                              gameid: _currentCode)
                                          .addPlayer(userData, _currentCode);
                                      setState(() {
                                        _joinedGame = true;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        _joinedGame = true;
                                      });
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
                                : SizedBox(
                                    width: 0.0,
                                    height: 0.0,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ));
            }
          } else {
            return Loading();
          }
        });
  }
}
