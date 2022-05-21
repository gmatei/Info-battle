//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:info_battle/models/game_data.dart';
import 'package:info_battle/models/game_player.dart';
import 'package:info_battle/models/question.dart';
import 'package:info_battle/models/questionset.dart';
import 'package:info_battle/models/user_data.dart';

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

  Future createGame(String uid, String gameCode) async {
    return await gameCollection.doc(gameCode).set({
      'gameId': gameCode,
      'nrConnectedUsers': 0,
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

    await gameCollection.doc(gameCode).set({
      'gameId': gameCode,
      'nrConnectedUsers': nrConnected + 1,
    });

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
          Map<String, String> questionMap = {
            "qText": question.qText,
            "option1": question.option1,
            "option2": question.option2,
            "option3": question.option3,
            "option4": question.option4,
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
      );
    }).toList();
  }
}

  // Future<List<Question>> returnQuestionsFromSet(String quizId) async {
  //   QuerySnapshot querySnapshot =
  //       await questionCollection.doc("123").collection("QuizContent").get();

  //   return querySnapshot.docs.map(_questionsFromSnapshot).toList();
  // }

  // Question _questionsFromSnapshot(DocumentSnapshot snapshot) {

  //   return Question(
  //       qText: snapshot.get('quizId'),
  //       option1: snapshot.get('quizAddedBy'),
  //       option2: snapshot.get('quizTitle'),
  //       option3: snapshot.get('quizDescription'),
  //       option4: questions);
  // }