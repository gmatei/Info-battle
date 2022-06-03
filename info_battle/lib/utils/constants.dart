// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:info_battle/models/user_data.dart';

InputDecoration textInputDecoration = InputDecoration(
  fillColor: Color.fromARGB(135, 255, 255, 255),
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 75, 23, 23), width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 146, 7, 7), width: 3.0),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
  ),
);

const Color buttonIdleColor = Color.fromARGB(255, 84, 27, 27);
const Color buttonActiveColor = Color.fromARGB(255, 234, 83, 28);
const Color buttonshadowColor = Color.fromARGB(255, 255, 140, 46);
const Color textColor = Color.fromARGB(255, 149, 225, 255);
const Color transparentColor = Colors.transparent;
const Color formColor = Color.fromARGB(172, 179, 93, 56);
const Color errorColor = Color.fromARGB(255, 46, 67, 255);

double deviceWidth =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
double deviceHeight =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

var backgroundImage = const NetworkImage(
  'https://firebasestorage.googleapis.com/v0/b/info-battle.appspot.com/o/images%2FLoginback.jpg?alt=media&token=8554ca05-3129-49e5-b26a-65b6fe4f2faf',
);

var homeImage = const NetworkImage(
    'https://firebasestorage.googleapis.com/v0/b/info-battle.appspot.com/o/images%2FhomePageImg.jpg?alt=media&token=1630e985-2746-42ca-acc6-cff7226bb1b7');

var questionImage = const NetworkImage(
    'https://firebasestorage.googleapis.com/v0/b/info-battle.appspot.com/o/images%2Fquestion_back.jpg?alt=media&token=d178267b-cf09-4f04-856e-c545e3b75719');

var playImage = const NetworkImage(
    'https://firebasestorage.googleapis.com/v0/b/info-battle.appspot.com/o/images%2FplayImage.jpg?alt=media&token=b5e97838-7c8d-42e2-9f00-863f99d2a436');

var gameImage = const NetworkImage(
    'https://firebasestorage.googleapis.com/v0/b/info-battle.appspot.com/o/images%2FgameImage.jpg?alt=media&token=bf49ce91-4b4f-4e6c-80f2-6c447a124f83');

var createImage = const NetworkImage(
    'https://firebasestorage.googleapis.com/v0/b/info-battle.appspot.com/o/images%2FcreateImage.jpg?alt=media&token=eb01564a-903e-4bce-9ce4-71a44530a952');

var medalImageGold = const NetworkImage(
    'https://firebasestorage.googleapis.com/v0/b/info-battle.appspot.com/o/images%2FgoldMedal.png?alt=media&token=78ce7a7f-f38d-4edc-a330-73faa33bb737');

var medalImageSilver = const NetworkImage(
    'https://firebasestorage.googleapis.com/v0/b/info-battle.appspot.com/o/images%2FsilverMedal.png?alt=media&token=ee63fc6c-c782-4f9b-a755-829bbcc43b26');

var medalImageBronze = const NetworkImage(
    'https://firebasestorage.googleapis.com/v0/b/info-battle.appspot.com/o/images%2FbronzeMedal.png?alt=media&token=ed9ac892-f86e-4bbf-86a2-d2dc6df067ee');

String defaultPlayerPic =
    'https://firebasestorage.googleapis.com/v0/b/info-battle.appspot.com/o/images%2Fdefault.png?alt=media&token=3ad928ef-cd0c-47fe-a808-25f2ec0c2ced';

UserData botMike = UserData(
  uid: '4tlHxmm29112021CAIdZsV5o3h18',
  name: 'Bot Mike',
  email: 'mikebot@mikebot.com',
  imagePath: defaultPlayerPic,
);

UserData botJohn = UserData(
  uid: 'RtlvxMm09032001QAleZsV5O3a13',
  name: 'Bot John',
  email: 'johnbot@mikebot.com',
  imagePath: defaultPlayerPic,
);
