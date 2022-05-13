//@dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String nickname) async {
    return await userCollection.doc(uid).set({
      'nickname': nickname,
    });
  }

  //get profiles stream
  Stream<QuerySnapshot> get profiles {
    return userCollection.snapshots();
  }
}
