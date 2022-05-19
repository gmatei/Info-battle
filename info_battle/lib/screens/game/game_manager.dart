//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class GameManager extends StatefulWidget {
  const GameManager(String uid, {Key key}) : super(key: key);

  @override
  State<GameManager> createState() => _GameManagerState();
}

class _GameManagerState extends State<GameManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text('Game'),
        elevation: 10.0,
      ),
    );
  }
}
