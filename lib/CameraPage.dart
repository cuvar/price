import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'DisplayOCRScreen.dart';

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
    super.initState();
    // 1
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          // 2
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      // 3
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  // 1, 2
  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    // 3
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    // 4
    controller.addListener(() {
      // 5
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    // 6
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      //_showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    final deviceRatio = (size.width) / size.height;
    return Transform.scale(
      scale: controller.value.aspectRatio / deviceRatio,
      child: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        _cameraPreviewWidget(),
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
                        '${DateTime.now()}.png',
                      );

                      await controller.takePicture(path);

                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DisplayPictureScreen(imagePath: path),
                        ),
                      );*/

                      final File imageFile =
                          new File(path); //getImageFile(path);
                      final FirebaseVisionImage visionImage =
                          FirebaseVisionImage.fromFile(imageFile);
                      final TextRecognizer textRecognizer =
                          FirebaseVision.instance.textRecognizer();
                      final VisionText visionText =
                          await textRecognizer.processImage(visionImage);

                      recognizedText = visionText.text;
                      for (TextBlock block in visionText.blocks) {
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
                      }
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


