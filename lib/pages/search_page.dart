///*************************************************************************
/// Project Title: Community Map of Oshawa                                 *
/// Class: CSCI 4100U: Mobile Devices                                      *
/// File Name: search_page.dart                                            *
/// Authors:  Ramandeep Rathor - 100683854                                 *
///           Oluwadamilola Sanusi - 100620982                             *
///           Sara Bhatti - 100473397                                      *
///           Anddy Pena - 100638067                                       *
/// Description: This app is designed using the Flutter framework.         *
/// It utilizies various libraries such as Firebase, OpenWeatherMap,       *
/// and Weather to provide users with an interactive experience of the     *
/// city of Oshawa, in Ontario Canada.                                     *
///*************************************************************************/
import 'dart:async';
import 'dart:convert';
import 'globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:group_9_final_project/pages/globals.dart';

List<SearchResults> results = [];
int length = 0;

Future<List<SearchResults>> fetchResults(String search) async {
  var url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?addressdetails=1&q=$search&countrycodes=ca&format=jsonv2');
  http.Response response = await http.get(url);

  if (response.statusCode == 200) {
    results.clear();
    var data = jsonDecode(response.body);
    for (var singleResult in data) {
      SearchResults result = SearchResults(
          singleResult['lat'],
          singleResult['lon'],
          singleResult['display_name'],
          singleResult['category']);
      // print(result.displayName);
      results.add(result);
    }
    return results;
  } else {
    return throw Exception('Failed to load results');
  }
}

void clearResults() async {
  results.clear();
}

void getLength() async {
  if (results.isEmpty) {
    length = 0;
  } else {
    length = results.length;
  }
}

class SearchResults {
  String lat;
  String lon;
  String display_name;
  String category;

  SearchResults(
    this.lat,
    this.lon,
    this.display_name,
    this.category,
  );

  SearchResults.fromJson(Map<String, dynamic> json)
      : lat = json['lat'],
        lon = json['lon'],
        display_name = json['display_name'],
        category = json['category'];
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchBoxController = TextEditingController();

