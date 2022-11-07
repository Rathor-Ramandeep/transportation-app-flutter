///*************************************************************************
/// Project Title: Community Map of Oshawa                                 *
/// Class: CSCI 4100U: Mobile Devices                                      *
/// File Name: main.dart                                                   *
/// Authors:  Ramandeep Rathor - 100683854                                 *
///           Oluwadamilola Sanusi - 100620982                             *
///           Sara Bhatti - 100473397                                      *
///           Anddy Pena - 100638067                                       *
/// Description: This app is designed using the Flutter framework.         *
/// It utilizies various libraries such as Firebase, OpenWeatherMap,       *
/// and Weather to provide users with an interactive experience of the     *
/// city of Oshawa, in Ontario Canada.                                     *
///*************************************************************************/

// Imports of libraries and dependancies
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:weather/weather.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_9_final_project/pages/login.dart';
import 'package:group_9_final_project/pages/globals.dart';
import 'package:group_9_final_project/pages/search_page.dart';
import 'package:group_9_final_project/pages/saved_locations.dart';

var locationResult;
var favResults;
String weather_icon = '';
String temp = '';
List<Marker> markers = [];

final MapController _mapController = MapController();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

void getSheetDetails(SearchResults result) {
  SearchResults details = result;
  // print(details);
}

getMarker(lat, lon, context) {
  markers.add(Marker(
    point: LatLng(lat, lon),
    width: 80.0,
    height: 80.0,
    builder: (ctx) => GestureDetector(
      child: const Icon(
        Icons.place,
        size: 40.0,
        color: Colors.red,
      ),
      onTap: () => {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Wrap(
              children: [
                ListTile(
                  title: const Text(
                    "Current Location",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("\nLocation: " +
                      lat.toString() +
                      "°N, " +
                      lon.toString() +
                      "°E"),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Add to Favorites'),
                  onTap: () {
                    print("Tapped"); // DEBUG
                    final savedPlaces =
                        FirebaseFirestore.instance.collection('savedPlaces');

                    savedPlaces
                        .add({
                          'dispaly_name': "Saved Location",
                          'lat': lat.toString(),
                          'lon': lon.toString(),
                          'category': 'boundary',
                        })
                        .then((value) => print("New Favorite Place Added"))
                        .catchError(
                            (error) => print("Failed to add place: $error"));
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.close),
                    title: const Text('Close'),
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ],
            );
          },
        )
      },
    ),
  ));

  for (var i = 0; i < markers.length; i++) {
    print(markers[i].point.toString());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Getting to know Oshawa',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Position _currPosition;

  bool isLoading = false;
  List<List<dynamic>> _data = [];

  // This function is triggered when the floating button is pressed
  void _loadCSV(String data, String name) async {
    final _rawData = await rootBundle.loadString(data);
    List<List<dynamic>> _listData =
        const CsvToListConverter().convert(_rawData);
    if (_listData.isNotEmpty) {
      for (var i = 0; i < _listData.length; i++) {
        if (name == 'culture') {
          GlobalsVars.culture.add({
            'display_name': _data[i][3],
            'lat': _listData[i][0],
            'lon': _listData[i][1]
          });
        }
        if (name == 'health') {
          GlobalsVars.health.add({
            'display_name': _listData[i][3],
            'lat': _listData[i][0],
            'lon': _listData[i][1]
          });
        }
        if (name == 'education') {
          GlobalsVars.education.add({
            'display_name': _listData[i][3],
            'lat': _listData[i][0],
            'lon': _listData[i][1]
          });
        }
        if (name == 'community') {
          GlobalsVars.community.add({
            'display_name': _listData[i][3],
            'lat': _listData[i][0],
            'lon': _listData[i][1]
          });
        }
        if (name == 'housing') {
          GlobalsVars.housing.add({
            'display_name': _listData[i][3],
            'lat': _listData[i][0],
            'lon': _listData[i][1]
          });
        }
      }
    } else {
      print('Empty');
    }
    setState(() {
      _data = _listData;
    });
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    locationResult = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SearchPage()));
    try {
      if (locationResult == null) {
        throw Exception("Empty Result");
      }
      showModalBottomSheet(
        context: context,
        builder: (context) {
          _mapController.move(
              LatLng(double.parse(locationResult.lat),
                  double.parse(locationResult.lon)),
              10);
          getMarker(double.parse(locationResult.lat),
              double.parse(locationResult.lon), context);
          getCategory() {
            print(locationResult.category);
            if (locationResult.category == 'health') {
              return Icons.health_and_safety_outlined;
            } else if (locationResult.category == 'religion' ||
                locationResult.category == 'culture') {
              return Icons.flare;
            } else if (locationResult.category == 'building' ||
                locationResult.category == 'horistic' ||
                locationResult.category == 'tourism') {
              return Icons.follow_the_signs_outlined;
            } else if (locationResult.category == 'amenities') {
              return Icons.business;
            } else {
              return Icons.warning_amber_rounded;
            }
          }

          return Wrap(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Icon(getCategory()),
                ),
                title: Text(
                  locationResult.display_name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Location: " +
                    locationResult.lat +
                    "°N, " +
                    locationResult.lon +
                    "°E"),
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Add to Favorites'),
                onTap: () {
                  final savedPlaces =
                      FirebaseFirestore.instance.collection('savedPlaces');

                  savedPlaces
                      .add({
                        'dispaly_name': locationResult.display_name,
                        'lat': locationResult.lat,
                        'lon': locationResult.lon,
                        'category': locationResult.category,
                      })
                      .then((value) => print("New Favorite Place Added"))
                      .catchError(
                          (error) => print("Failed to add place: $error"));
                },
              ),
              ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('Close'),
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        },
      );
    } catch (e) {
      locationResult = [];
    }
  }

  _getCurrentWeather() async {
    await wf
        .currentWeatherByLocation(
            _currPosition.latitude, _currPosition.longitude)
        .then((Weather newWeather) {
      setState(() {
        temp = newWeather.temperature!.celsius!.toStringAsPrecision(1);
        weather_icon = newWeather.weatherIcon.toString();
      });
    });
  }

  _getCurrentLocation() async {
    await GeolocatorPlatform.instance
        .getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true,
            timeLimit: const Duration(minutes: 10))
        .then((Position position) {
      setState(() {
        _currPosition = position;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    _currPosition = Position(
        longitude: 60,
        latitude: 43,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0);

    List<Marker> markers = [];

    _getCurrentLocation();
    _getCurrentWeather();
    getMarker(_currPosition.latitude, _currPosition.longitude, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: userSection(context),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () async {
                _navigateAndDisplaySelection(context);
              },
              color: Colors.black87,
            ),
          ),
        ],
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black87, fontSize: 18),
        ),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(
                Icons.menu,
                color: Colors.black87,
              )),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
                zoom: 13.0, center: LatLng(43.8971, -78.8658), onTap: null),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                attributionBuilder: (_) {
                  return const Text("© OpenStreetMap contributors");
                },
              ),
              MarkerLayerOptions(
                markers: List<Marker>.of(markers),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: () {
          _loadCSV('assets/csv/Oshawa_Places_of_Worship.csv', 'culture');
          _loadCSV('assets/csv/Healthcare.csv', 'health');
          _loadCSV('assets/csv/Oshawa_Educational_Facilities.csv', 'education');
          _loadCSV('assets/csv/Oshawa_Community_Centres.csv', 'community');
          _loadCSV('assets/csv/Oshawa_Senior_s_Residences.csv', 'housing');
          _loadCSV('assets/csv/Affordable_Housing.csv', 'housing');
          _getCurrentLocation();
          getMarker(_currPosition.latitude, _currPosition.longitude, context);
          _mapController.move(
              LatLng(_currPosition.latitude, _currPosition.longitude), 13);
        },
        tooltip: 'Increment',
        child: const Icon(
          Icons.my_location_rounded,
          color: Color.fromARGB(255, 255, 225, 225),
        ),
      ),
    );
  }
}

