///*************************************************************************
/// Project Title: Community Map of Oshawa                                 *
/// Class: CSCI 4100U: Mobile Devices                                      *
/// File Name: saved_locations.dart                                        *
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
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:group_9_final_project/models/stream_helper.dart';

List<SavedLocations> results = [];
int length = 0;
String _selectedValue = 'All';

Future<List<SavedLocations>> fetchResults(String search) async {
  var url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?addressdetails=1&q=$search&countrycodes=ca&format=jsonv2');
  http.Response response = await http.get(url);

  if (response.statusCode == 200) {
    results.clear();
    var data = jsonDecode(response.body);
    for (var singleResult in data) {
      SavedLocations result = SavedLocations(
          singleResult['lat'],
          singleResult['lon'],
          singleResult['displayName'],
          singleResult['category']);
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

class SavedLocations {
  String lat;
  String lon;
  String displayName;
  String category;

  SavedLocations(
    this.lat,
    this.lon,
    this.displayName,
    this.category,
  );

  SavedLocations.fromJson(Map<String, dynamic> json)
      : lat = json['lat'],
        lon = json['lon'],
        displayName = json['displayName'],
        category = json['category'];
}

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final searchBoxController = TextEditingController();

  @override
  void initState() {
    results = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 225, 225),
          title: const Text("Saved Locations")),
      body: StreamBuilderWidget(
        selection: _selectedValue,
      ),
    );
  }
}
