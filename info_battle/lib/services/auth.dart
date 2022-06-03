//@dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:info_battle/models/app_user.dart';
import 'package:info_battle/services/database.dart';

import '../utils/constants.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //auth change user stream
  Stream<AppUser> get user {
    return _firebaseAuth
        .authStateChanges()
        .map((User user) => _appUserFromUser(user));
  }

  //create user obj based on FirebaseUser
  AppUser _appUserFromUser(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  //register with email
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      //create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(
          user.email.split('@')[0], defaultPlayerPic, user.email);

      return _appUserFromUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //sign in with email
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _appUserFromUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
