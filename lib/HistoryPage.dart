/*






UNUSED









import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => new _HistoryPageState();
}

double percentage = 0;

class _HistoryPageState extends State<HistoryPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 30),
          Row(
            children: <Widget>[
              Text(                           //text for current %
                'Current discount:  ',  
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
              Text(
                '$percentage%',               //current %
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(height: 20),
          Row(
            children: <Widget>[
              Text(
                'Enter new discount:  ',          //text for new %
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
              Container(
                width: 50,
                child: TextField(                 //editfield for %
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  decoration: new InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                  ),
                  onSubmitted: (String a){
                    setState(() {
                      percentage = double.parse(a);
                    });
                  },
                ),
              )
            ],
          ),
          Container(height: 40),                  //space
          Divider(
            height: 1,
            thickness: 1.5,
            color: Colors.grey,
            endIndent: 20.0,
          ),
        ],
      ),
    );
  }
}
*/