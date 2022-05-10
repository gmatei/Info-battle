// ignore_for_file: prefer_const_constructors
// @dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:info_battle/models/app_user.dart';
import 'package:info_battle/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:info_battle/services/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("firebase initialized");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      value: AuthService().user,
      initialData: AppUser(uid: "none"),
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
