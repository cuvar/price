import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'DisplayOCRScreen.dart';
import 'package:image/image.dart' as im;

import 'Painter.dart';
//import 'package:flutter_native_image/flutter_native_image.dart';



// TODO: Comment CameraPage.dart
// TODO: Parse doubles from text
// TODO: recognizes numbers with ',' also as doubles
// TODO: Calculation



class CameraPage extends StatefulWidget {
  CameraPage({Key key}) : super(key: key);

  @override
  _CameraPageState createState() => new _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  String recognizedText = '';

  @override
  void initState() {
    //initState
    super.initState();
    availableCameras().then((availableCameras) {
      //get available cams
      cameras = availableCameras; //get cam
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

  Future _initCameraController(CameraDescription cameraDescription) async {
    //init CamController
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

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

  Widget _cameraPreviewWidget() {
    //CameraView
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        //text while loading cam
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    var size = MediaQuery.of(context).size.width;
    return Container(
      width: size,
      height: size,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
              width: size,
              height: size / controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        _cameraPreviewWidget(),
        CustomPaint(
          painter: Painter(context),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 80.0,
                height: 80.0,
                child: FloatingActionButton(
                  onPressed: () async {
                    try {
                      // Ensure that the camera is initialized.
                      final path = join(
                        (await getTemporaryDirectory()).path,
                        '${DateTime.now()}.jpg',
                      );

                      await controller.takePicture(path);

                      int dif = MediaQuery.of(context).size.height.round() - MediaQuery.of(context).size.width.round();

                      im.Image imageFile =
                          im.decodeJpg(File(path).readAsBytesSync());
                      im.Image croppedImg =
                          im.copyCrop(imageFile, 150, dif + 125, 400, 200);

                      File(path).writeAsBytesSync(im.encodeJpg(croppedImg));
                      File img = new File(path);

                      final FirebaseVisionImage visionImage =
                          FirebaseVisionImage.fromFile(img);
                      final TextRecognizer textRecognizer =
                          FirebaseVision.instance.textRecognizer();
                      final VisionText visionText =
                          await textRecognizer.processImage(visionImage);

                      recognizedText = visionText.text;

                      /*for (TextBlock block in visionText.blocks) {
                        final Rect boundingBox = block.boundingBox;
                        final List<Offset> cornerPoints = block.cornerPoints;
                        final String text = block.text;
                        final List<RecognizedLanguage> languages =
                            block.recognizedLanguages;

                        for (TextLine line in block.lines) {
                          // Same getters as TextBlock
                          for (TextElement element in line.elements) {
                            // Same getters as TextBlock
                          }
                        }
                      }*/

                      textRecognizer.close();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayOCRScreen(
                              imagePath: path, text: recognizedText),
                        ),
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  backgroundColor: Colors.white30,
                  shape: new RoundedRectangleBorder(
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
