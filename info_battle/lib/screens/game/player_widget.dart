//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:info_battle/models/game_player.dart';
import 'package:info_battle/models/user_data.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({Key key, this.player}) : super(key: key);

  final PlayerData player;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 9.0, 0.0, 9.0),
        child: Row(
          children: [
            Flexible(
              child: ListTile(
                  title: Text(player.name),
                  subtitle: Text('score 1000'),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(player.imagePath),
                  )),
            ),
          ],
        ));
  }
}
