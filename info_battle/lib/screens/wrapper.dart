//@dart=2.9
import 'package:flutter/material.dart';
import 'package:info_battle/models/app_user.dart';
import 'package:info_battle/screens/authenticate/authenticate.dart';
import 'package:info_battle/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    if (user == null) {
      return Authenticate();
      print("HI");
    } else {
      return Home();
      print("hi");
    }
  }
}
