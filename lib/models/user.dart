///*************************************************************************
/// Project Title: Community Map of Oshawa                                 *
/// Class: CSCI 4100U: Mobile Devices                                      *
/// File Name: user.dart                                                   *
/// Authors:  Ramandeep Rathor - 100683854                                 *
///           Oluwadamilola Sanusi - 100620982                             *
///           Sara Bhatti - 100473397                                      *
///           Anddy Pena - 100638067                                       *
/// Description: This app is designed using the Flutter framework.         *
/// It utilizies various libraries such as Firebase, OpenWeatherMap,       *
/// and Weather to provide users with an interactive experience of the     *
/// city of Oshawa, in Ontario Canada.                                     *
///*************************************************************************/
import 'package:flutter/cupertino.dart';
import 'package:group_9_final_project/models/place.dart';

class User {
  @required
  final int id;
  @required
  final String username;
  @required
  final String password;
  @required
  final String email;
  @required
  final String profileImagePath;
  @required
  final List<Place> addresses;

  User(
      {required this.id,
      required this.username,
      required this.password,
      required this.email,
      required this.profileImagePath,
      required this.addresses});

  int getID() {
    return id;
  }

  String getusername() {
    return username;
  }

  String getEmail() {
    return email;
  }

  String getPassword() {
    return password;
  }

  String getProfileImagePath() {
    return profileImagePath;
  }

  User.fromJson(Map<String, Object?> userJSON)
      : this(
          id: (userJSON['id']! as int),
          username: userJSON['username']! as String,
          password: userJSON['password']! as String,
          email: userJSON['email']! as String,
          profileImagePath: userJSON['profileImagePath']! as String,
          addresses: (userJSON['addresses']! as List).cast<Place>(),
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'profileImagePath': profileImagePath,
      'addresses': addresses,
    };
  }
}