  @override
  void initState() {
    results = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 225, 225),
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                controller: searchBoxController,
                onSubmitted: (value) async {
                  List<SearchResults> results =
                      await fetchResults(searchBoxController.text);
                  setState(() {});
                  ListView.builder(itemBuilder: (context, index) {
                    return ListTile(title: Text(results[index].display_name));
                  });
                },
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () async {
                          searchBoxController.clear();
                          setState(() {
                            clearResults();
                          });
                        }),
                    hintText: 'Search...',
                    border: InputBorder.none),
              ),
            ),
          )),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: fetchResults(searchBoxController.text),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            getLength();
            if (length <= 0) {
              return ListView(
                children: <Widget>[
                  const SizedBox(height: 50),
                  const Text("Healthcare",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  GestureDetector(
                      child: const Text("Suggested",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black)),
                      onTap: () {
                        GlobalsVars.health.get().then((querySnapshot) {
                          for (int i = 0; i < querySnapshot.docs.length; i++) {
                            // DEBUG
                            print("Display Name:" +
                                querySnapshot.docs[i].data()['display_name'] +
                                "Latitude: " +
                                querySnapshot.docs[i].data()['lat'] +
                                "Longitude: " +
                                querySnapshot.docs[i].data()['lon']);
                            // print(querySnapshot.docs[i].data());
                            // print(querySnapshot.docs[i].data()['lat']);
                            // print(querySnapshot.docs[i].data()['lon']);
                            // print(querySnapshot.docs[i].data()['display_name']);
                          }
                        });
                      }),
                  const SizedBox(height: 5),
                  //SizedBox(height: 5),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40.0)),
                      border: Border.all(color: Colors.black, width: 3),
                      color: Colors.transparent,
                      image: const DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/healthcare.jpg'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text("Culture",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  GestureDetector(
                      child: const Text("Suggested",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black)),
                      onTap: () {
                        GlobalsVars.health.get().then((querySnapshot) {
                          for (int i = 0; i < querySnapshot.docs.length; i++) {
                            // DEBUG
                            print("Display Name:" +
                                querySnapshot.docs[i].data()['display_name'] +
                                "Latitude: " +
                                querySnapshot.docs[i].data()['lat'] +
                                "Longitude: " +
                                querySnapshot.docs[i].data()['lon']);
                            // print(querySnapshot.docs[i].data());
                            // print(querySnapshot.docs[i].data()['lat']);
                            // print(querySnapshot.docs[i].data()['lon']);
                            // print(querySnapshot.docs[i].data()['display_name']);
                          }
                        });
                      }),
                  const SizedBox(height: 5),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40.0)),
                      border: Border.all(color: Colors.black, width: 3),
                      color: Colors.transparent,
                      image: const DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/warship.jpg'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text("Community",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  GestureDetector(
                      child: const Text("Suggested",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black)),
                      onTap: () {
                        GlobalsVars.health.get().then((querySnapshot) {
                          for (int i = 0; i < querySnapshot.docs.length; i++) {
                            // DEBUG
                            print("Display Name:" +
                                querySnapshot.docs[i].data()['display_name'] +
                                "Latitude: " +
                                querySnapshot.docs[i].data()['lat'] +
                                "Longitude: " +
                                querySnapshot.docs[i].data()['lon']);
                            // print(querySnapshot.docs[i].data());
                            // print(querySnapshot.docs[i].data()['lat']);
                            // print(querySnapshot.docs[i].data()['lon']);
                            // print(querySnapshot.docs[i].data()['display_name']);
                          }
                        });
                      }),
                  const SizedBox(height: 5),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40.0)),
                      border: Border.all(color: Colors.black, width: 3),
                      color: Colors.transparent,
                      image: const DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/community.jpg'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text("Housing",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  GestureDetector(
                      child: const Text("Suggested",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black)),
                      onTap: () {
                        GlobalsVars.health.get().then((querySnapshot) {
                          for (int i = 0; i < querySnapshot.docs.length; i++) {
                            // DEBUG
                            print("Display Name:" +
                                querySnapshot.docs[i].data()['display_name'] +
                                "Latitude: " +
                                querySnapshot.docs[i].data()['lat'] +
                                "Longitude: " +
                                querySnapshot.docs[i].data()['lon']);
                            // print(querySnapshot.docs[i].data());
                            // print(querySnapshot.docs[i].data()['lat']);
                            // print(querySnapshot.docs[i].data()['lon']);
                            // print(querySnapshot.docs[i].data()['display_name']);
                          }
                        });
                      }),
                  const SizedBox(height: 5),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40.0)),
                      border: Border.all(color: Colors.black, width: 3),
                      color: Colors.transparent,
                      image: const DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/housing.jpg'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text("Service Oshawa",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  GestureDetector(
                      child: const Text("Suggested",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black)),
                      onTap: () {
                        GlobalsVars.health.get().then((querySnapshot) {
                          for (int i = 0; i < querySnapshot.docs.length; i++) {
                            // DEBUG
                            print("Display Name:" +
                                querySnapshot.docs[i].data()['display_name'] +
                                "Latitude: " +
                                querySnapshot.docs[i].data()['lat'] +
                                "Longitude: " +
                                querySnapshot.docs[i].data()['lon']);
                            // print(querySnapshot.docs[i].data());
                            // print(querySnapshot.docs[i].data()['lat']);
                            // print(querySnapshot.docs[i].data()['lon']);
                            // print(querySnapshot.docs[i].data()['display_name']);
                          }
                        });
                      }),
                  const SizedBox(height: 5),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40.0)),
                      border: Border.all(color: Colors.black, width: 3),
                      color: Colors.transparent,
                      image: const DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/service.jpg'),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (ctx, index) => ListTile(
                  title: Text(snapshot.data[index].display_name),
                  leading: Icon(Icons.location_on),
                  contentPadding: const EdgeInsets.only(bottom: 20.0),
                  onTap: () {
                    selectedIndex = index;
                    Navigator.pop(context, snapshot.data[index]);
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