const String _apiKeyWeather = "6f024d9e1acb957354434cb19bbf4ca1";
WeatherFactory wf = WeatherFactory(_apiKeyWeather);

Widget userSection(BuildContext context) {
  void navigateAndDisplaySaved(BuildContext context) async {
    locationResult = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SavedPage()));
    try {
      if (locationResult == null) {
        throw Exception("Empty Result");
      }
      showModalBottomSheet(
        context: context,
        builder: (context) {
          _MyHomePageState().setState(() {});
          _mapController.move(
              LatLng(double.parse(locationResult.lat),
                  double.parse(locationResult.lon)),
              10);

          getCategory() {
            if (locationResult.category == 'health') {
              return Icons.health_and_safety_outlined;
            } else if (locationResult.category == 'religion' ||
                locationResult.category == 'culture') {
              return Icons.flare;
            } else if (locationResult.category == 'building' ||
                locationResult.category == 'horistic' ||
                locationResult.category == 'tourism') {
              return Icons.follow_the_signs_outlined;
            } else if (locationResult.category == 'amenities') {
              return Icons.business;
            } else {
              return Icons.warning_amber_rounded;
            }
          }

          return Wrap(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Icon(getCategory()),
                ),
                title: Text(
                  locationResult.display_name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Location: " +
                    locationResult.lat +
                    "°N, " +
                    locationResult.lon +
                    "°E"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Add to Favorites'),
                onTap: () {
                  final savedPlaces =
                      FirebaseFirestore.instance.collection('savedPlaces');

                  savedPlaces
                      .add({
                        'dispaly_name': locationResult.display_name,
                        'lat': locationResult.lat,
                        'lon': locationResult.lon,
                        'category': locationResult.category,
                      })
                      .then((value) => print("New Favorite Place Added"))
                      .catchError(
                          (error) => print("Failed to add place: $error"));
                },
              ),
              ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('Close'),
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        },
      );
    } catch (e) {
      locationResult = [];
    }
    _MyHomePageState().setState(() {});
  }

  String uri =
      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YXZhdGFyfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=60';

  return Drawer(
    child: Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black38,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ListView(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 30, backgroundImage: NetworkImage(uri)),
                    ],
                  ),
                  Column(
                    children: const [
                      SizedBox(width: 150),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.network('http://openweathermap.org/img/wn/' +
                          weather_icon +
                          '.png'),
                      Text(temp + '°C',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFeatures: [
                                FontFeature.enable('smcp'),
                              ])),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Username",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 4),
              const Text(
                'user@email.com',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 100),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Color.fromARGB(255, 255, 225, 225),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                      onTap: () => {},
                      child: GestureDetector(
                        onTap: () async => {navigateAndDisplaySaved(context)},
                        child: const Text(
                          'Saved Locations',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 350),
          Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      AuthFunctions().logout();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Logged Out Successfully')));
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('logout',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w900,
                            fontFeatures: [
                              FontFeature.enable('smcp'),
                            ])),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 20, bottom: 20),
                      primary: Colors.black87,
                      backgroundColor: const Color.fromARGB(255, 255, 225, 225),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat("MMMM dd, yyyy").format(DateTime.now()),
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                      Text(
                        DateFormat("hh:mm a").format(DateTime.now()),
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ]),
      ),
    ),
  );
}
