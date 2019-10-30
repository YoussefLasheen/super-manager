//import 'chat.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  final Map chat;
  final bool isReceived;
  final bool isSuccessful;
  const ChatWidget({Key key,@required this.chat,this.isReceived=true, this.isSuccessful=true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding:  EdgeInsets.symmetric(vertical: 6.0,horizontal: 12.0),
          child: isReceived == null?_buildSystemMessage(context):isReceived?_buildReceivedMessage(context):_buildSentMessage(context),
        ),
      ],
    );
  }
  Widget _buildSentMessage(BuildContext context){
    Color sendColor= isSuccessful? Color.fromRGBO(38, 198, 218, 1): Color(0xfff48024);
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
         child: Container(
            constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width*3/4 ),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(color: receivedColor,borderRadius: BorderRadius.circular(25.0),),
            child: Text(chat['content'],style: TextStyle(fontSize: 18.0,color: Colors.black),),
      ),
    );
  }
  Widget _buildSystemMessage(BuildContext context){
    return Container(
                padding: EdgeInsets.only(top:50),
                alignment: Alignment.center,
                child: Container(
                  constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width*3/4 ),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Color(0xfffff5c4),
                    borderRadius: BorderRadius.circular(15.0),),
                  child: Text(chat['content'],style: TextStyle(fontSize: 18.0,color: Colors.black54),),
                  ),
                );
  }
}