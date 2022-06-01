//@dart=2.9
// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/models/game_player.dart';
import 'package:info_battle/models/question.dart';
import 'package:info_battle/models/questionset.dart';
import 'package:info_battle/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  final String uid;
  final String gameid;

  DatabaseService({this.uid, this.gameid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference questionCollection =
      FirebaseFirestore.instance.collection('questions');

  final CollectionReference gameCollection =
      FirebaseFirestore.instance.collection('games');

  Future updateUserData(String nickname, String imagepath, String email) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'nickname': nickname,
      'imagepath': imagepath,
      'email': email,
    });
  }

  //user_data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: snapshot.get('uid'),
        name: snapshot.get('nickname'),
        email: snapshot.get('email'),
        imagePath: snapshot.get('imagepath'));
  }

  GameData _gameDataFromSnapshot(DocumentSnapshot snapshot) {
    return GameData(
      gameId: snapshot.get('gameId'),
      nrConnectedUsers: snapshot.get('nrConnectedUsers'),
      command: snapshot.get('command'),
      activePlayer: snapshot.get('activePlayer'),
      currentRound: snapshot.get('currentRound'),
      totalRounds: snapshot.get('totalRounds'),
      player1: snapshot.get('player1'),
      player2: snapshot.get('player2'),
      player3: snapshot.get('player3'),
      attackedPlayer: snapshot.get('attacked'),
      currentQuestion: {...snapshot.get('currentQuestion')},
      activeAnswer: snapshot.get('activePlayerAnswer'),
      attackedAnswer: snapshot.get('attackedPlayerAnswer'),
      player1Score: snapshot.get('player1Score'),
      player2Score: snapshot.get('player2Score'),
      player3Score: snapshot.get('player3Score'),
      activeUpdate: snapshot.get('activeUpdate'),
      attackedUpdate: snapshot.get('attackedUpdate'),
    );
  }

  //get profile stream
  Stream<UserData> get profile {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // get question sets stream
  Stream<List<QuestionSet>> get questionSets {
    return questionCollection.snapshots().map(_questionSetListFromSnapshot);
  }

  Future updateQuestion() async {
    Stream<Question> randomQuestion = gameCollection
        .doc(gameid)
        .collection("GameQuestions")
        .snapshots()
        .map(_questionFromSnapshot);

    randomQuestion.listen((question) async {
      Map<String, String> questionMap = {
        'qText': question.qText,
        'option1': question.option1,
        'option2': question.option2,
        'option3': question.option3,
        'option4': question.option4,
        'correctAnswer': question.correctAnswer
      };

      await gameCollection.doc(gameid).update({
        'currentQuestion': questionMap,
      });
      return;
    });
  }

  //get random question stream
  Stream<Question> get currentQuestion {
    return gameCollection
        .doc(gameid)
        .snapshots()
        .map(_currentQuestionFromSnapshot);
  }

  Question _currentQuestionFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, String> question = {...snapshot.get('currentQuestion')};
    return Question(
      qText: question['qText'],
      option1: question['option1'],
      option2: question['option2'],
      option3: question['option3'],
      option4: question['option4'],
      correctAnswer: question['correctAnswer'],
    );
  }

  Question _questionFromSnapshot(QuerySnapshot snapshot) {
    List<Question> questionList = snapshot.docs.map((doc) {
      return Question(
        qText: doc.get('qText') ?? '',
        option1: doc.get('option1') ?? '',
        option2: doc.get('option2') ?? '',
        option3: doc.get('option3') ?? '',
        option4: doc.get('option4') ?? '',
        correctAnswer: doc.get('correctAnswer') ?? '',
      );
    }).toList();

    final random = Random();
    return questionList[random.nextInt(questionList.length)];
  }

  // get players stream
  Stream<List<PlayerData>> get gamePlayers {
    return gameCollection
        .doc(gameid)
        .collection("GamePlayers")
        .snapshots()
        .map(_gamePlayersListFromSnapshot);
  }

  // get game stream
  Stream<GameData> get currentGame {
    return gameCollection.doc(gameid).snapshots().map(_gameDataFromSnapshot);
  }

  List<QuestionSet> _questionSetListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return QuestionSet(
        qsetId: doc.get('quizId') ?? '',
        addedBy: doc.get('quizAddedBy') ?? '',
        title: doc.get('quizTitle') ?? '',
        description: doc.get('quizDescription') ?? '',
      );
    }).toList();
  }

  Future<void> addQuizData(Map quizData, String quizId) async {
    await questionCollection.doc(quizId).set(quizData).catchError((e) {
      print(e);
    });
  }

  Future<void> addQuestionData(quizData, String quizId) async {
    await questionCollection
        .doc(quizId)
        .collection("QuizContent")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Future createGame(String uid, String gameCode, int nrRounds) async {
    Map<String, String> currentQuestion = {
      'qText': 'none',
      'option1': 'option1',
      'option2': 'option2',
      'option3': 'option3',
      'option4': 'option4',
      'correctAnswer': 'none'
    };

    return await gameCollection.doc(gameCode).set({
      'gameId': gameCode,
      'nrConnectedUsers': 0,
      'command': 'init',
      'activePlayer': 'none',
      'currentRound': 0,
      'totalRounds': nrRounds,
      'player1': 'none',
      'player2': 'none',
      'player3': 'none',
      'attacked': 'none',
      'currentQuestion': currentQuestion,
      'activePlayerAnswer': 'none',
      'attackedPlayerAnswer': 'none',
      'player1Score': 0,
      'player2Score': 0,
      'player3Score': 0,
      'activeUpdate': 'none',
      'attackedUpdate': 'none'
    });
  }

  Future<void> addPlayer(UserData userData, String gameCode) async {
    Map<String, String> userMap = {
      "uid": userData.uid,
      "name": userData.name,
      "imagePath": userData.imagePath
    };

    int nrConnected;

    await gameCollection.doc(gameCode).get().then((DocumentSnapshot ds) {
      nrConnected = ds.get('nrConnectedUsers');
    });

    if (nrConnected == 0) {
      await gameCollection.doc(gameCode).update({
        'nrConnectedUsers': nrConnected + 1,
        'player1': userData.name,
      });
    }

    if (nrConnected == 1) {
      await gameCollection.doc(gameCode).update({
        'nrConnectedUsers': nrConnected + 1,
        'player2': userData.name,
      });
    }

    if (nrConnected == 2) {
      await gameCollection.doc(gameCode).update({
        'nrConnectedUsers': nrConnected + 1,
        'player3': userData.name,
      });
    }

    await gameCollection.doc(gameCode).collection("GamePlayers").add(userMap);
  }

  List<PlayerData> _gamePlayersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PlayerData(
        uid: doc.get('uid') ?? '',
        name: doc.get('name') ?? '',
        imagePath: doc.get('imagePath') ?? '',
      );
    }).toList();
  }

  Future<void> addQuestionsToGame(List<QuestionSet> questionSets) async {
    for (QuestionSet questionSet in questionSets) {
      Stream<List<Question>> currentEntries = questionCollection
          .doc(questionSet.qsetId)
          .collection("QuizContent")
          .snapshots()
          .map(_questionListFromSnapshot);

      currentEntries.listen((listOfQuestions) async {
        for (Question question in listOfQuestions) {
          List<String> qAnswers = [
            question.option1,
            question.option2,
            question.option3,
            question.option4
          ];

          qAnswers.shuffle();

          Map<String, String> questionMap = {
            "qText": question.qText,
            "option1": qAnswers[0],
            "option2": qAnswers[1],
            "option3": qAnswers[2],
            "option4": qAnswers[3],
            "correctAnswer": question.correctAnswer,
          };

          await gameCollection
              .doc(gameid)
              .collection("GameQuestions")
              .add(questionMap);
        }
      });
    }
  }

  List<Question> _questionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Question(
        qText: doc.get('question') ?? '',
        option1: doc.get('option1') ?? '',
        option2: doc.get('option2') ?? '',
        option3: doc.get('option3') ?? '',
        option4: doc.get('option4') ?? '',
        correctAnswer: doc.get('correctAnswer') ?? '',
      );
    }).toList();
  }

  Future updateCommand(String command, String active, {String attacked}) async {
    int timeValue;
    String activePlayer;

    switch (active) {
      case 'player1':
        {
          await gameCollection.doc(gameid).get().then((DocumentSnapshot ds) {
            activePlayer = ds.get('player1');
          });
        }
        break;
      case 'player2':
        {
          await gameCollection.doc(gameid).get().then((DocumentSnapshot ds) {
            activePlayer = ds.get('player2');
          });
        }
        break;
      case 'player3':
        {
          await gameCollection.doc(gameid).get().then((DocumentSnapshot ds) {
            activePlayer = ds.get('player3');
          });
        }
        break;
      default:
        {
          activePlayer = active;
        }
    }

    switch (command) {
      case 'init':
        {
          timeValue = 7;
        }
        break;
      case 'round':
        {
          timeValue = 7;
        }
        break;
      case 'playerChoice':
        {
          timeValue = 6;
        }
        break;
      case 'attack':
        {
          timeValue = 1;
        }
        break;
      case 'showAnswer':
        {
          timeValue = 22;
        }
        break;
      case 'returnFromQuestion':
        {
          timeValue = 2;
        }
        break;

      default:
        {
          timeValue = 5;
        }
        break;
    }

    int currentRound;
    await gameCollection.doc(gameid).get().then((DocumentSnapshot ds) {
      currentRound = ds.get('currentRound');
    });
    if (command == 'round') currentRound++;

    if (attacked != 'none') {
      Timer(Duration(seconds: timeValue), () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('showAns', false);
        await prefs.setBool('updatedScore', false);
        await gameCollection.doc(gameid).update({
          'command': command,
          'activePlayer': activePlayer,
          'currentRound': currentRound,
          'attacked': attacked
        });
      });
    } else {
      if (command == 'showAnswer') {
        Timer(Duration(seconds: timeValue), () async {
          final prefs = await SharedPreferences.getInstance();

          if (prefs.getBool('showAns') == false) {
            await prefs.setBool('showAns', true);

            await gameCollection.doc(gameid).update({
              'command': command,
              'activePlayer': activePlayer,
              'currentRound': currentRound,
            });
          }
        });
      } else {
        Timer(Duration(seconds: timeValue), () async {
          await gameCollection.doc(gameid).update({
            'command': command,
            'activePlayer': activePlayer,
            'currentRound': currentRound,
          });
        });
      }
    }
  }

  Future setActiveAnswer(String answer) async {
    return await gameCollection.doc(gameid).update({
      'activePlayerAnswer': answer,
    });
  }

  Future setAttackedAnswer(String answer) async {
    return await gameCollection.doc(gameid).update({
      'attackedPlayerAnswer': answer,
    });
  }

  Future resetAnswers() async {
    Timer(Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.getBool('updatedScore') == false) {
        await prefs.setBool('updatedScore', true);

        String activePlayerAnswer,
            attackedPlayerAnswer,
            correctAnswer,
            activePlayer,
            attackedPlayer;

        String player1;
        int player1Score;
        String player2;
        int player2Score;
        String player3;
        int player3Score;

        await gameCollection.doc(gameid).get().then((DocumentSnapshot ds) {
          activePlayerAnswer = ds.get('activePlayerAnswer');
          attackedPlayerAnswer = ds.get('attackedPlayerAnswer');
          correctAnswer = ds.get('currentQuestion.correctAnswer');
          activePlayer = ds.get('activePlayer');
          attackedPlayer = ds.get('attacked');
          player1 = ds.get('player1');
          player2 = ds.get('player2');
          player3 = ds.get('player3');
          player1Score = ds.get('player1Score');
          player2Score = ds.get('player2Score');
          player3Score = ds.get('player3Score');
        });

        if (player1 == activePlayer)
          activePlayer = 'player1';
        else if (player2 == activePlayer)
          activePlayer = 'player2';
        else if (player3 == activePlayer) activePlayer = 'player3';
        if (player1 == attackedPlayer)
          attackedPlayer = 'player1';
        else if (player2 == attackedPlayer)
          attackedPlayer = 'player2';
        else if (player3 == attackedPlayer) attackedPlayer = 'player3';

        if (activePlayerAnswer == correctAnswer &&
            attackedPlayerAnswer == correctAnswer) {
          if (activePlayer == 'player1') {
            await gameCollection.doc(gameid).update({
              'player1Score': player1Score + 100,
              'activeUpdate': '$player1 gained 100 points',
            });
          } else if (activePlayer == 'player2') {
            await gameCollection.doc(gameid).update({
              'player2Score': player2Score + 100,
              'activeUpdate': '$player2 gained 100 points',
            });
          } else if (activePlayer == 'player3') {
            await gameCollection.doc(gameid).update({
              'player3Score': player3Score + 100,
              'activeUpdate': '$player3 gained 100 points',
            });
          }
          if (attackedPlayer == 'player1') {
            await gameCollection.doc(gameid).update({
              'player1Score': player1Score + 100,
              'attackedUpdate': '$player1 gained 100 points',
            });
          } else if (attackedPlayer == 'player2') {
            await gameCollection.doc(gameid).update({
              'player2Score': player2Score + 100,
              'attackedUpdate': '$player2 gained 100 points',
            });
          } else if (attackedPlayer == 'player3') {
            await gameCollection.doc(gameid).update({
              'player3Score': player3Score + 100,
              'attackedUpdate': '$player3 gained 100 points',
            });
          }
        } else if (activePlayerAnswer == correctAnswer &&
            attackedPlayerAnswer != correctAnswer) {
          if (activePlayer == 'player1') {
            await gameCollection.doc(gameid).update({
              'player1Score': player1Score + 300,
              'activeUpdate': '$player1 gained 300 points',
            });
          } else if (activePlayer == 'player2') {
            await gameCollection.doc(gameid).update({
              'player2Score': player2Score + 300,
              'activeUpdate': '$player2 gained 300 points',
            });
          } else if (activePlayer == 'player3') {
            await gameCollection.doc(gameid).update({
              'player3Score': player3Score + 300,
              'activeUpdate': '$player3 gained 300 points',
            });
          }
          if (attackedPlayer == 'player1') {
            await gameCollection.doc(gameid).update({
              'player1Score': player1Score - 100,
              'attackedUpdate': '$player1 lost 100 points',
            });
          } else if (attackedPlayer == 'player2') {
            await gameCollection.doc(gameid).update({
              'player2Score': player2Score - 100,
              'attackedUpdate': '$player2 lost 100 points',
            });
          } else if (attackedPlayer == 'player3') {
            await gameCollection.doc(gameid).update({
              'player3Score': player3Score - 100,
              'attackedUpdate': '$player3 lost 100 points',
            });
          }
        } else if (activePlayerAnswer != correctAnswer &&
            attackedPlayerAnswer == correctAnswer) {
          if (activePlayer == 'player1') {
            await gameCollection.doc(gameid).update({
              'player1Score': player1Score - 100,
              'activeUpdate': '$player1 lost 100 points',
            });
          } else if (activePlayer == 'player2') {
            await gameCollection.doc(gameid).update({
              'player2Score': player2Score - 100,
              'activeUpdate': '$player2 lost 100 points',
            });
          } else if (activePlayer == 'player3') {
            await gameCollection.doc(gameid).update({
              'player3Score': player3Score - 100,
              'activeUpdate': '$player3 lost 100 points',
            });
          }
          if (attackedPlayer == 'player1') {
            await gameCollection.doc(gameid).update({
              'player1Score': player1Score + 300,
              'attackedUpdate': '$player1 gained 300 points',
            });
          } else if (attackedPlayer == 'player2') {
            await gameCollection.doc(gameid).update({
              'player2Score': player2Score + 300,
              'attackedUpdate': '$player2 gained 300 points',
            });
          } else if (attackedPlayer == 'player3') {
            await gameCollection.doc(gameid).update({
              'player3Score': player3Score + 300,
              'attackedUpdate': '$player3 gained 300 points',
            });
          }
        }

        await gameCollection.doc(gameid).update({
          'activePlayerAnswer': 'none',
          'attackedPlayerAnswer': 'none',
          'currentQuestion.qText': 'none'
        });
      }
    });
  }
}
