import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facial_recognition_attendance/utils/auth_service.dart';
import 'package:facial_recognition_attendance/screens/class_details_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  dynamic data;
  String uid;
  List subjects;
  @override
  void initState() {
    super.initState();
  }

  String result = "Click on Scan Button to Scan the QR Code";

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      DocumentSnapshot data = await users.doc(uid).get();
      setState(() {
        result = qrResult;
        subjects = data['subjects'];
      });
      await secondPageRoute();
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = " ";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  secondPageRoute() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ClassDetailsScreen(
        result: result,
        subjects: subjects,
      );
    }));
  }

  Future<Widget> _getImage(BuildContext context, String downloadUrl) async {
    Image m;
    m = Image.network(
      downloadUrl.toString(),
      fit: BoxFit.scaleDown,
    );

    return m;
  }

// Text((context.watch<User>().uid).toString())
  @override
  Widget build(BuildContext context) {
    setState(() {
      uid = (context.watch<User>().uid).toString();
    });
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/logo/logo_a.png',
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.width / 7,
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: Text(
              "Sign Out",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
            ),
            Container(
              child: Text(
                "STUDENT PROFILE",
                style: new TextStyle(
                  fontSize: 30.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
            ),
            Container(
              alignment: Alignment.center,
              child: FutureBuilder(
                future: users.doc((context.watch<User>().uid).toString()).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return FutureBuilder(
                      future: _getImage(context, snapshot.data.data()['photo']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done)
                          return Container(
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 4.5,
                              right: MediaQuery.of(context).size.width / 4.5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: snapshot.data,
                          );
                        else if (snapshot.hasError)
                          return Container();
                        else if (snapshot.connectionState ==
                            ConnectionState.waiting)
                          return SpinKitWave(
                            color: Colors.blue,
                            size: 50.0,
                          );
                        return Container();
                      },
                    );
                  return Container();
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 15,
                  right: MediaQuery.of(context).size.width / 15),
              child: FutureBuilder(
                future: users.doc((context.watch<User>().uid).toString()).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Name: " + snapshot.data.data()['displayName'],
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  return Container();
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 15,
                  right: MediaQuery.of(context).size.width / 15),
              child: FutureBuilder(
                future: users.doc((context.watch<User>().uid).toString()).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Roll Number: " + snapshot.data.data()['rollNumber'],
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  return Container();
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 15,
                  right: MediaQuery.of(context).size.width / 15),
              child: FutureBuilder(
                future: users.doc((context.watch<User>().uid).toString()).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Degree: " + snapshot.data.data()['degree'],
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  return Container();
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 15,
                  right: MediaQuery.of(context).size.width / 15),
              child: FutureBuilder(
                future: users.doc((context.watch<User>().uid).toString()).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Branch: " + snapshot.data.data()['branch'],
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  return Container();
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 15,
                  right: MediaQuery.of(context).size.width / 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text(
                    "Email ID: " + (context.watch<User>().email).toString(),
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 15,
                  right: MediaQuery.of(context).size.width / 15),
              child: FutureBuilder(
                future: users.doc((context.watch<User>().uid).toString()).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Contact Number: " +
                              snapshot.data.data()['contactNumber'],
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: Icon(Icons.qr_code_scanner),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
