import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermanager/models/task.dart';
import 'package:supermanager/models/user.dart';
import 'package:supermanager/screens/bottom_section/first_row/first_row.dart';
import 'package:supermanager/screens/bottom_section/second_row/add_task_card.dart';
import 'package:supermanager/screens/bottom_section/second_row/second_row.dart';
import 'package:supermanager/screens/bottom_section/second_row/task_card.dart';
import 'package:supermanager/screens/bottom_section/third_row/gesture_card.dart';
import 'package:supermanager/screens/bottom_section/third_row/third_row.dart';

class BottomSection extends StatefulWidget {
  final Function(String) onChatSelected;
  BottomSection({this.onChatSelected});

  @override
  _BottomSectionState createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Container(
      child: PageView(
        physics: BouncingScrollPhysics(),
        pageSnapping: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          FirstRow(),
          SecondRow(
            user: user,
          ),
          ThirdRow(
            user: user,
            onChatSelected: widget.onChatSelected,
          ),
        ],
      ),
    );
  }
}
