import 'package:flutter/material.dart';
import 'package:facial_recognition_attendance/utils/rsa_algorithm.dart';
import 'package:facial_recognition_attendance/utils/aes_algorithm.dart';
import 'package:facial_recognition_attendance/services/facenet.service.dart';
import 'package:facial_recognition_attendance/services/ml_vision_service.dart';
import 'package:facial_recognition_attendance/screens/camera_screen.dart';

import 'package:camera/camera.dart';

import 'package:permission_handler/permission_handler.dart';

class ClassDetailsScreen extends StatefulWidget {
  const ClassDetailsScreen({
    Key key,
    @required this.result,
    @required this.subjects,
    @required this.rollNumber,
  }) : super(key: key);

  final String result;
  final List subjects;
  final String rollNumber;

  @override
  ClassState createState() {
    return new ClassState(result, subjects, rollNumber);
  }
}

class ClassState extends State<ClassDetailsScreen> {
  PermissionStatus _status;
  String result;
  String decrypted;
  String type = 'NaN';
  int difference = 0;
  bool subjectPresent;
  String teacher;
  String subject;
  String subjectCode;
  List subjects;
  String rollNumber;
  String time;
  DateTime systemTime, barcodeTime, displayDate;

  FaceNetService _faceNetService = FaceNetService();
  MLVisionService _mlVisionService = MLVisionService();
  CameraDescription cameraDescription;
  bool loading = false;
  ClassState(this.result, this.subjects, this.rollNumber);

  @override
  void initState() {
    super.initState();
    _startUp();
    result = result.replaceAll(" ", "+");
    decrypted = decrypt(result.split("=|")[0] + "=");
    if (decrypted != 'not-found') {
      type = decrypted.split('|')[0];
      teacher = decrypted.split('|')[1];
      subject = decrypted.split('|')[2];
      subjectCode = decrypted.split('|')[3];
      subjectPresent = subjects.contains(subjectCode);
      time = decryptAESCryptoJS(
          result.split("=|")[1], 'myPassword'); //2020-12-18-23:40:4
      barcodeTime = DateTime.parse(time);
      DateTime now = new DateTime.now();
      systemTime = new DateTime(
          now.year, now.month, now.day, now.hour, now.minute, now.second);
      difference = systemTime.difference(barcodeTime).inSeconds;
      displayDate = new DateTime(now.year, now.month, now.day);
    }

    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera)
        .then(_updateStatus);
  }

  _updateStatus(PermissionStatus value) {
    if (value != _status) {
      setState(() {
        _status = value;
      });
    }
  }

  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    _mlVisionService.initialize();

    _setLoading(false);
  }

  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (type == 'Teacher') {
      if (difference <= 10) {
        if (subjectPresent) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Class Details"),
            ),
            body: Center(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 20),
                ),
                Container(
                  child: Text(
                    "CLASS DETAILS",
                    style: new TextStyle(
                      fontSize: 30.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 7),
                ),
                Text(
                  "Faculty Name: " + teacher,
                  style: new TextStyle(
                      fontSize: 30.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30),
                ),
                Text(
                  "Subject Name: " + subject,
                  style: new TextStyle(
                      fontSize: 30.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30),
                ),
                Text(
                  "Subject Code: " + subjectCode,
                  style: new TextStyle(
                      fontSize: 30.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30),
                ),
                Text(
                  "Date: " + displayDate.toString().split(" ")[0],
                  style: new TextStyle(
                      fontSize: 30.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.camera_alt),
              label: Text("Take Your Picture"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CameraScreen(
                    cameraDescription: cameraDescription,
                    rollNumber: rollNumber,
                    subjectCode: subjectCode,
                  );
                }));
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        } else {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'assets/not-found.png',
                        height: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.height / 6,
                      ),
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12))),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Not Enrolled!',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16, left: 16),
                    child: Text(
                      'You have not enrolled for this course. Kindly contact the Academics Section.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 8,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Go Back'),
                        color: Colors.white,
                        textColor: Colors.redAccent,
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }
      } else {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 350,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/timeout.png',
                      height: MediaQuery.of(context).size.height / 6,
                      width: MediaQuery.of(context).size.height / 6,
                    ),
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12))),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  'QR Timeout!',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: Text(
                    'Kindly scan the real-time QR code provided by teacher.',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 8,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Go Back'),
                      color: Colors.white,
                      textColor: Colors.redAccent,
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }
    } else {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 350,
          decoration: BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/exclaim.png',
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.height / 6,
                  ),
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12))),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Wrong QR Scanned!',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Text(
                  'Kindly scan the QR code provided by teacher.',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 8,
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Go Back'),
                    color: Colors.white,
                    textColor: Colors.redAccent,
                  )
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}
