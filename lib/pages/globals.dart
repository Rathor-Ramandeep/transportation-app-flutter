///*************************************************************************
/// Project Title: Community Map of Oshawa                                 *
/// Class: CSCI 4100U: Mobile Devices                                      *
/// File Name: globals.dart                                                *
/// Authors:  Ramandeep Rathor - 100683854                                 *
///           Oluwadamilola Sanusi - 100620982                             *
///           Sara Bhatti - 100473397                                      *
///           Anddy Pena - 100638067                                       *
/// Description: This app is designed using the Flutter framework.         *
/// It utilizies various libraries such as Firebase, OpenWeatherMap,       *
/// and Weather to provide users with an interactive experience of the     *
/// city of Oshawa, in Ontario Canada.                                     *
///*************************************************************************/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalsVars {
  static var users = FirebaseFirestore.instance.collection('users');
  static var places = FirebaseFirestore.instance.collection('places');
  static var culture = FirebaseFirestore.instance.collection('culture');
  static var health = FirebaseFirestore.instance.collection('healthcare');
  static var community = FirebaseFirestore.instance.collection('community');
  static var education = FirebaseFirestore.instance.collection('education');
  static var housing = FirebaseFirestore.instance.collection('housing');
  static var serviceOshawa =
      FirebaseFirestore.instance.collection('serviceOshawa');
  static var docId = "";
}

class AuthFunctions {
  static FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> register(String email, String pass) async {
    try {
      final user = (await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      ))
          .user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> login(String email, String pass) async {
    try {
      final user = (await auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      ))
          .user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  logout() {
    auth.signOut();
  }
}
