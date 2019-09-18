import 'package:flutter/material.dart';
import 'authentication.dart';

class profile_page extends StatelessWidget {
  profile_page({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);
final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(child: Text("Eslam"),radius:double.infinity ,);
  }
}