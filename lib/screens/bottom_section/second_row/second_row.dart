import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supermanager/models/task.dart';
import 'package:supermanager/screens/bottom_section/second_row/add_task_card.dart';
import 'package:supermanager/screens/bottom_section/second_row/task_card.dart';

class SecondRow extends StatelessWidget {
  final FirebaseUser user;
  const SecondRow({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(user.uid)
            .collection('Data')
            .document('Data')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return PageView.builder(
            controller: PageController(initialPage: 0, viewportFraction: 0.95),
            itemBuilder: (BuildContext context, int index) {
              //String key = snapshot.data['Tasks'].keys.elementAt(index);
              var keys = snapshot.data['Tasks'].keys.toList();
              if (index == snapshot.data['Tasks'].length)
                return AddPageCard(
                  color: Colors.blueGrey,
                  userUID: user.uid,
                );
              var val = snapshot.data['Tasks'][keys[index]];
              return TaskCard(
                task: Task(val['title'],
                    desc: val['desc'],
                    codePoint: val['codePoint'],
                    color: val['isCompleted'] ? 0x42000000 : val['color'],
                    dueDate: val['dueDate']?.toDate(),
                    id: keys[index],
                    isCompleted: val['isCompleted']),
                todos: val['todos'],
                taskCompletionPercent: val['todos'].length == 0
                    ? 0
                    : 100 - ((val['todos'].where((user) => user['isCompleted'] == false).length /val['todos'].length) *100).toInt(),
                totalTodos: val['todos'].length,
              );
            },
            itemCount: snapshot.data['Tasks'].length + 1,
          );
        },
      ),
    );
  }
}
