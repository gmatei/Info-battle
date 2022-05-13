// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:info_battle/screens/profile/profile.dart';
import 'package:info_battle/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:info_battle/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.exit_to_app_rounded),
              label: Text('signOut'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            Text('Info Battle'),
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('Profile'),
              onPressed: () {
                widget.toggleView();
              },
            ),
          ],
        ),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
    );
  }
}
