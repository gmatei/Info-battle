//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:info_battle/models/question.dart';
import 'package:info_battle/models/questionset.dart';
import 'package:info_battle/models/user_data.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference questionCollection =
      FirebaseFirestore.instance.collection('questions');

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

  //get profile stream
  Stream<UserData> get profile {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // get brews stream
  Stream<List<QuestionSet>> get questionSets {
    return questionCollection.snapshots().map(_questionSetListFromSnapshot);
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