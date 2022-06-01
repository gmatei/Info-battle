// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

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
    'https://images.unsplash.com/photo-1624811072711-3e3481f355fd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=303&q=80');

var gameImage = const NetworkImage(
    'https://images.unsplash.com/photo-1601498940341-16572ea1ab83?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=415&q=80');

var createImage = const NetworkImage(
    'https://images.unsplash.com/photo-1611329857530-61d261e393e0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80');
