///*************************************************************************
/// Project Title: Community Map of Oshawa                                 *
/// Class: CSCI 4100U: Mobile Devices                                      *
/// File Name: place.dart                                                  *
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

class Place {
  final int id;
  final String name;
  final double lat;
  final double long;
  final int iconCodePoint;

  Place(
      {required this.id,
      required this.name,
      required this.lat,
      required this.long,
      required this.iconCodePoint});

  int getID() {
    return id;
  }

  String getName() {
    return name;
  }

  List<dynamic> getLatLong() {
    return [lat, long];
  }

  Icon getIcon() {
    return Icon(IconData(iconCodePoint));
  }

  Place.fromJson(Map<String, Object?> placeJSON)
      : this(
          id: (placeJSON['id']! as int),
          name: placeJSON['display_name']! as String,
          lat: placeJSON['lat']! as double,
          long: placeJSON['long']! as double,
          iconCodePoint: placeJSON['iconCodePoint']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'lat': lat,
      'long': long,
      'iconCodePoint': iconCodePoint,
    };
  }
}
