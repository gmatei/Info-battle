// @dart=2.9

import 'package:info_battle/models/question.dart';
import 'package:info_battle/models/user_data.dart';

class GameData {
  final String gameId;
  final int nrConnectedUsers;
  final String command;
  final String activePlayer;
  final int currentRound;
  final String player1;
  final String player2;
  final String player3;
  final String attackedPlayer;
  final Map<String, String> currentQuestion;
  final String activeAnswer;
  final String attackedAnswer;

  const GameData(
      {this.gameId,
      this.nrConnectedUsers,
      this.command,
      this.activePlayer,
      this.currentRound,
      this.player1,
      this.player2,
      this.player3,
      this.attackedPlayer,
      this.currentQuestion,
      this.activeAnswer,
      this.attackedAnswer});
}
