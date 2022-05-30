//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/models/app_user.dart';
import 'package:info_battle/models/user_data.dart';
import 'package:info_battle/screens/profile/edit_profile.dart';
import 'package:info_battle/services/database.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import 'profile_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  final Function toggleView;
  const Profile({Key key, this.toggleView}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).profile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 10.0,
                backgroundColor: buttonIdleColor,
                title: Row(
                  children: <Widget>[
                    TextButton.icon(
                      icon: Icon(
                        Icons.home_rounded,
                        color: textColor,
                        size: deviceWidth / 12,
                      ),
                      label: Text(
                        'Home',
                        style: GoogleFonts.balooDa2(
                          color: textColor,
                          fontSize: deviceWidth / 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        widget.toggleView();
                      },
                    ),
                  ],
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fill,
                    image: homeImage,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      ProfileWidget(
                        imagePath: userData.imagePath,
                        onClicked: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => EditProfile()),
                          );
                        },
                      ),
                      SizedBox(height: deviceHeight / 35),
                      buildName(userData),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}

Widget buildName(userData) => Column(
      children: [
        Text(
          userData.name,
          style: GoogleFonts.balooDa2(
              fontWeight: FontWeight.bold,
              fontSize: deviceWidth / 13,
              color: textColor),
        ),
        SizedBox(
          height: deviceHeight / 200,
        ),
        Text(
          userData.email,
          style: GoogleFonts.balooDa2(
              color: Color.fromARGB(255, 170, 194, 200),
              fontSize: 17,
              fontStyle: FontStyle.italic),
        )
      ],
    );
