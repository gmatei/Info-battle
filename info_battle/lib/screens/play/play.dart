// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/screens/play/create_game.dart';
import 'package:info_battle/screens/play/join_game.dart';

import '../../utils/constants.dart';

class PlayGame extends StatefulWidget {
  const PlayGame({Key? key}) : super(key: key);

  @override
  State<PlayGame> createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  @override
  Widget build(BuildContext context) {
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
            'Let\'s play!',
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
              image: playImage,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
                child: Column(children: <Widget>[
              SizedBox(height: deviceHeight / 5.3),
              Container(
                margin: EdgeInsets.all(deviceHeight / 34),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: buttonIdleColor,
                      onPrimary: buttonActiveColor,
                      shadowColor: buttonshadowColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minimumSize: Size(deviceWidth / 1.7, deviceHeight / 14),
                    ),
                    child: Text(
                      'Create Game',
                      style: GoogleFonts.balooDa2(
                          color: textColor,
                          fontSize: deviceWidth / 15,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CreateGame()),
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 32.0,
                    top: deviceHeight / 21,
                    right: 32.0,
                    bottom: deviceHeight / 35),
                child: Text(
                  'Design and create a new game according to your preferences, and then share the game code with your friends to play!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.balooDa2(
                    color: textColor,
                    fontSize: deviceWidth / 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: deviceHeight / 19),
              Divider(
                color: Color.fromARGB(255, 162, 129, 30),
                thickness: deviceHeight / 300,
              ),
              SizedBox(
                height: deviceHeight / 15,
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
                      minimumSize: Size(deviceWidth / 1.7, deviceHeight / 14),
                    ),
                    child: Text(
                      'Join Game',
                      style: GoogleFonts.balooDa2(
                          color: textColor,
                          fontSize: deviceWidth / 15,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => JoinGame()),
                      );
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 32.0, top: 32.0, right: 32.0),
                child: Text(
                  'Enter the code you received to play the game!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.balooDa2(
                    color: textColor,
                    fontSize: deviceWidth / 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ])),
          ),
        ));
  }
}
