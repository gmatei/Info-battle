// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:info_battle/models/game_player.dart';
import 'package:info_battle/models/user_data.dart';
import 'package:provider/provider.dart';

import 'player_widget.dart';

class PlayerList extends StatefulWidget {
  const PlayerList({Key? key}) : super(key: key);

  @override
  State<PlayerList> createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  @override
  Widget build(BuildContext context) {
    final players = Provider.of<List<PlayerData>>(context);
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 32),
      physics: BouncingScrollPhysics(),
      itemCount: players.length,
      itemBuilder: (context, index) {
        return PlayerWidget(player: players[index]);
      },
    );
  }
}
