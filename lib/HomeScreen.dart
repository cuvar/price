import 'package:flutter/material.dart';

//HomeScreen
//Stateful
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
//HomeScreen
//State
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: new Text(
            'Home',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20)),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}