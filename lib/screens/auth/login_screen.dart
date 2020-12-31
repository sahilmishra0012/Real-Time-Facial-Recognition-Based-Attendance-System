import 'package:animations/animations.dart';
import 'package:facial_recognition_attendance/utils/auth_service.dart';
import 'package:facial_recognition_attendance/screens/student_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'widgets/background_painter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode = new FocusNode();
  ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void login() {}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool userError = false;
    bool passwordError = false;
    return Scaffold(
      backgroundColor: Color(0xff489FB5),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox.expand(
            child: CustomPaint(
              painter: BackgroundPainter(
                animation: _controller,
              ),
            ),
          ),
          Container(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ValueListenableBuilder<bool>(
                valueListenable: showSignInPage,
                builder: (context, value, child) {
                  return SizedBox.expand(
                    child: PageTransitionSwitcher(
                      reverse: !value,
                      duration: const Duration(milliseconds: 800),
                      transitionBuilder:
                          (child, animation, secondaryAnimation) {
                        return SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.vertical,
                          fillColor: Colors.transparent,
                          child: child,
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: Form(
                                autovalidateMode: AutovalidateMode.always,
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: height * 0.1),
                                    ),
                                    Image.asset(
                                      'assets/logo/logo.png',
                                      width: 2 * width / 2.5,
                                      height: 2 * width / 2.5,
                                    ),
                                    Text(
                                      "Facial Recognition Based Attendance System",
                                      style: TextStyle(
                                        fontFamily: 'HorizonRounded',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: height * 0.05),
                                    ),
                                    Container(
                                      width: 300,
                                      child: TextFormField(
                                        controller: emailController,
                                        validator: (value) =>
                                            EmailValidator.validate(value)
                                                ? null
                                                : "Please enter a valid email",
                                        onChanged: (text) {},
                                        onTap: () => {
                                          _controller.forward(),
                                        },
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          labelText: 'Email',
                                          labelStyle: TextStyle(
                                              color: myFocusNode.hasFocus
                                                  ? Colors.white
                                                  : Colors.white),
                                          icon: Icon(Icons.account_box_rounded,
                                              color: Colors.white),
                                          errorText: userError
                                              ? "User Not Found"
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                    ),
                                    Container(
                                      width: 300,
                                      child: TextFormField(
                                        controller: passwordController,
                                        onChanged: (text) {},
                                        onTap: () => {
                                          _controller.reverse(),
                                        },
                                        style: TextStyle(color: Colors.white),
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          labelText: "Password",
                                          labelStyle: TextStyle(
                                              color: myFocusNode.hasFocus
                                                  ? Colors.white
                                                  : Colors.white),
                                          icon: Icon(Icons.security,
                                              color: Colors.white),
                                          errorText: passwordError
                                              ? "Wrong Password"
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 30.0),
                                    ),
                                    Container(
                                      width: 300,
                                      height: 50,
                                      child: RaisedButton(
                                        color: Color(0xff034c5e),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.0,
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (emailController.text
                                                  .trim()
                                                  .length ==
                                              0) {
                                            return Scaffold.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Please Enter Email Address"),
                                                backgroundColor:
                                                    Color(0xff092E34),
                                              ),
                                            );
                                          } else if (passwordController.text
                                                  .trim()
                                                  .length ==
                                              0) {
                                            return Scaffold.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Please Enter Password"),
                                                backgroundColor:
                                                    Color(0xff092E34),
                                              ),
                                            );
                                          } else {
                                            await context
                                                .read<AuthenticationService>()
                                                .signIn(
                                                  email: emailController.text
                                                      .trim(),
                                                  password: passwordController
                                                      .text
                                                      .trim(),
                                                )
                                                .then(
                                              (value) {
                                                print(value);
                                                if (value == "user-not-found") {
                                                  print("User not found");
                                                  return Scaffold.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          "User Not Found"),
                                                      backgroundColor:
                                                          Color(0xff092E34),
                                                    ),
                                                  );
                                                } else if (value ==
                                                    "wrong-password") {
                                                  print("Wrong password");
                                                  return Scaffold.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          "Wrong Password"),
                                                      backgroundColor:
                                                          Color(0xff092E34),
                                                    ),
                                                  );
                                                } else {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              HomeScreen()));
                                                }
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
