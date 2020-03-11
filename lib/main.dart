import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:supermanager/authentication/auth_root.dart';
import 'package:flutter/services.dart';

import 'models/user.dart';

void main() {
  //Provider.debugCheckInvalidValueType = null;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // Make user stream available
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
        value: FirebaseAuth.instance.onAuthStateChanged, child: AuthRoot());
  }
}
