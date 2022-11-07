///*************************************************************************
/// Project Title: Community Map of Oshawa                                 *
/// Class: CSCI 4100U: Mobile Devices                                      *
/// File Name: user_registration.dart                                      *
/// Authors:  Ramandeep Rathor - 100683854                                 *
///           Oluwadamilola Sanusi - 100620982                             *
///           Sara Bhatti - 100473397                                      *
///           Anddy Pena - 100638067                                       *
/// Description: This app is designed using the Flutter framework.         *
/// It utilizies various libraries such as Firebase, OpenWeatherMap,       *
/// and Weather to provide users with an interactive experience of the     *
/// city of Oshawa, in Ontario Canada.                                     *
///*************************************************************************/
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:group_9_final_project/pages/login.dart';
import 'package:group_9_final_project/pages/globals.dart';

final usernameController = TextEditingController();
final passwordController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({Key? key}) : super(key: key);

  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    const bgColor = Color.fromARGB(255, 255, 225, 225);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: bgColor,
      body: Container(
        padding: const EdgeInsets.all(50),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w900,
                      fontFeatures: [
                        FontFeature.enable('smcp'),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Text("Oshawa edition",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w200,
                        fontFeatures: [
                          FontFeature.enable('smcp'),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Username',
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Password',
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      AuthFunctions().register(
                          usernameController.text, passwordController.text);

                      if (_formKey.currentState!.validate()) {
                        AuthFunctions().register(
                            usernameController.text, passwordController.text);
                      } else {
                        const Text('Error! Please check username/password');
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                    },
                    child: const Text('Register'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      primary: Colors.white,
                      backgroundColor: Colors.black87,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
