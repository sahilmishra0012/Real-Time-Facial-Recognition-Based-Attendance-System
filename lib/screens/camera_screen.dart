// A screen that allows users to take a picture using a given camera.
import 'dart:async';
import 'package:facial_recognition_attendance/widgets/FacePainter.dart';
import 'package:facial_recognition_attendance/services/camera.service.dart';
import 'package:facial_recognition_attendance/services/facenet.service.dart';
import 'package:facial_recognition_attendance/services/ml_vision_service.dart';
import 'package:facial_recognition_attendance/screens/attendance_screen.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription cameraDescription;

  const CameraScreen({
    Key key,
    @required this.cameraDescription,
  }) : super(key: key);

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<CameraScreen> {
  /// Service injection
  CameraService _cameraService = CameraService();
  MLVisionService _mlVisionService = MLVisionService();
  FaceNetService _faceNetService = FaceNetService();

  Future _initializeControllerFuture;

  bool cameraInitializated = false;
  bool _detectingFaces = false;
  bool pictureTaken = false;

  // switchs when the user press the camera
  bool _saving = false;

  String imagePath;
  Size imageSize;
  Face faceDetected;

  @override
  void initState() {
    super.initState();

    /// starts the camera & start framing faces
    _start();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  /// starts the camera & start framing faces
  _start() async {
    _initializeControllerFuture =
        _cameraService.startService(widget.cameraDescription);
    await _initializeControllerFuture;

    setState(() {
      cameraInitializated = true;
    });

    _frameFaces();
  }

  /// draws rectangles when detects faces
  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          List<Face> faces = await _mlVisionService.getFacesFromImage(image);

          if (faces != null) {
            if (faces.length > 0) {
              // preprocessing the image
              setState(() {
                faceDetected = faces[0];
              });

              if (_saving) {
                _saving = false;
                _faceNetService.setCurrentPrediction(image, faceDetected);
              }
            } else {
              setState(() {
                faceDetected = null;
              });
            }
          }

          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  Future<bool> _predictUser(String uid) {
    Future<bool> faceMatched = _faceNetService.predict(uid);
    return faceMatched;
  }

  /// handles the button pressed event
  Future onShot() async {
    if (faceDetected == null) {
      showDialog(
          context: context,
          child: AlertDialog(
            content: Text('No face detected!'),
          ));

      return false;
    } else {
      imagePath =
          join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');

      _saving = true;

      await Future.delayed(Duration(milliseconds: 0));
      await _cameraService.cameraController.stopImageStream();
      await Future.delayed(Duration(milliseconds: 0));
      await _cameraService.takePicture(imagePath);

      setState(() {
        pictureTaken = true;
      });

      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    String uid = context.watch<User>().uid;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Transform.scale(
              scale: 1.0,
              child: AspectRatio(
                aspectRatio: MediaQuery.of(context).size.aspectRatio,
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Container(
                      width: width,
                      height: width /
                          _cameraService.cameraController.value.aspectRatio,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          CameraPreview(_cameraService.cameraController),
                          CustomPaint(
                            painter: FacePainter(
                                face: faceDetected, imageSize: imageSize),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: Icon(Icons.camera_alt),
        label: Text("Take Your Picture"),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            await onShot();
            var faceMatched = await _predictUser(uid);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AttendanceScreen(result: faceMatched);
            }));
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
