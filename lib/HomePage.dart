import 'package:flutter/material.dart';
import 'CameraPage.dart';
//import 'HistoryPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}


class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1D2944),       //main theme color
        title: Text('Price'),
      ),
      body: CameraPage(), // new
    );
  }
}
