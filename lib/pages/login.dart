///*************************************************************************
/// Project Title: Community Map of Oshawa                                 *
/// Class: CSCI 4100U: Mobile Devices                                      *
/// File Name: login.dart                                                  *
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
import 'package:group_9_final_project/main.dart';
import 'package:group_9_final_project/pages/globals.dart';
import 'package:group_9_final_project/pages/password_reset.dart';
import 'package:group_9_final_project/pages/user_registration.dart';

final usernameController = TextEditingController();
final passwordController = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _initUsers();
  }

  void _initUsers() async {}

  @override
  Widget build(BuildContext context) {
    String? _username = '';
    String? _password = '';
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
              Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "keeping you \ninformed\nabout your \ncommunity",
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w900,
                          fontFeatures: [
                            FontFeature.enable('smcp'),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Image.network(
                              'https://www.oshawa.ca/images/structure/logo.png',
                              fit: BoxFit.cover))
                    ],
                  ),
                ],
              ),
              Row(
                children: const [
                  Text("Oshawa edition",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                        fontFeatures: [
                          FontFeature.enable('smcp'),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                child: Form(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Username',
                      ),
                      controller: usernameController,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Password',
                      ),
                      obscureText: true,
                      controller: passwordController,
                    ),
                    Row(
                      children: [
                        TextButton(
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w700),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const PasswordResetPage()));
                          },
                        ),
                        const Spacer(flex: 1),
                        TextButton(
                          onPressed: () async {
                            await AuthFunctions().login(usernameController.text,
                                passwordController.text);
                            var signedUser = AuthFunctions.auth.currentUser;
                            if (signedUser == null) {
                            } else {
                              usernameController.clear();
                              passwordController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Signed in Successfully')));

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const MyHomePage(
                                        title: 'Map of Oshawa',
                                      )));
                              setState(() {});
                            }
                          },
                          child: const Text('Login'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            primary: Colors.white,
                            backgroundColor: Colors.black87,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ),
              InkWell(
                  onTap: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UserRegistrationPage()))
                      },
                  child: const Text("Register"))
            ],
          ),
        ),
      ),
    );
  }
}
