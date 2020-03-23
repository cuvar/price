import 'package:flutter/material.dart';
import 'dart:io';

// A widget that displays the picture taken by the user.
class DisplayOCRScreen extends StatelessWidget {
  final String imagePath;
  final String text;

  const DisplayOCRScreen({Key key, this.imagePath, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Display the OCR'),
          backgroundColor: Color(0xff1D2944),
        ),
        body: ListView(
          children: <Widget>[Image.file(File(imagePath)), Text(text)],
        ));
  }
}