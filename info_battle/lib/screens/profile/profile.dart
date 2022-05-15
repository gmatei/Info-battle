//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:info_battle/models/app_user.dart';
import 'package:info_battle/models/user_data.dart';
import 'package:info_battle/screens/profile/edit_profile.dart';
import 'package:info_battle/services/database.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:provider/provider.dart';
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
              backgroundColor: Colors.brown[50],
              appBar: AppBar(
                title: Row(
                  children: <Widget>[
                    TextButton.icon(
                      icon: Icon(
                        Icons.home_rounded,
                        size: 40.0,
                      ),
                      label: Text(
                        'Home',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        widget.toggleView();
                      },
                    ),
                  ],
                ),
                backgroundColor: Colors.brown[400],
                elevation: 0.0,
              ),
              body: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  ProfileWidget(
                    imagePath: userData.imagePath,
                    onClicked: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EditProfile()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  buildName(userData),
                ],
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        const SizedBox(height: 4),
        Text(
          userData.email,
          style: TextStyle(color: Colors.grey, fontSize: 17),
        )
      ],
    );
