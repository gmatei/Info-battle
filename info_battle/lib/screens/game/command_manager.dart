//@dart=2.9
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/services/database.dart';
import 'package:info_battle/utils/loading.dart';

import '../../models/user_data.dart';

class CommandManager extends StatefulWidget {
  const CommandManager(this.userData, this.gameData, {Key key})
      : super(key: key);

  final GameData gameData;
  final UserData userData;
  @override
  State<CommandManager> createState() => _CommandManagerState();
}

class _CommandManagerState extends State<CommandManager> {
  bool questionSelected = false;
  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService =
        DatabaseService(gameid: widget.gameData.gameId);

    switch (widget.gameData.command) {
      case "init":
        {
          databaseService.updateCommand('round', 'player1');
        }
        break;
      case "round":
        {
          databaseService.updateCommand('playerChoice', 'player1');
        }
        break;
      case "playerChoice":
        {
          if (widget.gameData.activePlayer == widget.userData.name &&
              questionSelected == false) {
            databaseService.updateQuestion();
            setState(() {
              questionSelected = true;
            });
          }
        }
        break;
      case "attack":
        {
          setState(() {
            questionSelected = false;
          });
          databaseService.updateCommand('question', 'player1',
              attacked: 'none');
        }
        break;
      default:
        {}
        break;
    }
    return SizedBox(width: 0.0, height: 0.0);
  }
}
