//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:info_battle/models/user_data.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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
}
