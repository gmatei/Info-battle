//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/models/game_player.dart';
import 'package:info_battle/models/user_data.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget(this.gameData, {Key key, this.player}) : super(key: key);

  final PlayerData player;
  final GameData gameData;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 9.0, 0.0, 9.0),
        child: Row(
          children: [
            Flexible(
              child: ListTile(
                  title: Text(player.name),
                  subtitle: player.name == gameData.player1
                      ? Text("Score: ${gameData.player1Score}")
                      : player.name == gameData.player2
                          ? Text("Score: ${gameData.player2Score}")
                          : player.name == gameData.player3
                              ? Text("Score: ${gameData.player3Score}")
                              : 0,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(player.imagePath),
                  )),
            ),
          ],
        ));
  }
}
