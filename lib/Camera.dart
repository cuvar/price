import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
  
  
  //the cameraView itelf
  Widget cameraPreviewWidget(CameraController c, BuildContext context) {
    //CameraView
    if (c == null || !c.value.isInitialized) {
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
            child: Container( //crops camera preview
              width: size,
              height: size / c.value.aspectRatio,
              child: CameraPreview(c),   //actual preview
            ),
          ),
        ),
      ),
    );
  }