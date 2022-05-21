import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AlertDialogManager extends StatefulWidget {
  const AlertDialogManager(this.command, {Key? key}) : super(key: key);

  final String command;
  @override
  State<AlertDialogManager> createState() => _AlertDialogManagerState();
}

class _AlertDialogManagerState extends State<AlertDialogManager> {
  @override
  Widget build(BuildContext context) {
    switch (widget.command) {
      case 'init':
        {
          return AlertDialog(
            title: Text("Info Battle started"),
            content: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText("Wait for everyone to connect...")
              ],
            ),
            actions: [],
          );
        }

      default:
        {
          return AlertDialog(
            title: Text("Wait a second"),
            content: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText("Work going on behind the scenes...")
              ],
            ),
            actions: [],
          );
        }
    }
  }
}
