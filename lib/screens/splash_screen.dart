import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:facial_recognition_attendance/screens/auth/login_screen.dart';
import 'package:facial_recognition_attendance/screens/student_profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key key,
    @required this.loginState,
  }) : super(key: key);

  final User loginState;
  @override
  _SplashScreenState createState() => _SplashScreenState(loginState);
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  User loginState;
  _SplashScreenState(this.loginState);
  AnimationController _circularController;
  @override
  void initState() {
    super.initState();
    _circularController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    _circularController.repeat();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    if (loginState == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AuthScreen()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(width);
    print(height);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/logo/logo.png',
                    width: 2 * width / 2.0,
                    height: 2 * width / 2.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.02),
                  ),
                  Text(
                    "Facial Recognition Based Attendance System",
                    style: TextStyle(
                      fontFamily: 'HorizonRounded',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: SpinKitWave(
                color: Color(0xff469CA7),
                controller: AnimationController(
                    vsync: this, duration: const Duration(milliseconds: 1200)),
                size: 50.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
