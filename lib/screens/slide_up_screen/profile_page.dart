import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:supermanager/models/user.dart';

List list = [
  'Loading',
  'General Manager',
  'Manager',
  'Department Manager',
];

class Profile extends StatefulWidget {
  Profile({this.onSignedOut, this.pc});

  final VoidCallback onSignedOut;
  final PanelController pc;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    isPanelOpen = widget.pc.isPanelOpen;
  }

  bool isPanelOpen;
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var userData = Provider.of<User>(context);
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.235,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Expanded(
                        flex: 15,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.photoUrl ??
                                "https://firebasestorage.googleapis.com/v0/b/supermanagerdemo.appspot.com/o/IMG-20191214-255-overlay%20ediasted.png?alt=media&token=4383650b-89d9-43a5-89da-833c67ff5995"),
                            radius: double.infinity,
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(
                              flex: 2,
                            ),
                            Expanded(
                              flex: 3,
                              child: FittedBox(
                                child: Text(
                                  userData.personalInfo['displayName'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: FittedBox(
                                child: Text(
                                  list[userData.role] +
                                      ' · ' +
                                      userData.department,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              child: InkWell(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    FittedBox(
                                      child: Text(
                                        " Update your profile",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Spacer(
                              flex: 6,
                            ),
                          ],
                        ),
                      ),
                      Spacer(
                        flex: 8,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
              width: MediaQuery.of(context).size.width,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    side: BorderSide(color: Color.fromRGBO(38, 198, 218, 1))),
                padding: EdgeInsets.symmetric(horizontal: 200),
                onPressed: () {
                  widget.pc.close();
                },
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FittedBox(
                    child: Text(
                      "Close",
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        fontSize: 126.0,
                        color: Color.fromRGBO(38, 198, 218, 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
