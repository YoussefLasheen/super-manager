import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:supermanager/screens/auth_screen/login_page.dart';
import 'package:supermanager/screens/slide_up_screen/profile_page.dart';
class RootPage extends StatefulWidget {
  RootPage({/*this.auth ,*/this.pc ,this.pcf});

  final PanelController pc;
  final Function pcf;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}
/*
enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}
*/
class _RootPageState extends State<RootPage> {
  /*
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String _userEmail = "";
  String _userPhotoUrl = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          _userEmail = user.email;
          _userPhotoUrl = user.photoUrl;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn() {
    widget.pc.close();
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
        _userEmail = user.email;
        _userPhotoUrl = user.photoUrl;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;

    });
  }

  void _onSignedOut() {
    widget.pc.open();
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      _userEmail = "";
      _userPhotoUrl = "";
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    switch (loggedIn) {
      case false:
        return new LoginPage(
          //auth: widget.auth,
          onSignedIn: (){widget.pc.close();},
        );
        break;
      case true:
          return new Profile(
            /*
            userId: user.uid,
            userEmail: user.email,
            userPhotoUrl: user.photoUrl,
            auth: widget.auth,
            */
            onSignedOut: (){widget.pc.open();},
            pc:widget.pc
          );
    }
  }
}