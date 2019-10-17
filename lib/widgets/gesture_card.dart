import 'package:flutter/material.dart';
import 'dart:math';

import 'package:supermanager/models/user.dart';

List list = [
  'Head',
  'Manager',
  'Department Manager',
];

class GestureCard extends StatefulWidget {
  final User currentUser;
  final Map otherEnd;
  final List chats;
  final Function onChatSelected;

  const GestureCard(
      {
      this.otherEnd,
      this.chats,
      this.onChatSelected,
      this.currentUser});
  @override
  State<StatefulWidget> createState() => GestureCardState();
}

class GestureCardState extends State<GestureCard> {
  double value = 0.0;
  bool state = false;
  @override
  Widget build(BuildContext context) {
    ValueChanged<double> onChanged =
        (double newvalue) => setState(() => value = newvalue);
    ValueChanged<bool> onStateChanged =
        (bool newstate) => setState(() => state = newstate);
    double radtoper = value / pi;
    double angle = radtoper.isNegative ? radtoper / 2 * -1 : 1 - radtoper / 2;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.onChatSelected(widget.otherEnd['userUID']),
      onLongPressStart: (LongPressStartDetails details) {
        onChanged(-0);
        onStateChanged(true);
      },
      onLongPressEnd: (LongPressEndDetails details) {
        onStateChanged(false);
      },
      onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
        double changeInR = -details.localOffsetFromOrigin.direction;
        onChanged(changeInR);
      },
      child: Stack(
        children: <Widget>[
          NotificationCard(
            widget.otherEnd['personalInfo']['displayName'],
            list[widget.otherEnd['role']] +
                ' of ' +
                widget.otherEnd['department'],
            widget.otherEnd['role'] > widget.currentUser.role ? true : false,
            widget.chats.lastWhere(
              (element) => element['sender'] == widget.otherEnd['userUID'],
              orElse: () => {
                'content': "No Recent messages",
                'date': null,
                'sender': 'noone'
              },
            ),
          ),
          state == false
              ? Container()
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black38,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CircularProgressIndicator(
                            value: angle + 0.02,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          (angle * 100).toStringAsFixed(0) + "%",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Source Sans Pro',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String senderName;
  final String senderDesc;
  final Map message;
  final bool isDownStream;

  const NotificationCard(
    this.senderName,
    this.senderDesc,
    this.isDownStream,
    this.message,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            "$senderName",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CircularProgressIndicator(
                              value: isDownStream == false ? 0 : 1,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        senderDesc,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(
            flex: 2,
          ),
          Expanded(
            flex: 10,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    message['date'] == null
                        ? "Never Texted you"
                        : DateTime.now()
                                    .difference(message['date'].toDate())
                                    .inMinutes <
                                60
                            ? DateTime.now()
                                    .difference(message['date'].toDate())
                                    .inMinutes
                                    .toString() +
                                " Minutes ago:"
                            : DateTime.now()
                                    .difference(message['date'].toDate())
                                    .inHours
                                    .toString() +
                                " Hours ago:",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    message['content'],
                    overflow: TextOverflow.fade,
                    maxLines: 3,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
