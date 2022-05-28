// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/screens/wrappers/home_wrapper.dart';

class GameOver extends StatefulWidget {
  const GameOver(this.gameData, {Key? key}) : super(key: key);

  final GameData gameData;

  @override
  State<GameOver> createState() => _GameOverState();
}

class Pair<T1, T2> {
  final T1 score;
  final T2 name;

  Pair(this.score, this.name);
}

class _GameOverState extends State<GameOver> {
  @override
  Widget build(BuildContext context) {
    var playerScores = [
      Pair(widget.gameData.player1Score, widget.gameData.player1),
      Pair(widget.gameData.player2Score, widget.gameData.player2),
      Pair(widget.gameData.player3Score, widget.gameData.player3)
    ]..sort((b, a) => a.score.compareTo(b.score));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown[400],
        title: Text('Game Over'),
        elevation: 10.0,
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 32),
            physics: BouncingScrollPhysics(),
            itemCount: playerScores.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 9.0, 0.0, 9.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: ListTile(
                          title: Text(playerScores[index].name),
                          subtitle: Text("Score: ${playerScores[index].score}"),
                        ),
                      ),
                    ],
                  ));
            },
          ),
          SizedBox(
            height: 80.0,
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: ElevatedButton(
              child: Text(
                'Return Home',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () async {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomeWrapper()),
                    (route) => false);
              },
            ),
          ),
        ],
      ),
    );
  }
}
