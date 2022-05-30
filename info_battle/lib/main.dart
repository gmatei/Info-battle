// ignore_for_file: prefer_const_constructors, missing_required_param
// @dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:info_battle/models/app_user.dart';
import 'package:info_battle/models/user_data.dart';
import 'package:info_battle/screens/wrappers/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:info_battle/services/auth.dart';
import 'package:info_battle/services/database.dart';
import 'package:info_battle/utils/constants.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<AppUser>.value(value: AuthService().user),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          errorColor: errorColor,
        ),
        home: Wrapper(),
      ),
    );
  }
}
