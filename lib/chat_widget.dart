//import 'chat.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  final Map chat;
  final bool isReceived;
  final bool showUser;
  final bool isSuccessful;
  const ChatWidget({Key key,@required this.chat,this.isReceived=false, this.showUser=true, this.isSuccessful=true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding:  EdgeInsets.symmetric(vertical: 6.0,horizontal: 12.0),
          child: isReceived?_buildReceivedMessage(context):_buildSentMessage(context),
        ),
      ],
    );
  }
  Widget _buildSentMessage(BuildContext context){
    Color sendColor= isSuccessful? Color(0xff0084FF): Color(0xfff48024);
    return Container(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width*3/4 ),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(color: sendColor,borderRadius: BorderRadius.circular(25.0),),
        child: Text(chat['content'],style: TextStyle(fontSize: 18.0,color: Colors.white),),
      ),
    );
  }

  Widget _buildReceivedMessage(BuildContext context){
    Color receivedColor=Color(0x99eeeeee);
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          isReceived&&showUser?Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(backgroundImage: NetworkImage('chat.from.profilePicture'),radius: 12.0,),
          ):Container(width: 32.0,height: 24.0,),
          Container(
            constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width*3/4 ),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(color: receivedColor,borderRadius: BorderRadius.circular(25.0),),
            child: Text(chat['content'],style: TextStyle(fontSize: 18.0,color: Colors.black),),
          ),
        ],
      ),
    );
  }
}