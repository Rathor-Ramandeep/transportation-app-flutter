///*************************************************************************
/// Project Title: Community Map of Oshawa                                 *
/// Class: CSCI 4100U: Mobile Devices                                      *
/// File Name: password_reset.dart                                         *
/// Authors:  Ramandeep Rathor - 100683854                                 *
///           Oluwadamilola Sanusi - 100620982                             *
///           Sara Bhatti - 100473397                                      *
///           Anddy Pena - 100638067                                       *
/// Description: This app is designed using the Flutter framework.         *
/// It utilizies various libraries such as Firebase, OpenWeatherMap,       *
/// and Weather to provide users with an interactive experience of the     *
/// city of Oshawa, in Ontario Canada.                                     *
///*************************************************************************/
import 'package:flutter/material.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController usernameFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Password reset"),
        ),
        body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            children: [
              const Text("Username: "),
              TextField(
                controller: usernameFieldController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person_outline),
                  hintText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text("Password: "),
              TextField(
                controller: passwordFieldController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock_outline),
                  hintText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          )
        ]));
  }
}
