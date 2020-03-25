import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'DisplayOCRScreen.dart';
import 'Painter.dart';
import 'Camera.dart';

double percentage = 0;

//Stateful widget
class CameraPage extends StatefulWidget {
  CameraPage({Key key}) : super(key: key);

  @override
  _CameraPageState createState() => new _CameraPageState();
}

//stateless widget
class _CameraPageState extends State<CameraPage> {
  CameraController controller;
  List cameras; //list of available cams
  int selectedCameraIdx; //index of selected cam
  double recognizedNum; //stores recognizes text of image

  //searches, gets and initializes camera
  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      //get available cams
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available"); //else error
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  //initializes cameraController
  Future _initCameraController(CameraDescription cameraDescription) async {
    //if controller exists, destroy
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
        cameraDescription, ResolutionPreset.high); //init CamController

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print(
            'Camera error ${controller.value.errorDescription}'); //if error, print
      }
    });

    try {
      await controller.initialize(); //init cam
    } on CameraException catch (e) {
      print(e); //if error, print
    }

    if (mounted) {
      //update if user is still there
      setState(() {});
    }
  }

  //analyze Text for doubles
  Future<double> analyzeTextForDoubles(VisionText _visionText) async {
    double recognizedDouble;

    for (TextBlock block in _visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          String e = element.text.toString();
          if (e.contains(',')) {
            e = e.replaceAll(',', '.');
            recognizedDouble = double.parse(e);
          } else if (e.contains('.')) {
            recognizedDouble = double.parse(e).abs();
          }
        }
      }
    }
    return recognizedDouble;
  }

  //take picture and recognize Text
  void takePictureAndRecognizeText() async {
    try {
      // Ensure that the camera is initialized.
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.jpg',
      );

      await controller.takePicture(path);

      int dif = MediaQuery.of(context).size.height.round() -
          MediaQuery.of(context).size.width.round();

      //crop image acroding to scan rectangle
      im.Image imageFile = im.decodeJpg(File(path).readAsBytesSync());
      im.Image croppedImg = im.copyCrop(imageFile, 150, dif + 125, 400, 200);
      File(path).writeAsBytesSync(im.encodeJpg(croppedImg));
      File img = new File(path);

      //process text from image
      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(img);
      final TextRecognizer textRecognizer =
          FirebaseVision.instance.textRecognizer();
      final VisionText visionText =
          await textRecognizer.processImage(visionImage);

      recognizedNum = await analyzeTextForDoubles(visionText);
      textRecognizer.close();
  
      //output doubles on next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DisplayOCRScreen(imagePath: path, num: recognizedNum),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  //actual whole screen
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        cameraPreviewWidget(controller, context), //actual camera preview
        CustomPaint(
          painter: Painter(context), //painter for blue scan-rectangle
        ),
        Container(
          padding: EdgeInsets.only(top: 370, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
              Row(
                children: <Widget>[
                  Text(
                    'Enter new discount:  ', //text for new %
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  Container(
                    width: 50,
                    child: TextField(
                      //editfield for %
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black),
                      decoration: new InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      onSubmitted: (String a) {
                        setState(() {
                          percentage = double.parse(a);
                          if (percentage > 100 || percentage < 0) {
                            percentage = 0; 
                          }
                        });
                      },
                    ),
                  )
                ],
              ),
              Container(height: 40), //space
            ],
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 80.0,
                height: 80.0,
                child: FloatingActionButton(
                  //fab for taking pics
                  onPressed: () async {
                    takePictureAndRecognizeText();
                  },
                  backgroundColor: Colors.white30,
                  shape: new RoundedRectangleBorder(
                    //style for fab
                    borderRadius: new BorderRadius.circular(100.0),
                    side: BorderSide(
                        color: Colors.white,
                        width: 2,
                        style: BorderStyle.solid),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
