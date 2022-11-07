///*************************************************************************
/// Project Title: Community Map of Oshawa                                 *
/// Class: CSCI 4100U: Mobile Devices                                      *
/// File Name: stream_helper.dart                                          *
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
import 'package:cloud_firestore/cloud_firestore.dart';

final users = FirebaseFirestore.instance.collection('users');
final places = FirebaseFirestore.instance.collection('places');
final savedPlaces = FirebaseFirestore.instance.collection('savedPlaces');

class StreamBuilderWidget extends StatefulWidget {
  String selection = '';
  StreamBuilderWidget({Key? key, required this.selection}) : super(key: key);

  @override
  _StreamBuilderWidgetState createState() => _StreamBuilderWidgetState();
}

class _StreamBuilderWidgetState extends State<StreamBuilderWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getSavedData(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text("No Saved Locations");
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final docData = snapshot.data!.docs[index];
              return ListTile(
                title: Text(docData['dispaly_name'].toString()),
                subtitle: Text("Added By: " + docData['user'].toString()),
                onTap: () {
                  _selectedIndex = index;
                  Navigator.pop(context, snapshot.data);
                },
              );
            });
      },
    );
  }

// Queries for users
  Stream<QuerySnapshot> getUserData() {
    if (widget.selection == "All") {
      return users.snapshots();
    }
    return users.where('user', isEqualTo: widget.selection).snapshots();
  }

  Future<void> addUser(String _username, String _password) {
    return users
        .add({
          'username': _username,
          'password': _password,
        })
        .then((value) => print("New User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUser(String _docID, String _password) {
    return users
        .doc(_docID)
        .update({'password': _password})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> deleteUser(String _sid) {
    return users
        .doc(_sid)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  // Queries for places

  Stream<QuerySnapshot> getPlaceData() {
    return users.where('place', isEqualTo: widget.selection).snapshots();
  }

  Future<void> addPlace(String _displayname, String _lat, String _lon,
      String _category, String _user) {
    return places
        .add({
          'dispaly_name': _displayname,
          'lat': _lat,
          'lon': _lon,
          'category': _category,
          'user': _user,
        })
        .then((value) => print("New Favorite Place Added"))
        .catchError((error) => print("Failed to add place: $error"));
  }

  Future<void> updatePlace(String _docID, String _displayname, String _lat,
      String _lon, String _category, String _user) {
    return places
        .doc(_docID)
        .update({
          'dispaly_name': _displayname,
          'lat': _lat,
          'lon': _lon,
          'category': _category,
          'user': _user,
        })
        .then((value) => print("Favorite Place Updated"))
        .catchError((error) => print("Failed to update place: $error"));
  }

  Future<void> deletePlace(String _sid) {
    return places
        .doc(_sid)
        .delete()
        .then((value) => print("Favorite Place Deleted"))
        .catchError((error) => print("Failed to delete place: $error"));
  }

  // Queries for savedPlaces

  Stream<QuerySnapshot> getSavedData() {
    return savedPlaces.snapshots();
  }

  Future<void> addSavedPlace(
      String _displayname, String _lat, String _lon, String _category) {
    return savedPlaces
        .add({
          'dispaly_name': _displayname,
          'lat': _lat,
          'lon': _lon,
          'category': _category,
        })
        .then((value) => print("New Favorite Place Added"))
        .catchError((error) => print("Failed to add place: $error"));
  }

  Future<void> updateSavedPlace(String _docID, String _displayname, String _lat,
      String _lon, String _category) {
    return savedPlaces
        .doc(_docID)
        .update({
          'dispaly_name': _displayname,
          'lat': _lat,
          'lon': _lon,
          'category': _category,
        })
        .then((value) => print("Favorite Place Updated"))
        .catchError((error) => print("Failed to update place: $error"));
  }

  Future<void> deleteSavedPlace(String _sid) {
    return savedPlaces
        .doc(_sid)
        .delete()
        .then((value) => print("Favorite Place Deleted"))
        .catchError((error) => print("Failed to delete place: $error"));
  }
}
