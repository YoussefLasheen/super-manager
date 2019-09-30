import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'authentication.dart';
import 'infoCard.dart';

class profile_page extends StatefulWidget {
  profile_page({Key key, this.auth, this.userId, this.userEmail,this.userPhotoUrl, this.onSignedOut, this.pc})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String userEmail;
  final String userPhotoUrl;
  final PanelController pc;

  @override
  _profile_pageState createState() => _profile_pageState();
}

class _profile_pageState extends State<profile_page> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                widget.userPhotoUrl??"https://cdn1.iconfinder.com/data/icons/user-pictures/100/unknown-512.png"),
            radius: avatarSizing(),
          ),
        ),
        InfoCard(
          text: widget.userEmail,
          icon: Icons.email,
        ),
        InfoCard(
          text: "gdcegypt.com",
          icon: Icons.web,
        ),
        InfoCard(
          text: 'Cairo, Egypt',
          icon: Icons.location_city,
        ),
        FlatButton(
                onPressed: () {
                  widget.pc.close();
                  setState(() {});
                },
                color: Colors.white,
                child: Text(
                  "Close",
                  style: TextStyle(
                    fontFamily: 'Source Sans Pro',
                    fontSize: 20.0,
                    color: Color.fromRGBO(38, 198, 218, 1),
                  ),
                ),
              ),
        FlatButton(child: Text("Signout"),
        onPressed: ()async{
          await widget.auth.signOut().then((_){
            widget.onSignedOut();
            });
  },
        )
      ],
    );
  }
var i =1;
  double avatarSizing() {
    if (widget.pc.isPanelClosed()) {
      i =3;
    }
    /*if (widget.pc.getPanelPosition() == 1) {
      return MediaQuery.of(context).size.width * 0.1;
    } else if (widget.pc.getPanelPosition() > 0.264) {
      return MediaQuery.of(context).size.width * 0.3;
    } else {
      return MediaQuery.of(context).size.width * 0.1;
    }*/
    if (i==1) {
      i++;
      return MediaQuery.of(context).size.width * 0.3;
    } else if (i ==2) {
      i++;
      return MediaQuery.of(context).size.width * 0.1;
    } else {
      i=1;
      return MediaQuery.of(context).size.width * 0.1;
    }
  }
}
