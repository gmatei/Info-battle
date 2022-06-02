//@dart=2.9
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/cupertino.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/services/database.dart';

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
  bool questionUpdated = false;

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
          if (widget.gameData.activePlayer == widget.userData.name) {
            databaseService.updateCommand(
                'playerChoice', widget.gameData.activePlayer);
          }
        }
        break;
      case "playerChoice":
        {}
        break;
      case "attack":
        {
          if (widget.gameData.activePlayer == widget.userData.name &&
              widget.gameData.currentQuestion['qText'] == 'none') {
            databaseService.updateCommand(
                'question', widget.gameData.activePlayer,
                attacked: 'none');

            databaseService.updateQuestion();
          }
        }
        break;
      case "question":
        {
          if (widget.gameData.activePlayer == widget.userData.name)
            databaseService.updateCommand(
                'showAnswer', widget.gameData.activePlayer,
                attacked: 'none');
        }
        break;
      case "showAnswer":
        {
          if (widget.gameData.currentQuestion['qText'] != 'none') {
            if (widget.gameData.activePlayer == widget.userData.name) {
              databaseService.resetAnswers();
              databaseService.updateCommand(
                  'returnFromQuestion', widget.gameData.activePlayer,
                  attacked: 'none');
            }
          }
        }
        break;
      case "returnFromQuestion":
        {
          if (widget.gameData.activePlayer == widget.userData.name) {
            if (widget.gameData.activePlayer == widget.gameData.player1) {
              databaseService.updateCommand('playerChoice', 'player2',
                  attacked: 'none');
            } else if (widget.gameData.activePlayer ==
                widget.gameData.player2) {
              databaseService.updateCommand('playerChoice', 'player3',
                  attacked: 'none');
            } else if (widget.gameData.activePlayer ==
                widget.gameData.player3) {
              databaseService.updateCommand('round', 'player1');
            }
          }
        }
        break;
      default:
        {}
        break;
    }
    return const SizedBox(width: 0.0, height: 0.0);
  }
}
