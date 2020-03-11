import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:supermanager/models/user.dart';

List list = [
  'Loading',
  'Head',
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
    isPanelOpen = widget.pc.isPanelOpen();
  }
  bool isPanelOpen = true;
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var userData = Provider.of<User>(context);
    return Material(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: isPanelOpen?(MediaQuery.of(context).size.height*0.95)-16: MediaQuery.of(context).size.height*0.235,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Flex(
                          direction: isPanelOpen ? Axis.vertical : Axis.horizontal,
                          children: <Widget>[
                            Expanded(
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(user.photoUrl ??
                                          "https://cdn1.iconfinder.com/data/icons/user-pictures/100/unknown-512.png"),
                                      radius: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                            Expanded(
                              flex: isPanelOpen? 1:3,
                              child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: FittedBox(
                                          child: Text(
                                            userData.personalInfo['displayName'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                ),
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: FittedBox(
                                          child: Text(
                                            list[userData.role] +
                                                ' of ' +
                                                userData.department,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                ),
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/30,
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight:Radius.circular(20)),
                            side: BorderSide(color: Color.fromRGBO(38, 198, 218, 1))
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 200),
                          onPressed: () {
                            bool newstate;
                            isPanelOpen == true? newstate = false:newstate = true;
                            isPanelOpen?widget.pc.close() : widget.pc.open();
                            setState(() {
                              isPanelOpen = newstate;
                            });
                          },
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FittedBox(
                              child: Text(
                                isPanelOpen? "Finish" : "Edit",
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}