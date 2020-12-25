import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:facial_recognition_attendance/config/palette.dart';
import 'package:facial_recognition_attendance/screens/auth/login_screen.dart';
import 'package:facial_recognition_attendance/screens/student_profile.dart';
import 'package:facial_recognition_attendance/utils/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        routes: <String, WidgetBuilder>{
          '/barcode': (context) => HomeScreen(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Mark Your Presence',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.muliTextTheme(),
          accentColor: Palette.darkOrange,
          appBarTheme: const AppBarTheme(
            brightness: Brightness.dark,
            color: Palette.darkBlue,
          ),
        ),
        home: const AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser == null) {
      return AuthScreen();
    } else {
      return HomeScreen();
    }
  }
}
