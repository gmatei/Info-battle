// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/models/game_player.dart';
import 'package:provider/provider.dart';

import 'player_widget.dart';

class PlayerList extends StatefulWidget {
  const PlayerList(this.gameData, {Key? key}) : super(key: key);

  final GameData gameData;

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
        return PlayerWidget(widget.gameData, player: players[index]);
      },
    );
  }
}
