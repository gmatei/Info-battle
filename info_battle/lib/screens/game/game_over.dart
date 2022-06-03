// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe
//@dart=2.9
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/screens/wrappers/home_wrapper.dart';
import 'package:info_battle/utils/loading.dart';

import '../../models/game_player.dart';
import '../../services/database.dart';
import '../../utils/constants.dart';

class GameOver extends StatefulWidget {
  const GameOver(this.gameData, {Key key}) : super(key: key);

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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: buttonIdleColor,
        elevation: 10.0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Game Over',
            style: GoogleFonts.balooDa2(
              color: textColor,
              fontSize: deviceWidth / 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            fit: BoxFit.fill,
            image: gameImage,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Column(
            children: [
              SizedBox(
                height: deviceHeight / 8,
              ),
              StreamBuilder<List<PlayerData>>(
                  stream: DatabaseService(gameid: widget.gameData.gameId)
                      .gamePlayers,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<PlayerData> playerList = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        physics: BouncingScrollPhysics(),
                        itemCount: playerScores.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 9.0, 0.0, 9.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: index == 0
                                                ? Color.fromARGB(
                                                    255, 223, 217, 38)
                                                : index == 1
                                                    ? Color.fromARGB(
                                                        255, 165, 165, 165)
                                                    : Color.fromARGB(
                                                        255, 131, 53, 24),
                                            width: index == 0
                                                ? 7
                                                : index == 1
                                                    ? 5
                                                    : 3),
                                        borderRadius: BorderRadius.circular(25),
                                        color: formColor,
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          playerScores[index].name,
                                          style: GoogleFonts.balooDa2(
                                            color: textColor,
                                            fontSize: deviceWidth / 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "Score: ${playerScores[index].score}",
                                          style: GoogleFonts.balooDa2(
                                            color: buttonIdleColor,
                                            fontSize: deviceWidth / 19,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              playerList
                                                  .firstWhere((element) =>
                                                      element.name ==
                                                      playerScores[index].name)
                                                  .imagePath),
                                          radius: deviceWidth / 12,
                                        ),
                                        trailing: CircleAvatar(
                                          backgroundColor: formColor,
                                          backgroundImage: index == 0
                                              ? medalImageGold
                                              : index == 1
                                                  ? medalImageSilver
                                                  : medalImageBronze,
                                          radius: deviceWidth / 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                        },
                      );
                    } else {
                      return Loading();
                    }
                  }),
              SizedBox(
                height: 80.0,
              ),
              Container(
                margin: EdgeInsets.all(25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: buttonIdleColor,
                    onPrimary: buttonActiveColor,
                    shadowColor: buttonshadowColor,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minimumSize: Size(deviceWidth / 1.7, deviceHeight / 14),
                  ),
                  child: Text(
                    'Return Home',
                    style: GoogleFonts.balooDa2(
                        color: textColor,
                        fontSize: deviceWidth / 15,
                        fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }
}
