import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermanager/navigation/nav_root.dart';

import 'package:supermanager/screens/auth_screen/login_page.dart';

class AuthRoot extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AuthRootPageState();
}

class _AuthRootPageState extends State<AuthRoot> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    switch (loggedIn) {
      case false:
        return new LoginPage();
        break;
      case true:
        return NavigationRoot();
    }
  }
}
