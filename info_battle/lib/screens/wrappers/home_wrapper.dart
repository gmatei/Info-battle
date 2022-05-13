import 'package:flutter/material.dart';
import 'package:info_battle/screens/home/home.dart';
import 'package:info_battle/screens/profile/profile.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  bool showProfile = false;
  void toggleViewProfile() {
    setState(() => showProfile = !showProfile);
  }

  @override
  Widget build(BuildContext context) {
    if (showProfile) {
      return Profile(toggleView: toggleViewProfile);
    } else {
      return Home(toggleView: toggleViewProfile);
    }
  }
}
