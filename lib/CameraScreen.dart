import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


CameraController _controller;
Future<void> _initializeControllerFuture;


//CameraScreen
//Stateful
class CameraScreen extends StatefulWidget {
  final CameraDescription cam;

  const CameraScreen({
    Key key,
    @required this.cam,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}
//HomeScreen
//State
class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();

    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cam,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
        backgroundColor: Colors.blue,
      ),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.

      //backgroundColor: widget.destination.color[100],
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {

            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Container(
        height: 70.0,
        width: 70.0,
        child: FittedBox(
          child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Color(0x55ffffff),
              shape: CircleBorder(side: BorderSide(color: Color(0xffffffff), width: 2.0)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}