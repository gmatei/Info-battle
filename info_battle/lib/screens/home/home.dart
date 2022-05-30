// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/screens/play/play.dart';
import 'package:info_battle/screens/profile/profile.dart';
import 'package:info_battle/screens/quiz_creator/quiz_creator.dart';
import 'package:info_battle/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:info_battle/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/constants.dart';

class Home extends StatefulWidget {
  final Function toggleView;
  const Home({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: buttonIdleColor,
          centerTitle: true,
          elevation: 10.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(
                  Icons.exit_to_app_rounded,
                  color: textColor,
                  size: deviceWidth / 14,
                ),
                label: Text(
                  'Sign Out',
                  style: GoogleFonts.balooDa2(
                      color: textColor,
                      fontSize: deviceWidth / 27,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
              Text(
                'Info Battle',
                style: GoogleFonts.balooDa2(
                  color: textColor,
                  fontSize: deviceWidth / 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                icon: Icon(
                  Icons.account_circle_rounded,
                  color: textColor,
                  size: deviceWidth / 14,
                ),
                label: Text(
                  'Profile',
                  style: GoogleFonts.balooDa2(
                      color: textColor,
                      fontSize: deviceWidth / 27,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  widget.toggleView();
                },
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(0, deviceHeight / 6, 0, 0),
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.fill,
              image: homeImage,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
                child: Column(children: <Widget>[
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
                    'Play',
                    style: GoogleFonts.balooDa2(
                        color: textColor,
                        fontSize: deviceWidth / 13,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PlayGame()),
                    );
                  },
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
                    minimumSize: Size(deviceWidth / 1.7, deviceHeight / 14),
                  ),
                  child: Text(
                    'Quiz Creator',
                    style: GoogleFonts.balooDa2(
                        color: textColor,
                        fontSize: deviceWidth / 13,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => QuizCreator()),
                    );
                  },
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
                    minimumSize: Size(deviceWidth / 1.7, deviceHeight / 14),
                  ),
                  child: Text(
                    'Exit',
                    style: GoogleFonts.balooDa2(
                        color: textColor,
                        fontSize: deviceWidth / 13,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ),
            ])),
          ),
        ));
  }
}
