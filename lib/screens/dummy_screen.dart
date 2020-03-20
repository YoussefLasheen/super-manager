import 'package:flutter/material.dart';
class DummyPage extends StatelessWidget {
  const DummyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Spacer(),
          Expanded(flex:5,child: FittedBox(child: Text("Select a contact",style: TextStyle(color: Colors.black54),))),
          Spacer()
        ],
      ),
    );
  }
}