import 'package:flutter/material.dart';


//HistoryScreen
//Stateful
class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}
//HomeScreen
//State
class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: new Text(
            'History',
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