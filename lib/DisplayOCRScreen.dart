import 'package:flutter/material.dart';
import 'dart:io';
import 'CameraPage.dart';
//import 'HistoryPage.dart';

// A widget that displays the picture taken by the user.
class DisplayOCRScreen extends StatelessWidget {
  final String imagePath;
  final double num;

  const DisplayOCRScreen({Key key, this.imagePath, this.num}) : super(key: key);

  double calculate(double priceOld) {
    double priceNew;
    double discount;
    double perc = percentage;

    if (priceOld != null) {
      discount = priceOld * (perc / 100);
      discount = double.parse(discount.toStringAsFixed(2));
      priceNew = priceOld - discount;
      priceNew = double.parse(priceNew.toStringAsFixed(2));
    } else {
      priceNew = -1;
    }
    return priceNew;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your calculated new price'),
          backgroundColor: Color(0xff1D2944),
        ),
        body: ListView(
          children: <Widget>[
            Image.file(File(imagePath)), //displays image
            Container(height: 30), //space
            Row(
              children: <Widget>[
                Text(
                  'Price without discount:  ', //text price without %
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  num == null ? "No price detected!": num.toString(), //oldPrice
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(height: 30), //space
            Row(
              children: <Widget>[
                Text(
                  'Price with discount:  ', //text price without %
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                   calculate(num) == -1 ? 'No price detected!' : calculate(num).toString(), //newPrice
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ), //displays numbers
          ],
        ));
  }
}
