// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:info_battle/utils/constants.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: buttonIdleColor,
      child: Center(
        child: SpinKitCircle(
          color: buttonActiveColor,
          size: deviceHeight / 10,
        ),
      ),
    );
  }
}
