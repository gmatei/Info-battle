//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/models/game_player.dart';

import '../../utils/constants.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget(this.gameData, {Key key, this.player}) : super(key: key);

  final PlayerData player;
  final GameData gameData;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            bottom: deviceHeight / 200, top: deviceHeight / 200),
        child: Row(
          children: [
            Flexible(
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(color: buttonIdleColor, width: 3),
                  borderRadius: BorderRadius.circular(25),
                  color: formColor,
                ),
                child: ListTile(
                    title: Padding(
                      padding: EdgeInsets.only(top: deviceHeight / 100),
                      child: Text(
                        player.name,
                        style: GoogleFonts.balooDa2(
                          color: textColor,
                          fontSize: deviceWidth / 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: player.name == gameData.player1
                        ? Text(
                            "Score: ${gameData.player1Score}",
                            style: GoogleFonts.balooDa2(
                              color: buttonIdleColor,
                              fontSize: deviceWidth / 21,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : player.name == gameData.player2
                            ? Text(
                                "Score: ${gameData.player2Score}",
                                style: GoogleFonts.balooDa2(
                                  color: buttonIdleColor,
                                  fontSize: deviceWidth / 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : player.name == gameData.player3
                                ? Text(
                                    "Score: ${gameData.player3Score}",
                                    style: GoogleFonts.balooDa2(
                                      color: buttonIdleColor,
                                      fontSize: deviceWidth / 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : 0,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(player.imagePath),
                      radius: deviceWidth / 12,
                    )),
              ),
            ),
          ],
        ));
  }
}
