import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'CameraScreen.dart';
import 'HistoryScreen.dart';
import 'HomeScreen.dart';

//
//MAIN
//
Future<void> main() async => runApp(MyApp());

//ROOT OF APP
//general data and settings for app
class MyApp extends StatelessWidget {
  static final cameras = getCams();
  final CameraDescription firstCamera = cameras.first;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        home: HomePage(
          camera: firstCamera,
        ),
        debugShowCheckedModeBanner: false);
  }

  static getCams() async {
    return await availableCameras();
  }
}

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('History', Icons.history, Colors.blue),
  Destination('Camera', Icons.camera, Colors.blue),
  Destination('Home', Icons.home, Colors.blue)
];

//HomePage
//Stateful
class HomePage extends StatefulWidget {
  final CameraDescription camera;

  const HomePage({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

//HomePage
//State
class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            HistoryScreen(),
            CameraScreen(cam: widget.camera),
            HomeScreen()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
            icon: Icon(destination.icon),
            backgroundColor: destination.color,
            title: Text(destination.title),
          );
        }).toList(),
      ),
    );
  }
}
