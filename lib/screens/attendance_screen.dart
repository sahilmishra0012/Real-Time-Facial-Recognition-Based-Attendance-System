import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({
    Key key,
    @required this.result,
    @required this.rollNumber,
    @required this.subjectCode,
  }) : super(key: key);

  final bool result;
  final String rollNumber;
  final String subjectCode;

  @override
  AttendanceState createState() {
    return new AttendanceState(result, rollNumber, subjectCode);
  }
}

class AttendanceState extends State<AttendanceScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  bool result;
  String rollNumber;
  String subjectCode;
  DateTime displayDate;
  bool isMarked = false;
  List attendees;

  AttendanceState(this.result, this.rollNumber, this.subjectCode);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    DateTime displayDate = new DateTime(now.year, now.month, now.day);

    if (result) {
      return FutureBuilder(
        future: databaseReference
            .child("attendance")
            .child(widget.subjectCode)
            .child(displayDate.toString().split(" ")[0])
            .once(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.value != null) {
              if (snapshot.data.value.contains(rollNumber)) {
                print(snapshot.data.value.length);

                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    height: 350,
                    decoration: BoxDecoration(
                        color: Colors.yellow[900],
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              'assets/double-tick.png',
                              height: MediaQuery.of(context).size.height / 6,
                              width: MediaQuery.of(context).size.height / 6,
                            ),
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.yellow[900],
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12))),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Attendance Already Marked!!',
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
                            'Your attendance has already been marked. Kindly return to the home page.',
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
                                Navigator.of(context).pop();
                              },
                              child: Text('Exit'),
                              color: Colors.white,
                              textColor: Colors.yellow[900],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              } else {
                print(snapshot.data.value.length);
                FirebaseDatabase.instance
                    .reference()
                    .child("attendance")
                    .child(widget.subjectCode)
                    .child(displayDate.toString().split(" ")[0])
                    .update(
                        {(snapshot.data.value.length).toString(): rollNumber});

                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    height: 350,
                    decoration: BoxDecoration(
                        color: Colors.yellow[400],
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              'assets/tick.png',
                              height: MediaQuery.of(context).size.height / 6,
                              width: MediaQuery.of(context).size.height / 6,
                            ),
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.yellowAccent[400],
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12))),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Attendance Marked!!',
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
                            'Kindly return to the home page.',
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
                                Navigator.of(context).pop();
                              },
                              child: Text('Exit'),
                              color: Colors.white,
                              textColor: Colors.green[400],
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(
                      color: Colors.green[400],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/tick.png',
                            height: MediaQuery.of(context).size.height / 6,
                            width: MediaQuery.of(context).size.height / 6,
                          ),
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.green[400],
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        'Attendance Marked!!',
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
                          'Kindly return to the home page.',
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
                              Navigator.of(context).pop();
                            },
                            child: Text('Exit'),
                            color: Colors.white,
                            textColor: Colors.green[400],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          } else if (snapshot.hasError)
            return Container();
          else if (snapshot.connectionState == ConnectionState.waiting)
            return SpinKitPouringHourglass(
              color: Colors.blue,
              size: MediaQuery.of(context).size.height / 4,
            );
          return Container();
        },
      );
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
                'Attendance Not Marked!!',
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
                  'Kindly go back and retake your picture.',
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
                    child: Text('Retake Picture'),
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
