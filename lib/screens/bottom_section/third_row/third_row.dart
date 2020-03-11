import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermanager/models/user.dart';
import 'package:supermanager/screens/bottom_section/third_row/gesture_card.dart';

class ThirdRow extends StatelessWidget {
  final FirebaseUser user;
  final Function onChatSelected;
  const ThirdRow({Key key, this.user, this.onChatSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (_, userData, __) => StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .where('role', isGreaterThanOrEqualTo: userData.role)
            .where('department', isEqualTo: userData.department)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) => Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(3, 4),
                    blurRadius: 6.0,
                    spreadRadius: 0.3)
              ]),
              child: VerticalDivider(
                color: Colors.black12,
                width: 1,
                endIndent: 5,
                indent: 5,
              ),
            ),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              if (snapshot.data.documents[index].data['userUID'] == user.uid)
                return Container();
              return _buildNotificationCard(
                  context,
                  snapshot.data.documents[index].data,
                  onChatSelected,
                  userData);
            },
          );
        },
      ),
    );
  }
}

_buildNotificationCard(BuildContext context, Map otherEnd,
    Function onChatSelected, User currentUser) {
  String path = currentUser.userUID.compareTo(otherEnd['userUID']) <= -1
      ? currentUser.userUID + '_to_' + otherEnd['userUID']
      : otherEnd['userUID'] + '_to_' + currentUser.userUID;
  return StreamBuilder<DocumentSnapshot>(
    stream: Firestore.instance.collection('chats').document(path).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.data == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      List chats;
      try {
        chats = snapshot.data['messages'];
      } on NoSuchMethodError {
        Firestore.instance
            .collection('chats')
            .document(path)
            .setData({'messages': []});
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: GestureCard(
          currentUser: currentUser,
          otherEnd: otherEnd,
          chats: chats,
          onChatSelected: onChatSelected,
        ),
      );
    },
  );
}
